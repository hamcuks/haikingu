//
//  WorkoutManager+iOS+Extension.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation
import os
import HealthKit
import WatchConnectivity

// MARK: - Workout session management
//
extension WorkoutManager: WorkoutServiceIos {
    
    func startWatchWorkout(workoutType: HKWorkoutActivityType) async throws {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        try await healthStore.startWatchApp(toHandle: configuration)
    }
    
    func retrieveRemoteSession() {
        /**
         HealthKit calls this handler when a session starts mirroring.
         */
        healthStore.workoutSessionMirroringStartHandler = { mirroredSession in
            Task { @MainActor in
                self.resetWorkout()
                self.session = mirroredSession
                self.session?.delegate = self
                Logger.shared.log("Start mirroring remote session: \(mirroredSession)")
            }
        }
    }
    
    func handleReceivedData(_ data: Data) throws {
        if let elapsedTime = try? JSONDecoder().decode(WorkoutElapsedTime.self, from: data) {
            var currentElapsedTime: TimeInterval = 0
            if session?.state == .running {
                currentElapsedTime = elapsedTime.timeInterval + Date().timeIntervalSince(elapsedTime.date)
            } else {
                currentElapsedTime = elapsedTime.timeInterval
            }
            elapsedTimeInterval = currentElapsedTime
        } else if let statisticsArray = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: HKStatistics.self, from: data) {
            for statistics in statisticsArray {
                updateForStatistics(statistics)
            }
        }
    }
}

extension WorkoutManager: WCSessionDelegate{
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let speed = message["speed"] as? Double {
            DispatchQueue.main.async {
                self.speed = speed
            }
        } else if let remaining = message["timerStart"] as? TimeInterval {
            DispatchQueue.main.async {
                self.remainingTime = remaining
            }
        }
    }
}

