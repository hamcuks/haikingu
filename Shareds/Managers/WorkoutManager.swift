//
//  WorkoutManager.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation
import os
import HealthKit
import CoreMotion
import WatchConnectivity
import Combine

protocol WorkoutDelegate: AnyObject {
    func didUpdateHeartRate(_ heartRate: Double)
    func didUpdateDistance(_ distance: Double)
    func didUpdateSpeed(_ speed: Double)
    func didUpdateRemainingTime(_ remainingTime: TimeInterval)
    func didUpdateWhatToDo(_ whatToDo: TimingState)
    func didUpdateElapsedTimeInterval(_ elapsedTimeInterval: TimeInterval)
    func didUpdateRestAmount(_ restTaken: Int)
    func didWorkoutPaused(_ isWorkoutPaused: Bool)
}

enum TimingState {
    case timeToWalk
    case timeToRest
}

class WorkoutManager: NSObject, ObservableObject {
    
    var delegate: WorkoutDelegate?
    let pedometerManager = CMPedometer()
    
    struct SessionStateChange {
        let newState: HKWorkoutSessionState
        let date: Date
    }
    
    @Published var isWorkoutPaused: Bool = false {
        didSet{
            delegate?.didWorkoutPaused(isWorkoutPaused)
#if os(watchOS)
            sendPausedStateToIphone()
#endif
        }
    }
    @Published var restTaken: Int = 0 {
        didSet{
            delegate?.didUpdateRestAmount(restTaken)
        }
    }
    @Published var remainingTime: TimeInterval = 0 {
        didSet {
            delegate?.didUpdateRemainingTime(remainingTime)
        }
    }
    var timer: Timer?
    var endTime: Date?
    var isPaused = false
    var pausedTime: TimeInterval = 0
    @Published var whatToDo: TimingState = .timeToWalk {
        didSet {
            delegate?.didUpdateWhatToDo(whatToDo)
            print("ini to do: \(whatToDo)")
        }
    }
    @Published var sessionState: HKWorkoutSessionState = .notStarted
    var age: DateComponents?
    var maxHeartRate: Int?
    @Published var heartRate: Double = 0 {
        didSet {
            delegate?.didUpdateHeartRate(heartRate)
            if isPersonTired() {
                print("Ini orang sudah lelah, send notif")
            } else {
                print("Ini orang masih chill, lanjut jalan")
            }
        }
    }

    @Published var activeEnergy: Double = 0
    @Published var speed: Double = 0 {
        didSet {
            delegate?.didUpdateSpeed(speed)
            print("\(speed) m/s")
        }
    }
    @Published var distance: Double = 0 {
        didSet {
            delegate?.didUpdateDistance(distance)
            print("\(distance) meter")
        }
    }
    @Published var elapsedTimeInterval: TimeInterval = 0 {
        didSet {
            delegate?.didUpdateElapsedTimeInterval(elapsedTimeInterval)
        }
    }
    var currentElapsedTime : TimeInterval = 0
    var timerElapsed : Timer?
    @Published var workout: HKWorkout?

    let typesToShare: Set = [HKQuantityType.workoutType()]
    let typesToRead: Set = [
        HKCharacteristicType(.dateOfBirth),
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.walkingSpeed),
        HKQuantityType.workoutType(),
        HKObjectType.activitySummaryType()
    ]
    let healthStore = HKHealthStore()
    @Published var session: HKWorkoutSession?
#if os(watchOS)
    @Published var builder: HKLiveWorkoutBuilder?
#else
    var contextDate: Date?
#endif
    let asyncStreamTuple = AsyncStream.makeStream(of: SessionStateChange.self, bufferingPolicy: .bufferingNewest(1))

    static let shared = WorkoutManager()

    override init() {
        super.init()
        Task {
            for await value in asyncStreamTuple.stream {
                await consumeSessionStateChange(value)
            }
        }
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        getUserAge()
        getUserMaxHeartRate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        //
    }

    func getUserAge() {
        do {
            let dateOfBirth = try healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let current = Date()
            age = calendar.dateComponents([.year], from: dateOfBirth.date ?? Date(), to: current)
        } catch {
            print("Error calculating age")
        }
    }

    func getUserMaxHeartRate() {
        maxHeartRate = 220 - (age?.year ?? 23)
    }

    func isPersonTired() -> Bool {
        if heartRate > Double(maxHeartRate!) {
            return true
        } else {
            return false
        }
        
    }

    func consumeSessionStateChange(_ change: SessionStateChange) async {
        DispatchQueue.main.async {
            self.sessionState = change.newState
        }

#if os(watchOS)
        updateElapsedTimeInterval(to: self.session?.associatedWorkoutBuilder().elapsedTime(at: change.date) ?? 0)
        
        let elapsedTimeInterval = session?.associatedWorkoutBuilder().elapsedTime(at: change.date) ?? 0
        let elapsedTime = WorkoutElapsedTime(timeInterval: elapsedTimeInterval, date: change.date)
        if let elapsedTimeData = try? JSONEncoder().encode(elapsedTime) {
            await sendData(elapsedTimeData)
        }
        
        guard change.newState == .stopped, let builder else {
            return
        }

//        stopTimer()
        let finishedWorkout: HKWorkout?
        do {
            try await builder.endCollection(at: change.date)
            finishedWorkout = try await builder.finishWorkout()
            session?.end()
        } catch {
            Logger.shared.log("Failed to end workout: \(error)")
            return
        }
        DispatchQueue.main.async {
            self.workout = finishedWorkout
        }
#endif
    }
    
    func startTimer(with duration: TimeInterval, startDate date: Date) {
        remainingTime = duration
        endTime = date.addingTimeInterval(duration)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                    self?.updateRemainingTime()
#if os(watchOS)
                self?.sendRemainingTimeToiPhone()
#endif
                    
            }

        }
    }

    func updateRemainingTime() {
        guard let endTime = endTime else { return }
        remainingTime = max(endTime.timeIntervalSinceNow, 0)
        if remainingTime == 0 && whatToDo == .timeToWalk {
            timer?.invalidate()
            timer = nil
            updateWhatToDo(to: .timeToRest)
            delegate?.didUpdateWhatToDo(whatToDo)
#if os(watchOS)
            DispatchQueue.main.async {
                self.sendWhatToDoRestToiPhone()
            }
#endif
            startTimer(with: 10, startDate: Date())
        } else if remainingTime == 0 && whatToDo == .timeToRest {
            timer?.invalidate()
            timer = nil
            updateRestAmount(to: restTaken + 1)
            delegate?.didUpdateRestAmount(restTaken)
            updateWhatToDo(to: .timeToWalk)
            delegate?.didUpdateWhatToDo(whatToDo)
            
#if os(watchOS)
            DispatchQueue.main.async {
                self.sendWhatToDoWalkToiPhone()
                self.sendRestTakenToIphone()
            }
#endif
            startTimer(with: 10, startDate: Date())
        }
    }

    func pauseTimer() {
        guard timer != nil else { return }
        pausedTime = remainingTime
        stopTimer()
        isPaused = true
    }

    func resumeTimer() {
        guard isPaused else { return }
        startTimer(with: pausedTime, startDate: Date())
        isPaused = false
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        stopTimer()
        remainingTime = 0
        endTime = nil
    }
    
    // Start observe elapsep
    func startObserving() {
        DispatchQueue.main.async {
            self.timerElapsed = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
#if os(watchOS)
                self?.checkElapsedTime()
                self?.sendElapsedTimeToIphone()
#endif
            }
            
        }
    }
    
    // Stop observing
    func stopObserving() {
        timerElapsed?.invalidate()
    }
    
    func updateHeartRate(to newRate: Double) {
            heartRate = newRate
        self.delegate?.didUpdateHeartRate(newRate)
        }
        
    func updateDistance(to newDistance: Double) {
            distance = newDistance
        self.delegate?.didUpdateDistance(distance)
        }
    
    func updateSpeed(to newSpeed: Double) {
            speed = newSpeed
        self.delegate?.didUpdateSpeed(speed)
        }
    
    func updateRemainingTime(to newRemainingTime: Double) {
        remainingTime = newRemainingTime
        self.delegate?.didUpdateRemainingTime(remainingTime)
        }
    
    func updateWhatToDo(to newWhatToDo: TimingState) {
        whatToDo = newWhatToDo
        self.delegate?.didUpdateWhatToDo(whatToDo)
        }
    
    func updateElapsedTimeInterval(to newElapsedTimeInterval: TimeInterval) {
        elapsedTimeInterval = newElapsedTimeInterval
        self.delegate?.didUpdateElapsedTimeInterval(elapsedTimeInterval)
        }
    
    func updateRestAmount(to newRestTaken: Int) {
        restTaken = newRestTaken
        self.delegate?.didUpdateRestAmount(restTaken)
    }
    
}

// MARK: - Workout session management
//
extension WorkoutManager {
    func resetWorkout() {
#if os(watchOS)
        builder = nil
#endif
        workout = nil
        session = nil
        activeEnergy = 0
        heartRate = 0
        distance = 0
        speed = 0
        sessionState = .notStarted
//        resetTimer()
    }

    func sendData(_ data: Data) async {
        do {
            try await session?.sendToRemoteWorkoutSession(data: data)
        } catch {
            Logger.shared.log("Failed to send data: \(error)")
        }
    }
}

// MARK: - Workout statistics
//
extension WorkoutManager {
    func updateForStatistics(_ statistics: HKStatistics) {
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.updateHeartRate(to: statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0)
                self.delegate?.didUpdateHeartRate(self.heartRate)
                
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0

            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
                self.updateDistance(to: statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0)
                self.delegate?.didUpdateDistance(self.distance)
            default:
                return
            }
        }
    }

    func requestMotionPermission() {
        guard CMPedometer.isPaceAvailable() else {
            print("Pedometer pace data is not available.")
            return
        }
    }

    func stopPedometerUpdates() {
        pedometerManager.stopUpdates()
    }
}

// MARK: - HKWorkoutSessionDelegate
//
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        Logger.shared.log("Session state changed from \(fromState.rawValue) to \(toState.rawValue)")
        /**
         Yield the new state change to the async stream synchronously.
         asynStreamTuple is a constant, so it's nonisolated.
         */
        let sessionSateChange = SessionStateChange(newState: toState, date: date)
        asyncStreamTuple.continuation.yield(sessionSateChange)
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        Logger.shared.log("\(#function): \(error)")
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didDisconnectFromRemoteDeviceWithError error: Error?) {
        Logger.shared.log("\(#function): \(error)")
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didReceiveDataFromRemoteWorkoutSession data: [Data]) {
        Logger.shared.log("\(#function): \(data.debugDescription)")
        Task {
            do {
                for anElement in data {
                    try handleReceivedData(anElement)
                }
            } catch {
                Logger.shared.log("Failed to handle received data: \(error)")
            }
        }
    }
}

// MARK: - Elapsed Time
//
struct WorkoutElapsedTime: Codable {
    var timeInterval: TimeInterval
    var date: Date
}

// MARK: - Convenient workout state
//
extension HKWorkoutSessionState {
    var isActive: Bool {
        self != .notStarted && self != .ended
    }
}
