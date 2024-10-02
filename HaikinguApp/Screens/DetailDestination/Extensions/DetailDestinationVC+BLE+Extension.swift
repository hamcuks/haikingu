//
//  DetailDestinationVC+BLE+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 01/10/24.
//

import Foundation

extension DetailDestinationVC: CentralBLEManagerDelegate {
    func centralBLEManagerDidUpdateState(poweredOn: Bool) {
        
    }
    
    func centralBLEManager(didDiscover hikers: Set<Hiker>) {
        self.addFriendDelegate?.didReceiveNearbyHikers(hikers)
    }
    
    func centralBLEManager(didConnect hiker: Hiker) {
        
    }
    
    func centralBLEManager(didDisconnect hiker: Hiker) {
        
    }
    
    func centralBLEManager(didReceiveRequestForRest restType: TypeOfRestEnum, from hiker: Hiker) {
        
    }
    
    func centralBLEManager(didReceiveInvitationResponse response: HaikinguRequestResponseEnum, from hiker: Hiker) {
        
    }
    
    
}
