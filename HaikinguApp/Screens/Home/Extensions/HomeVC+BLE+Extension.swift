//
//  HomeVC+BLE+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 01/10/24.
//

import Foundation
import Swinject

extension HomeVC: PeripheralBLEManagerDelegate {
    func peripheralBLEManagerDidReceiveInvitation(from invitor: Hiker, plan: String) {
        self.showInvitationSheet(from: invitor)
        
    }
    
    func peripheralBLEManager(didReceivePlanData plan: String) {
        print("receive plan id: ", plan)
        
        guard let viewController = Container.shared.resolve(DetailDestinationVC.self) else {
            return
        }
        
        guard let plan = DestinationList(rawValue: plan) else { return }
        
        viewController.selectedDestination = plan.destinationSelected
        viewController.role = .member
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func peripheralBLEManager(didDisconnect hiker: Hiker) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func peripheralBLEManager(didReceiveRequestForRest type: TypeOfRestEnum) {
        self.notificationManager?.requestRest(for: type, name: nil)
    }
    
    func peripheralBLEManager(_ restType: TypeOfRestEnum, didReceive response: HaikinguRequestResponseEnum) {
        
    }
    
}
