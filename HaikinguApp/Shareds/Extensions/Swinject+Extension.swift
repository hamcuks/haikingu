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
        
        
        /// ViewControllers
        container.register(HomeVC.self) { resolver in
            let vc = HomeVC()
            
            return vc
        }
        
        return container
    }()
}
