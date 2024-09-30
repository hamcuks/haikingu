//
//  WorkoutServiceiOS.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation
import HealthKit

@MainActor
protocol WorkoutServiceiOS{
    var sessionState: HKWorkoutSessionState { get set }
    var remainingTime: TimeInterval { get set }
    var heartRate: Double { get set }
    var activeEnergy: Double { get set }
    var speed: Double { get set }
    var distance: Double { get set }
    var elapsedTimeInterval: TimeInterval { get set }
    var workout: HKWorkout? { get set }
    
    
    func requestMotionPermission()
    func stopPedometerUpdates()
    func startWatchWorkout(workoutType: HKWorkoutActivityType) async throws
    func retrieveRemoteSession()
    func isPersonTired() -> Bool
}



