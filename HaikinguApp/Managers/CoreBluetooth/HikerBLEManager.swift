//
//  HikerBLEService.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation

import CoreBluetooth
import os

class HikerBLEManager: NSObject {
    /// Central Data
    var centralManager: CBCentralManager!
    var discoveredPeripherals: Set<CBPeripheral> = []
    var discoveredHikers: Set<Hiker> = []
    var centralDelegate: CentralBLEManagerDelegate?
    
    /// Peripheral Data
    var peripheralManager: CBPeripheralManager!
    var central: CBCentral?
    var peripheralDelegate: PeripheralBLEManagerDelegate?
    var invitor: Hiker?
    var plan: String?
    
    var restCharacteristic: CBMutableCharacteristic?
    var invitationCharactersitic: CBMutableCharacteristic?
    var usernameCharacteristic: CBMutableCharacteristic?
    var planCharacteristic: CBMutableCharacteristic?
    
    var userDefaultManager: UserDefaultService?
    
    var user: User?
    
    init(centralManager: CBCentralManager?, userDefaultManager: UserDefaultService?) {
        super.init()
        
        print("Init - CBCentralManager")
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.userDefaultManager = userDefaultManager
        
        self.user = userDefaultManager?.getUserData()
    }
    
    init(peripheralManager: CBPeripheralManager?, userDefaultManager: UserDefaultService?) {
        super.init()
        
        print("Init - CBPeripheralManager")
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.userDefaultManager = userDefaultManager
        
        self.user = userDefaultManager?.getUserData()
    }
}

extension HikerBLEManager: CentralBLEService {
    
    func setDelegate(_ delegate: CentralBLEManagerDelegate) {
        self.centralDelegate = delegate
    }
    
    func startScanning() {
        os_log("Central HikerBLEManager: startScanning")
        
        let notificationId = HaikinguServiceBLEUUID.notification.cbuuid
        self.centralManager?.scanForPeripherals(withServices: [notificationId])
        
    }
    
    func stopScanning() {
        os_log("Central HikerBLEManager: stopScanning")
        
        self.centralManager.stopScan()
        self.cleanup()
        
    }
    
    func requestRest(for type: TypeOfRestEnum, exclude hiker: Hiker?) {
        os_log("Central HikerBLEManager: Request For: %s", type.rawValue)
        
        let peripherals = self.discoveredPeripherals.filter({ $0.identifier != hiker?.id })
        
        for peripheral in peripherals {
            if let service = peripheral.services?.first(where: { $0.isNotificationService }) {
                os_log("Central HikerBLEManager: Service: \(service.uuid)")
                
                let characteristic = service.characteristics?.first(where: { $0.isRequestForRest })
                let data = type.rawValue.data(using: .utf8)
                
                if let characteristic, let data {
                    os_log("Central HikerBLEManager: Characteristic: \(characteristic.uuid)")
                    peripheral .writeValue(
                            data,
                            for: characteristic,
                            type: .withoutResponse
                        )
                }
            }
        }
    }
    
    func connect(to hiker: Hiker, plan: String) {
        self.plan = plan
        if let peripheral = self.discoveredPeripherals.first(
            where: { $0.identifier == hiker.id
            }) {
            os_log(
                "Central HikerBLEManager: Attempt to connect to: \(hiker.name)"
            )
            
            self.centralManager.connect(peripheral)
        }
    }
    
    func disconnect(to hiker: Hiker) {
        
        if let peripheral = self.discoveredPeripherals.first(
            where: { $0.identifier == hiker.id
            }) {
            os_log(
                "Central HikerBLEManager: Attempt to disconnect to: \(hiker.name)"
            )
            
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func sendHikingInvitation(to peripheral: CBPeripheral, for plan: String) {
        os_log("Central HikerBLEManager: Send Hiking Invitation to \(peripheral.identifier)")
        
        for service in peripheral.services ?? [] where service.isNotificationService {
            let characteristic = service.characteristics?.first(where: { $0.isSendHikingInvitation })
            let data = plan.data(using: .utf8)
            
            if let characteristic, let data {
                peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            }
        }
    }
    
    func sendUsername(to peripheral: CBPeripheral) {
        os_log(
            "Central HikerBLEManager: Send Username to \(peripheral.identifier)"
        )
        
        guard let user else { return }
        
        for service in peripheral.services ?? [] where service.isUsernameService {
            if let characteristic = service.characteristics?.first {
                if let data = user.name.data(using: .utf8) {
                    peripheral
                        .writeValue(
                            data,
                            for: characteristic,
                            type: .withResponse
                        )
                }
            }
        }
    }
    
    func sendHikingPlan(to peripheral: CBPeripheral) {
        os_log(
            "Central HikerBLEManager: Send Hiking Plan to \(peripheral.identifier)"
        )
        
        guard let plan else { return }
        
        let data = plan.data(using: .utf8)
        
        guard let data else { return }
        
        for service in peripheral.services ?? [] where service.isPlanService {
            
            for characteristic in service.characteristics ?? [] where characteristic.isPlan {
                peripheral
                    .writeValue(
                        data,
                        for: characteristic,
                        type: .withResponse
                    )
            }
        }
    }
    
    func updateHikingState(for type: HikingStateEnum) {
        os_log(
            "Central updateHikingState: Update hiking state to: \(type.rawValue)"
        )
        
        let data = type.rawValue.data(using: .utf8)
        
        guard let data else { return }
        
        print(self.discoveredPeripherals)
        
        for peripheral in self.discoveredPeripherals where peripheral.state == .connected {
            for service in peripheral.services ?? [] where service.isPlanService {
                
                for characteristic in service.characteristics ?? [] where characteristic.isHikingState {
                    peripheral
                        .writeValue(
                            data,
                            for: characteristic,
                            type: .withoutResponse
                        )
                }
            }
        }
    }
    
    func updateEstTime(_ time: TimeInterval) {
        os_log(
            "Central updateHikingState: Update Est Time: \(time)"
        )
        
        let data = withUnsafeBytes(of: time) { Data($0) }
        
        for peripheral in self.discoveredPeripherals where peripheral.state == .connected {
            for service in peripheral.services ?? [] where service.isPlanService {
                
                for characteristic in service.characteristics ?? [] where characteristic.isEstTime {
                    peripheral
                        .writeValue(
                            data,
                            for: characteristic,
                            type: .withoutResponse
                        )
                }
            }
        }
    }
    
    func updateRestTaken(_ restCount: Int) {
        os_log(
            "Central updateHikingState: Update Rest Taken: \(restCount)"
        )
        
        let data = withUnsafeBytes(of: restCount) { Data($0) }
        
        for peripheral in self.discoveredPeripherals where peripheral.state == .connected {
            for service in peripheral.services ?? [] where service.isPlanService {
                
                for characteristic in service.characteristics ?? [] where characteristic.isRestTaken {
                    peripheral
                        .writeValue(
                            data,
                            for: characteristic,
                            type: .withoutResponse
                        )
                }
            }
        }
    }
    
    func updateDistance(_ distance: Double) {
        os_log(
            "Central updateHikingState: Update Distance: \(distance)"
        )
        
        let data = withUnsafeBytes(of: distance) { Data($0) }
        
        for peripheral in self.discoveredPeripherals where peripheral.state == .connected {
            for service in peripheral.services ?? [] where service.isPlanService {
                
                for characteristic in service.characteristics ?? [] where characteristic.isDistance {
                    peripheral
                        .writeValue(
                            data,
                            for: characteristic,
                            type: .withoutResponse
                        )
                }
            }
        }
    }
    
    func sendData(
        _ data: Data,
        to peripheral: CBPeripheral,
        for characteristic: CBCharacteristic
    ) {
        os_log("Central HikerBLEManager: Send Data to \(peripheral.identifier)")
        
        var offset = 0
        
        let mtuSize = peripheral.maximumWriteValueLength(for: .withoutResponse)
        
        while offset < data.count {
            // Calculate chunk size based on the current MTU size
            let chunkSize = min(mtuSize, data.count - offset)
            let chunk = data.subdata(in: offset..<(offset + chunkSize))
            
            // Send the chunk to the peripheral
            peripheral
                .writeValue(chunk, for: characteristic, type: .withoutResponse)
            
            // Move the offset forward
            offset += chunkSize
        }
        
        os_log("Central HikerBLEManager: All data chunks sent")
    }
    
}
