//
//  AppDelegate.swift
//  Haikingu Watch App
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 29/09/24.
//

import os
import WatchKit
import HealthKit
import SwiftUI

class AppDelegate: NSObject, WKApplicationDelegate {

    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        Task {
            do {
//                should call workout manager for function reset workout
//                should call workout manager for function start workout
                Logger.shared.log("Successfully started workout")
            } catch {
                Logger.shared.log("Failed started workout")
            }
        }
    }
}
