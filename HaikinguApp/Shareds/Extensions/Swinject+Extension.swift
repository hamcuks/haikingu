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
        container.register(CentralBLEService.self) { resolver in
            let userDefaultManager = resolver.resolve(UserDefaultService.self)
            return HikerBLEManager(centralManager: nil, userDefaultManager: userDefaultManager)
        }
        
        container.register(PeripheralBLEService.self) { resolver in
            let userDefaultManager = resolver.resolve(UserDefaultService.self)
            return HikerBLEManager(peripheralManager: nil, userDefaultManager: userDefaultManager)
        }
        
        container.register(NotificationService.self) { _ in NotificationManager() }
        container.register(WorkoutServiceIos.self) { _ in WorkoutManager.shared }
        container.register(UserDefaultService.self) { _ in UserDefaultManager() }
        
        /// ViewControllers
        container.register(HomeVC.self) { resolver in
            
            let peripheralManager = resolver.resolve(PeripheralBLEService.self)
            let notificationManager = resolver.resolve(NotificationService.self)
            let userDefaultManager = resolver.resolve(UserDefaultService.self)
            
            let viewController = HomeVC(peripheralManager: peripheralManager, notificationManager: notificationManager, userDefaultManager: userDefaultManager)
            
            return viewController
        }
        
        container.register(DetailDestinationVC.self) { resolver in
            
            let centralManager = resolver.resolve(CentralBLEService.self)
            let workoutManager = resolver.resolve(WorkoutServiceIos.self)
            
            let viewController = DetailDestinationVC(centralManager: centralManager, workoutManager: workoutManager)
            
            return viewController
        }
        
        container.register(OnboardingHealthAccessVC.self) { resolver in
            
            let workoutManager = resolver.resolve(WorkoutServiceIos.self)
            
            let viewController = OnboardingHealthAccessVC(workoutManager: workoutManager)
            
            return viewController
        }
        
        container.register(OnboardingHikingProfileVC.self) { resolver in
            let userDeafultManager = resolver.resolve(UserDefaultService.self)
            let viewController = OnboardingHikingProfileVC(userDefault: userDeafultManager)
            return viewController
        }
        
        container.register(OnboardingFinishedVC.self) { resolver in
            let userDeafultManager = resolver.resolve(UserDefaultService.self)
            let viewController = OnboardingFinishedVC(userDefault: userDeafultManager)
            return viewController
        }
        
        container.register(HikingSessionVC.self) { resolver in
            let workoutManager = resolver.resolve(WorkoutServiceIos.self)
            let userDefaultManager = resolver.resolve(UserDefaultService.self)
            let centralManager = resolver.resolve(CentralBLEService.self)
            let peripheralManager = resolver.resolve(PeripheralBLEService.self)
            
            let viewController = HikingSessionVC(workoutManager: workoutManager, userDefaultManager: userDefaultManager, centralManager: centralManager, peripheralManager: peripheralManager
            )
            return viewController
        }
        
        container.register(CongratsVC.self) { resolver in
            let workoutManager = resolver.resolve(WorkoutServiceIos.self)
            let viewController = CongratsVC(workoutManager: workoutManager)
            return viewController
        }
        
        container.register(EditProfileVC.self) { resolver in
            let userDefaultManager = resolver.resolve(UserDefaultService.self)
            let viewController = EditProfileVC(userDefaultManager: userDefaultManager)
            return viewController
        }
        
        return container
    }()
}
