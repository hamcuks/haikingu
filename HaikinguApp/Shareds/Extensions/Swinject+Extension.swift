//
//  Swinject+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Swinject

extension Container {
    static let shared: Container = {
       let container = Container()
        
        /// Dependencies/Modules
        /// if any
        
        /// Managers
        container.register(CentralBLEService.self) { _ in HikerBLEManager() }
        container.register(PeripheralBLEService.self) { _ in HikerBLEManager() }
        container.register(NotificationService.self) { _ in NotificationManager() }
        container.register(WorkoutServiceIos.self) { _ in WorkoutManager() }
        
        /// ViewControllers
        container.register(HomeVC.self) { resolver in
            
            let peripheralManager = resolver.resolve(PeripheralBLEService.self)
            let notificationManager = resolver.resolve(NotificationService.self)
            
            let viewController = HomeVC(peripheralManager: peripheralManager, notificationManager: notificationManager)
            
            return viewController
        }
        
        container.register(OnboardingHealthAccessVC.self) { resolver in
            
            let workoutManager = resolver.resolve(WorkoutServiceIos.self)
            
            let viewController = OnboardingHealthAccessVC(workoutManager: workoutManager)
            
            return viewController
        }
        
        return container
    }()
}
