//
//  WorkoutFuncServiceWatchOS.swift
//  Haikingu Watch App
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 02/10/24.
//

import Foundation
import HealthKit



protocol WorkoutServiceWatchOS{
    var sessionState: HKWorkoutSessionState { get set }
    var remainingTime: TimeInterval { get set }
    var heartRate: Double { get set }
    var activeEnergy: Double { get set }
    var speed: Double { get set }
    var distance: Double { get set }
    var elapsedTimeInterval: TimeInterval { get set }
    var workout: HKWorkout? { get set }
    var delegate: WorkoutDelegate? { get set }
    var builder: HKLiveWorkoutBuilder? { get set }
    var session: HKWorkoutSession? { get set }
    var whatToDo: TimingState { get set }
    
    func resetWorkout()
    func requestAuthorization()
    func startPedometerUpdates()
    func startWorkout(workoutConfiguration: HKWorkoutConfiguration) async throws
}
