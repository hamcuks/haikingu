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
    
    func peripheralBLEManager(didReceivePlanData planId: Int) {
        print("receive plan id: ", planId)
        
        guard let viewController = Container.shared.resolve(DestinationListVC.self) else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func peripheralBLEManager(didDisconnect hiker: Hiker) {
    }
    
#warning("tambahin didNewHikerJoined")
    func peripheralBLEManager(didReceiveRequestForRest type: TypeOfRestEnum) {
        #warning("implement rest req with json data")
        self.notificationManager?.requestRest(for: type, name: nil)
    }
    
    func peripheralBLEManager(_ restType: TypeOfRestEnum, didReceive response: HaikinguRequestResponseEnum) {
        
    }
    
}
