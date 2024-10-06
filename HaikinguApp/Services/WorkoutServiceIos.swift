//
//  WorkoutServiceIos.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation
import HealthKit

protocol WorkoutServiceIos {
    var sessionState: HKWorkoutSessionState { get set }
    var remainingTime: TimeInterval { get set }
    var heartRate: Double { get set }
    var activeEnergy: Double { get set }
    var speed: Double { get set }
    var distance: Double { get set }
    var elapsedTimeInterval: TimeInterval { get set }
    var workout: HKWorkout? { get set }
    var whatToDo: TimingState { get set }
    var isWorkoutEnded: Bool { get set }
    var session: HKWorkoutSession? { get set }
    func isWatchAppOpen() -> Bool
    func setDelegate(_ delegate: WorkoutDelegate)
    func setDelegateV2(_ delegate: WorkoutDelegateV2)
    func setDelegateV3(_ delegate: WorkoutDelegateV3)
    
    func requestMotionPermission()
    func requestHealthAccess()
    func stopPedometerUpdates()
    func startWatchWorkout(workoutType: HKWorkoutActivityType) async throws
    func retrieveRemoteSession()
    func checkPersonTired() -> Bool
    func pauseTimer()
    func resumeTimer()
    func stopTimer()
    func sendPausedToWatch()
    func sendResumedToWatch()
    func sendEndedToWatch()
    func sendStartedToWatch()
    func sendDestinationNameToWatch(destination name: String)
    func sendDestinationElevMaxToWatch(elevMax: Int)
    func sendDestinationElevMinToWatch(elevMin: Int)
   func sendBackToHomeToWatch()
}
