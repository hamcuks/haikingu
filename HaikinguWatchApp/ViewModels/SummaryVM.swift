//
//  SummaryVM.swift
//  Haikingu Watch App
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 07/10/24.
//

import Foundation


import Foundation

class SummaryVM: ObservableObject, WorkoutVMSummaryDelegate {
    
    @Published var workoutManager: WorkoutServiceWatchOS?
    @Published var isBackToHomeVM: Bool = false
    
    init(workoutManager: WorkoutServiceWatchOS?) {
        self.workoutManager = workoutManager
        self.workoutManager?.setDelegateVMSummary(self)
    }
    
    func didBackToHome(_ isBackToHome: Bool) {
        if isBackToHome {
            self.isBackToHomeVM = true
        } else {
            self.isBackToHomeVM = false
        }
    }
}
