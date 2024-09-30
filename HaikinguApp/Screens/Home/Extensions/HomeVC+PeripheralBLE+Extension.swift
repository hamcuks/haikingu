//
//  HomeVC+PeripheralBLE+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation

var count: Int = 0
extension HomeVC: PeripheralBLEManagerDelegate {
    func peripheralBLEManagerDidReceiveInvitation(from invitor: Hiker, plan: String) {
        self.invitor = invitor
        self.showInvitationSheet(from: invitor)
        
        print(count)
        count += 1
    }
    
    func peripheralBLEManager(didReceivePlanData plan: Dictionary<String, Any>) {
        
    }
    
    func peripheralBLEManager(didDisconnect hiker: Hiker) {
        self.invitor = nil
    }
    
    func peripheralBLEManager(didReceiveRequestForRest type: TypeOfRestEnum) {
        #warning("Implement notification trigger")
    }
    
    func peripheralBLEManager(_ restType: TypeOfRestEnum, didReceive response: HaikinguRequestResponseEnum) {
        
    }
    
    
}
