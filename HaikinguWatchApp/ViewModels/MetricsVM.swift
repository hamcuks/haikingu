//
//  MetricsVM.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 29/09/24.
//

import SwiftUI

class MetricsVM: ObservableObject {
    
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0
    @Published var workoutManager: WorkoutServiceWatchOS?
    
//    @Inject var workoutManagerBehind: WorkoutServiceWatchos
    
    // Metric Stuff
    @Published var stopwatchTimer: Timer = Timer()
    @Published var timer: String = "24.59"
    @Published var timerDistance: Int = 1670
    @Published var bpmValue: Int = 100
    @Published var restAmount: Int = 1
    @Published var leftLength: Int = 4270
    
    // Control Stuff
    @Published var pageNumber = 1 // Number of TabView Selection
    @Published var isLeadPausedTapped: Bool = false // For Leader
    @Published var isLeadEndTapped: Bool = false // For Leader
    @Published var isMemberRequestRest: Bool = false // For Member
    
    init (workoutManager: WorkoutServiceWatchOS?) {
        self.workoutManager = workoutManager
    }
}
