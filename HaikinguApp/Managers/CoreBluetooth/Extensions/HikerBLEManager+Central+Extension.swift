//
//  HikerBLEService+Central+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation
import CoreBluetooth
import os

extension HikerBLEManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func cleanup() {
        os_log("HikerBLEManager: Cleaning Up!")
        for peripheral in self.discoveredPeripherals where peripheral.state == .connected {
            for service in peripheral.services ?? [] {
                for characteristic in service.characteristics ?? [] where characteristic.isNotifying {
                    peripheral.setNotifyValue(false, for: characteristic)
                }
            }
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /// CentralManager
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        os_log("CentralManager: centralManagerDidUpdateState")
        
        var state: Bool = false
        
        switch central.state {
            
        case .unknown:
            os_log("CentralManager: State - unknown")
            state = false
        case .resetting:
            os_log("CentralManager: State - resetting")
            state = false
        case .unsupported:
            os_log("CentralManager: State - unsupported")
            state = false
        case .unauthorized:
            os_log("CentralManager: State - unauthorized")
            state = false
        case .poweredOff:
            os_log("CentralManager: State - poweredOff")
            
            if central.isScanning {
                self.stopScanning()
            }
            
            cleanup()
            
            state = false
        case .poweredOn:
            os_log("CentralManager: State - poweredOn")
            state = true
        @unknown default:
            os_log("CentralManager: State - unknown")
            state = false
        }
        
        self.centralDelegate?.centralBLEManagerDidUpdateState(poweredOn: state)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber
    ) {
        os_log("CentralManager: didDiscover")
        os_log(
            "CentralManager: \(peripheral.name ?? "No Name") - \(peripheral.identifier)"
        )
        os_log("CentralManager: \(advertisementData)")
        
        let name: String = (
            advertisementData["kCBAdvDataLocalName"] as? String? ?? peripheral.name
        ) ?? "Unknown"
        let hiker = Hiker(id: peripheral.identifier, name: name)
        
        if peripheral.name != nil {
            self.discoveredHikers.insert(hiker)
        }
        
        // MARK: temporary call delegate
        self.centralDelegate?
            .centralBLEManager(didDiscover: self.discoveredHikers)
        
        if !self.discoveredPeripherals.contains(peripheral) {
            self.discoveredPeripherals.insert(peripheral)
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        os_log("CentralManager: didConnect")
        os_log(
            "CentralManager: Connected to: \(peripheral.name ?? "No Name") - \(peripheral.identifier)"
        )
        
        let notificationServiceId = HaikinguServiceBLEUUID.notification.cbuuid
        let usernameServiceId = HaikinguServiceBLEUUID.username.cbuuid
        let planServiceId = HaikinguServiceBLEUUID.plan.cbuuid
        
        peripheral.delegate = self
        peripheral
            .discoverServices(
                [ notificationServiceId, usernameServiceId, planServiceId ]
            )
        
        let hiker = self.discoveredHikers.first(where: { $0.id == peripheral.identifier || $0.name == peripheral.name })
        
        if var hiker {
            hiker.state = .waiting
            self.discoveredHikers.update(with: hiker)
            
            self.centralDelegate?
                .centralBLEManager(didDiscover: self.discoveredHikers)
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: (any Error)?
    ) {
        os_log("CentralManager: didDisconnectPeripheral")
        os_log("CentralManager: Disconnected from: \(peripheral.name ?? "No Name") - \(peripheral.identifier)")
        
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        self.discoveredPeripherals.remove(peripheral)
        
        let hiker = self.discoveredHikers.first(where: { $0.id == peripheral.identifier || $0.name == peripheral.name })
        
        if var hiker {
            hiker.state = .notJoined
            self.discoveredHikers.update(with: hiker)
            self.centralDelegate?.centralBLEManager(didDisconnect: hiker)
            
            self.centralDelegate?
                .centralBLEManager(didDiscover: self.discoveredHikers)
        }
        
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: (any Error)?
    ) {
        os_log("CentralManager: didFailToConnect")
        os_log("CentralManager: Failed to connect to: \(peripheral.name ?? "No Name") - \(peripheral.identifier)")
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        cleanup()
    }
    
    /// Peripheral
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: (any Error)?
    ) {
        os_log("Peripheral: didDiscoverServices")
        
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let services = peripheral.services else {
            os_log("Peripheral: No Services Found!")
            return
        }
        var cbuuids: [CBUUID] = []
        
        for service in services {
            os_log("Peripheral: Service - \(service.uuid)")
            
            if service.isNotificationService {
                let restCharacteristic = HaikinguCharacteristicBLEUUID.requestForRest.cbuuid
                let invitationCharacteristic = HaikinguCharacteristicBLEUUID.sendHikingInvitation.cbuuid
                cbuuids = [restCharacteristic, invitationCharacteristic]
            }
            
            if service.isUsernameService {
                let usernameCharacteristic = HaikinguCharacteristicBLEUUID.username.cbuuid
                cbuuids = [usernameCharacteristic]
            }
            
            if service.isPlanService {
                let planCharacteristic = HaikinguCharacteristicBLEUUID.plan.cbuuid
                let hikingStateCharacteristic = HaikinguCharacteristicBLEUUID.hikingState.cbuuid
                let estTimeCharacteristic = HaikinguCharacteristicBLEUUID.estTime.cbuuid
                let restTakenCharacteristic = HaikinguCharacteristicBLEUUID.restTaken.cbuuid
                let distanceCharacteristic = HaikinguCharacteristicBLEUUID.distance.cbuuid
                
                cbuuids = [planCharacteristic, hikingStateCharacteristic, estTimeCharacteristic, restTakenCharacteristic, distanceCharacteristic]
            }
            
            peripheral.discoverCharacteristics(cbuuids, for: service)
            
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: (any Error)?
    ) {
        os_log("Peripheral: didDiscoverCharacteristicsFor")
        os_log("Peripheral: Service - \(service.uuid)")
        
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let characteristics = service.characteristics else {
            os_log("Peripheral: No Characteristics Found!")
            return
        }
        
        for characteristic in characteristics {
            os_log("Peripheral: Characteristic - \(characteristic.uuid)")
            
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            let mtu = peripheral.maximumWriteValueLength(for: .withoutResponse)
            os_log("Peripheral: MTU - \(mtu)")
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateNotificationStateFor characteristic: CBCharacteristic,
        error: (any Error)?
    ) {
        os_log("Peripheral: didUpdateNotificationStateFor")
        os_log("Peripheral: From \(peripheral.name ?? "No Name") - \(peripheral.identifier)")
        
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        if characteristic.isNotifying {
            os_log("Peripheral -- Characteristic notifications have begun.")
            
            if characteristic.isUsername {
                self.sendUsername(to: peripheral)
            }
        } else {
            os_log("Peripheral -- Characteristic notifications have stopped. Disconnecting.")
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: (any Error)?
    ) {
        os_log("Peripheral: didUpdateValueFor")
        os_log("Peripheral: From \(peripheral.name ?? "No Name") - \(peripheral.identifier)")
        
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        guard let data = characteristic.value else {
            os_log("Peripheral: No Data Found!")
            return
        }
        
        let decodedData = String(data: data, encoding: .utf8)
        
        guard let decodedData else { return }
        
        /// Case: Hiker requested for break to central
        if characteristic.isRequestForRest, let type = TypeOfRestEnum(
            rawValue: decodedData
        ) {
            os_log("Peripheral: Broadcasting request for \(type.rawValue) to other Hikers")
            
            if let hiker = self.discoveredHikers.first(
                where: { $0.id == peripheral.identifier
                }) {
                self.centralDelegate?
                    .centralBLEManager(
                        didReceiveRequestForRest: type,
                        from: hiker
                    )
                
                /// Broadcast to other peripherals excluding the requester
                self.requestRest(for: type, exclude: hiker)
            }
            
        }
        
        /// Case: Hiker respond to central invitation
        if characteristic.isSendHikingInvitation, let respond = HaikinguRequestResponseEnum(
            rawValue: decodedData
        ) {
            os_log("Peripheral: \(peripheral.name ?? "No Name") \(respond == .accepted) the invitation")
            
            if let hiker = self.discoveredHikers.first(
                where: { $0.id == peripheral.identifier
                }) {
                self.centralDelegate?
                    .centralBLEManager(
                        didReceiveInvitationResponse: respond,
                        from: hiker
                    )
            }
            
            if respond == .accepted {
                self.sendHikingPlan(to: peripheral)
            } else {
                self.centralManager.cancelPeripheralConnection(peripheral)
            }
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didWriteValueFor characteristic: CBCharacteristic,
        error: (any Error)?
    ) {
        os_log("Peripheral: didWriteValueFor")
        os_log("Peripheral: From \(peripheral.name ?? "No Name") - \(peripheral.identifier)")
        
        if let error {
            os_log("Peripheral: ", error.localizedDescription)
            cleanup()
            return
        }
        
        #warning("todo: call delegate didDiscover setelah peripheral respond success dan terima hiking plan")
        if characteristic.isPlan {
            let hiker = self.discoveredHikers.first(where: { $0.id == peripheral.identifier })
            
            if var hiker {
                
                hiker.state = .joined
                self.discoveredHikers.update(with: hiker)
                self.centralDelegate?.centralBLEManager(didConnect: hiker)
                self.centralDelegate?
                    .centralBLEManager(didDiscover: self.discoveredHikers)
                
            }
        }
        
        /// Send Hiking invitation after peripheral received the username of central
        if characteristic.isUsername {
            self.sendHikingInvitation(to: peripheral, for: "Test")
        }
    }
    
}
