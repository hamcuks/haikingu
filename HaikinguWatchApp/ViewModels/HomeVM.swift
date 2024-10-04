//
//  ViewModelA.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import Foundation

class HomeVM: ObservableObject {
    
    @Published var workoutManager: WorkoutServiceWatchOS?
    @Published var isHasContent: Bool = false
    @Published var titleDestination: String?
    @Published var subtitleDestination: String?
    @Published var valueDestination: String?
    @Published var isReturnHome: Bool = false
    @Published var valueReturnHome: String = ""
    
    init(workoutManager: WorkoutServiceWatchOS?) {
        self.workoutManager = workoutManager
    }
}
