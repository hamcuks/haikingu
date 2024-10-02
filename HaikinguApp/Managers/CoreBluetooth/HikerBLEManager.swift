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
    
    var restCharacteristic: CBMutableCharacteristic?
    var invitationCharactersitic: CBMutableCharacteristic?
    var usernameCharacteristic: CBMutableCharacteristic?
    var planCharacteristic: CBMutableCharacteristic?
    
    let username: String = UserDefaults.standard.string(
        forKey: "username"
    ) ?? "Unknown"
    
    init(centralManager: CBCentralManager?) {
        super.init()
        
        print("Init - CBCentralManager")
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    init(peripheralManager: CBPeripheralManager?) {
        super.init()
        
        print("Init - CBPeripheralManager")
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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
                "Central HikerBLEManager: Attempt to connect to: \(hiker.name)"
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
        
        for service in peripheral.services ?? [] where service.isUsernameService {
            if let characteristic = service.characteristics?.first {
                if let data = username.data(using: .utf8) {
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
        
        let data = "bukitKandap".data(using: .utf8)
        
        guard let data else { return }
        
        for service in peripheral.services ?? [] where service.isPlanService {
            if let characteristic = service.characteristics?.first {
                peripheral
                    .writeValue(
                        data,
                        for: characteristic,
                        type: .withResponse
                    )
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
