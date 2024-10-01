//
//  WorkoutServiceWatchos.swift
//  Haikingu Watch App
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation

import Foundation
import HealthKit

protocol WorkoutServiceWatchos{
    var sessionState: HKWorkoutSessionState { get set }
    var remainingTime: TimeInterval { get set }
    var heartRate: Double { get set }
    var activeEnergy: Double { get set }
    var speed: Double { get set }
    var distance: Double { get set }
    var elapsedTimeInterval: TimeInterval { get set }
    var workout: HKWorkout? { get set }
    
    func requestAuthorization()
    func startPedometerUpdates()
    func startWorkout(workoutConfiguration: HKWorkoutConfiguration) async throws
}
