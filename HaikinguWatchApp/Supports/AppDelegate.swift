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
    
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        Task {
                WorkoutManager.shared.resetWorkout() // workoutManager?.resetWorkout()
        }
    }
}
