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

extension WorkoutManager: WCSessionDelegate, WorkoutServiceWatchOS{

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
        try await session?.startMirroringToCompanionDevice()
        /**
         Start the workout session activity.
         */
        let startDate = Date()
        session?.startActivity(with: startDate)
        try await builder?.beginCollection(at: startDate)
        startTimer(with: 10, startDate: startDate)
        startPedometerUpdates()
        
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
                if let currentPace = data?.currentPace {
                    // Convert speed from m/s to km/h
                    self.speed = currentPace.doubleValue * 3.6
                    let message = [
                        "speed": self.speed,
                    ] as [String : Any]
                    WCSession.default.sendMessage(message, replyHandler: nil){ error in
                        print("Error sending message: \(error.localizedDescription)")
                    }
                    print("Current walking speed: \(self.speed) km/h")
                }
            }
        }
    }
    
    func handleReceivedData(_ data: Data) throws {
        guard let decodedQuantity = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQuantity.self, from: data) else {
            return
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
            await sendData(archivedData)
        }
    }
    
    nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
}


extension WorkoutManager{
    func sendRemainingTimeToiPhone() {
        if WCSession.default.isReachable {
            let message = [
                "timerStart": remainingTime,
            ] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Error sending timer data: \(error.localizedDescription)")
            })
        }
    }


}
