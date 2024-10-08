//
//  WorkoutManager+watchOS+Extension.swift
//  Haikingu Watch App
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation
import os
import HealthKit
import CoreMotion
import WatchConnectivity

// MARK: - Workout session management
//

extension WorkoutManager: WCSessionDelegate, WorkoutServiceWatchOS {
    
    
    func setDelegateVMHome(_ delegate: any WorkoutVMHomeDelegate) {
        self.delegateVMHome = delegate
    }
    
    func setDelegateVMMetrics(_ delegate: any WorkoutVMMetricsDelegate) {
        self.delegateVMMetrics = delegate
    }
    
    func setDelegateVMSummary(_ delegate: any WorkoutVMSummaryDelegate) {
        self.delegateVMSummary = delegate
    }
    
    
    /**
     Use healthStore.requestAuthorization to request authorization in watchOS when
     healthDataAccessRequest isn't available yet.
     */
    func requestAuthorization() {
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
            } catch {
                Logger.shared.log("Failed to request authorization: \(error)")
            }
        }
    }
    
    func startWorkout(workoutConfiguration: HKWorkoutConfiguration) async throws {
        session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
        builder = session?.associatedWorkoutBuilder()
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)
        /**
         Start mirroring the session to the companion device.
         */
        session?.prepare()
        try await session?.startMirroringToCompanionDevice()
        /**
         Start the workout session activity.
         */
        let startDate = Date()
        session?.startActivity(with: startDate)
        try await builder?.beginCollection(at: startDate)
        startTimer(with: 1500, startDate: startDate)
        startObserving()
        startPedometerUpdates()
        
    }
    
    func reqMotionAccess() {
        guard CMPedometer.isPaceAvailable() else {
            return
        }
    }
    
    func startPedometerUpdates() {
        guard CMPedometer.isPaceAvailable() else {
            print("Pedometer pace data is not available.")
            return
        }
        
        pedometerManager.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self, error == nil else {
                print("Error receiving pedometer updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                // Update speed with current walking/running pace (speed in m/s)
                if data?.currentPace == nil || data?.distance == 0 {
                    self.speed = 0
                } else {
                    // Convert speed from m/s to km/h
                    self.speed = (data?.currentPace?.doubleValue)! * 3.6
                }
                
                let message = ["speed": self.speed] as [String: Any]
                do {
                    try WCSession.default.updateApplicationContext(message)
                } catch {
                    print("error sending data remaining via app context: \(error.localizedDescription)")
                }
                
                print("Current walking speed: \(self.speed) km/h")
                
            }
        }
    }
    
    func handleReceivedData(_ data: Data) throws {
        guard (try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQuantity.self, from: data)) != nil else {
            return
        }
    }
    
    func updateStartedWorkout(to newIsWorkoutStarted: Bool) {
        isWorkoutStarted = newIsWorkoutStarted
        sendStartToIphone()
    }
    
    // Check the elapsed time and notify delegate if it changes
    func checkElapsedTime() {
        
        let newElapsedTime = builder?.elapsedTime
        
        if newElapsedTime != currentElapsedTime {
            currentElapsedTime = newElapsedTime!
            updateElapsedTimeInterval(to: newElapsedTime!)
        }
    }
    
    func updateIsWorkoutPaused(to newIsWorkoutPaused: Bool) {
        isWorkoutPaused = newIsWorkoutPaused
    }
    
    func updateIsWorkoutEnded(to newIsWorkoutEnded: Bool) {
        isWorkoutEnded = newIsWorkoutEnded
    }
    
    func stopWorkoutWatch() async {
        let finishedWorkout: HKWorkout?
        do {
            try await builder?.endCollection(at: .now)
            finishedWorkout = try await builder?.finishWorkout()
            session?.end()
        } catch {
            print("gagal stop workout")
            return
        }
        DispatchQueue.main.async {
            self.workout = finishedWorkout
            print(self.workout?.averageHeartRate)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let paused = applicationContext["triggerPaused"] as? String {
            DispatchQueue.main.async {
                self.isWorkoutPaused = true
                self.pauseTimer()
            }
            
        } else if let resume = applicationContext["triggerResume"] as? String {
            DispatchQueue.main.async {
                self.isWorkoutPaused = false
                self.resumeTimer()
            }
        } else if let ended = applicationContext["triggerEnded"] as? String {
            DispatchQueue.main.async {
                self.isWorkoutEnded = true
                self.stopTimer()
                self.stopObserving()
            }
        } else if let destination = applicationContext["destination"] as? String {
            DispatchQueue.main.async {
                self.selectedDestinationName = destination
                self.delegateVMHome?.didUpdateDestinationWatch(destination)
            }
        }  else if let elevmin = applicationContext["elevmin"] as? Int {
            DispatchQueue.main.async {
                self.selectedDestinationElevMin = elevmin
            }
        } else if let maxelev = applicationContext["maxelev"] as? Int {
            DispatchQueue.main.async {
                self.selectedDestinationElevMax = maxelev
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let start = message["isStart"] as? Bool {
            DispatchQueue.main.async {
                self.isWorkoutStarted = start
                self.delegateVMHome?.didWorkoutStarted(self.isWorkoutStarted)
            }
        }else if let back = message["isBackToHome"] as? Bool {
            DispatchQueue.main.async {
                if back {
                    self.isBackToHome = true
                    self.delegateVMSummary?.didBackToHome(self.isBackToHome)
                }
            }
        } else if let roleLeader = message["roleLeader"] as? String {
            DispatchQueue.main.async {
                self.role = .leader
                self.delegateVMMetrics?.didRoleChanged(self.role)
            }
        } else if let roleMember = message["roleMember"] as? String {
            DispatchQueue.main.async {
                self.role = .member
                self.delegateVMMetrics?.didRoleChanged(self.role)
            }
        }
    }
    
}
// MARK: - HKLiveWorkoutBuilderDelegate
// HealthKit calls the delegate methods on an anonymous serial background queue,
// so the methods need to be nonisolated explicitly.
//
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    
    nonisolated func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        /**
         HealthKit calls this method on an anonymous serial background queue.
         Use Task to provide an asynchronous context so MainActor can come to play.
         */
        Task { @MainActor in
            var allStatistics: [HKStatistics] = []
            
            for type in collectedTypes {
                if let quantityType = type as? HKQuantityType, let statistics = workoutBuilder.statistics(for: quantityType) {
                    updateForStatistics(statistics)
                    allStatistics.append(statistics)
                }
            }
            
            let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: allStatistics, requiringSecureCoding: true)
            guard let archivedData = archivedData, !archivedData.isEmpty else {
                Logger.shared.log("Encoded hiking data is empty")
                return
            }
            /**
             Send a Data object to the connected remote workout session.
             */
            //                sendElapsedTimeToIphone()
        }
        //            self.elapsedTimeInterval = builder?.elapsedTime ?? 0
                self.sendDistanceToIphone()
    }
    
    nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
}

extension WorkoutManager {
    
    func sendRemainingTimeToiPhone() {
        if WCSession.default.isReachable {
            let message = [
                "timerStart": remainingTime
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
            } catch {
                print("error sending data remaining via app context: \(error.localizedDescription)")
            }
            
        }
    }
    
    func sendWhatToDoWalkToiPhone() {
        var state: Int = 0
        if WCSession.default.isReachable {
            let message = [
                "toDoWalk": state
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
                state += 1
            } catch {
                print("error sending data walk reminder via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendWhatToDoRestToiPhone() {
        var state: Int = 0
        if WCSession.default.isReachable {
            let message = [
                "toDoRest": state
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
                state += 1
            } catch {
                print("error sending data rest reminder via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendElapsedTimeToIphone() {
        if WCSession.default.isReachable {
            let message = [
                "elapsed": elapsedTimeInterval
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
            } catch {
                print("error sending data elapsed via app context: \(error.localizedDescription)")
            }
            
        }
    }
    
    func sendRestTakenToIphone() {
        if WCSession.default.isReachable {
            let message = [
                "restTaken": restTaken
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendDistanceToIphone() {
        if WCSession.default.isReachable {
            let message = [
                "distance": distance
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
            } catch {
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendPausedStateToIphone() {
        if WCSession.default.isReachable {
            let message = [
                "isWorkoutPaused": isWorkoutPaused
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
            } catch {
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendEndedStateToIphone() {
        if WCSession.default.isReachable {
            let message = [
                "isWorkoutEnded": isWorkoutEnded
            ] as [String: Any]
            do {
                try WCSession.default.updateApplicationContext(message)
            } catch {
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendStartToIphone() {
        if WCSession.default.isReachable {
            let message = [
                "isWorkoutStart": isWorkoutStarted
            ] as [String: Any]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
    }
}
