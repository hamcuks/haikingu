//
//  ViewModelA.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import Foundation

class HomeVM: ObservableObject, WorkoutVMHomeDelegate {
    
    
    @Published var workoutManager: WorkoutServiceWatchOS?
    @Published var isHasContent: Bool = false
    @Published var titleDestination: String?
    @Published var subtitleDestination: String?
    @Published var valueDestination: String?
    @Published var isReturnHome: Bool = false
    @Published var valueReturnHome: String = ""
    
    init(workoutManager: WorkoutServiceWatchOS?) {
        self.workoutManager = workoutManager
        self.workoutManager?.setDelegateVMHome(self)
    }
    
    func didUpdateDestinationWatch(_ destinationWatch: String) {
        titleDestination = "Your Hiking Plan"
        subtitleDestination = "You will be hiking to \(destinationWatch)"
        isHasContent = true
    }
    
}
