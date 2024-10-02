//
//  CentralBLEService.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation

protocol CentralBLEService {
    func startScanning()
    func stopScanning()
    
    func setDelegate(_ delegate: CentralBLEManagerDelegate)
    func requestRest(for type: TypeOfRestEnum, exclude hiker: Hiker?)
    func updateHikingState(for type: HikingStateEnum)
    func updateEstTime(_ time: TimeInterval)
    func updateRestTaken(_ restCount: Int)
    func updateDistance(_ distance: Double)
    func connect(to hiker: Hiker, plan: String)
    func disconnect(to hiker: Hiker)
}

protocol CentralBLEManagerDelegate {
    func centralBLEManagerDidUpdateState(poweredOn: Bool)
    func centralBLEManager(didDiscover hikers: Set<Hiker>)
    func centralBLEManager(didConnect hiker: Hiker)
    func centralBLEManager(didDisconnect hiker: Hiker)
    func centralBLEManager(didReceiveRequestForRest restType: TypeOfRestEnum, from hiker: Hiker)
    func centralBLEManager(didReceiveInvitationResponse response: HaikinguRequestResponseEnum, from hiker: Hiker)
}
