//
//  HomeVC+BLE+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 01/10/24.
//

import Foundation

extension HomeVC: PeripheralBLEManagerDelegate {
    func peripheralBLEManagerDidReceiveInvitation(from invitor: Hiker, plan: String) {
        self.showInvitationSheet(from: invitor)
        
    }
    
    func peripheralBLEManager(didReceivePlanData plan: Dictionary<String, Any>) {
        
    }
    
    func peripheralBLEManager(didDisconnect hiker: Hiker) {
    }
    
    
    func peripheralBLEManager(didReceiveRequestForRest type: TypeOfRestEnum) {
        #warning("implement rest req with json data")
        self.notificationManager?.requestRest(for: type, name: nil)
    }
    
    func peripheralBLEManager(_ restType: TypeOfRestEnum, didReceive response: HaikinguRequestResponseEnum) {
        
    }
    
}
