//
//  AppDelegate.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 02/10/24.
//

import os
import WatchKit
import HealthKit
import SwiftUI

class AppDelegate: NSObject, WKApplicationDelegate {
//    var workoutManager: WorkoutServiceWatchOS?
//    
//    init(workoutManager: WorkoutServiceWatchOS? = nil) {
//        super.init()
//        self.workoutManager = workoutManager
//    }
    
    
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        Task {
            do {
                WorkoutManager.shared.resetWorkout() //workoutManager?.resetWorkout()
                try await WorkoutManager.shared.startWorkout(workoutConfiguration: workoutConfiguration) //workoutManager?.startWorkout(workoutConfiguration: workoutConfiguration)
                Logger.shared.log("Successfully started workout")
            } catch {
                Logger.shared.log("Failed started workout")
            }
        }
    }
}
