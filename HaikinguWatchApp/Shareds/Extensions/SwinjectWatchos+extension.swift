//
//  SwinjectWatchos+extension.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 02/10/24.
//


import Swinject

extension Container {
    static let shared: Container = {
       let container = Container()
        
        /// Dependencies/Modules
        /// if any
        
        /// Managers
        container.register(WorkoutServiceWatchos.self) { resolver in WorkoutManager() }
        
        
        /// ViewModel
        container.register(HomeVM.self) { resolver in
            let workoutManager = resolver.resolve(WorkoutServiceWatchos.self)
            
            let vm = HomeVM(workoutManager: workoutManager)
            
            return vm
        }
        
        container.register(MetricsVM.self) { resolver in
            let workoutManager = resolver.resolve(WorkoutServiceWatchos.self)
            
            let vm = MetricsVM(workoutManager: workoutManager)
            
            return vm
        }
        
        
       
        
        return container
    }()
}
