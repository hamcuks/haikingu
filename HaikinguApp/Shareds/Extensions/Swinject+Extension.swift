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
        container.register(CentralBLEService.self) { resolver in HikerBLEManager() }
        container.register(PeripheralBLEService.self) { resolver in HikerBLEManager() }
        
        /// ViewControllers
        container.register(HomeVC.self) { resolver in
            let peripheralManager = resolver.resolve(PeripheralBLEService.self)
            
            let vc = HomeVC(peripheralManager: peripheralManager)
            
            return vc
        }
        
        return container
    }()
}
