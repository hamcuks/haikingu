//
//  PeripheralBLEService.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation

protocol PeripheralBLEService {
    func startAdvertising()
    func stopAdvertising()
    func setDelegate(_ delegate: PeripheralBLEManagerDelegate)
    
    func respondToInvitation(for respond: HaikinguRequestResponseEnum)
    func requestRest(for type: TypeOfRestEnum)
    
}

protocol PeripheralBLEManagerDelegate {
    func peripheralBLEManagerDidReceiveInvitation(from invitor: Hiker, plan: String)
    func peripheralBLEManager(didReceivePlanData plan: String)
    func peripheralBLEManager(didDisconnect hiker: Hiker)
    func peripheralBLEManager(didReceiveRequestForRest type: TypeOfRestEnum)
    func peripheralBLEManager(_ restType: TypeOfRestEnum, didReceive response: HaikinguRequestResponseEnum)
}
