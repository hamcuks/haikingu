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
        print("DetailDestinationVC didConnect: ", hiker.name)
        self.teamView?.updateData(on: [hiker])
    }
    
    func centralBLEManager(didDisconnect hiker: Hiker) {
        print("DetailDestinationVC didDisconnect: ", hiker.name)
        self.teamView?.removeData(on: hiker)
    }
    
    func centralBLEManager(didReceiveRequestForRest restType: TypeOfRestEnum, from hiker: Hiker) {
        
    }
    
    func centralBLEManager(didReceiveInvitationResponse response: HaikinguRequestResponseEnum, from hiker: Hiker) {
        
    }
    
}
