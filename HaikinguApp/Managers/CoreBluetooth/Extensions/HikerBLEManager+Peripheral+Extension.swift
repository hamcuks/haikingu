//
//  HikerBLEManager+Peripheral+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation
import CoreBluetooth
import os

extension HikerBLEManager: PeripheralBLEService {
    func configurePeripheral() {
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    func setDelegate(_ delegate: PeripheralBLEManagerDelegate) {
        self.peripheralDelegate = delegate
    }
    
    func startAdvertising() {
        os_log("HikerBLEManager: startAdvertising")
        
        /// Service and Characteristics for Rest
        let restCharacteristic = createCharacteristic(
            uuid: .requestForRest,
            properties: [.read, .writeWithoutResponse, .notify],
            value: nil,
            permissions: [.readable, .writeable]
        )
        self.restCharacteristic = restCharacteristic
        
        /// Service and Characteristics for Invitation
        let invitationCharactersitic = createCharacteristic(
            uuid: .sendHikingInvitation,
            properties: [.read, .writeWithoutResponse, .notify],
            value: nil,
            permissions: [.readable, .writeable]
        )
        self.invitationCharactersitic = invitationCharactersitic
        
        let notificationService = createService(
            uuid: .notification,
            characteristics: [restCharacteristic, invitationCharactersitic]
        )
        peripheralManager.add(notificationService)
        
        /// Service and Characteristics for Invitation
        let usernameCharacteristic = createCharacteristic(
            uuid: .username,
            properties: [.write, .notify],
            value: nil,
            permissions: [.writeable]
        )
        self.usernameCharacteristic = usernameCharacteristic
        
        let usernmaeService = createService(
            uuid: .username,
            characteristics: [usernameCharacteristic]
        )
        peripheralManager.add(usernmaeService)
        
        /// Service and Characteristics for Plan
        let planCharacteristic = createCharacteristic(
            uuid: .plan,
            properties: [.write, .notify],
            value: nil,
            permissions: [.writeable]
        )
        self.planCharacteristic = planCharacteristic
        
        let planService = createService(
            uuid: .username,
            characteristics: [planCharacteristic]
        )
        peripheralManager.add(planService)
        
        peripheralManager.startAdvertising(
            [
                CBAdvertisementDataLocalNameKey: username,
                CBAdvertisementDataServiceUUIDsKey: [
                    notificationService.uuid,
                    usernmaeService.uuid,
                    planService.uuid
                ]
            ]
        )
        
    }
    
    func stopAdvertising() {
        os_log("HikerBLEManager: stopAdvertising")
        
        self.peripheralManager.stopAdvertising()
        
    }
    
    func respondToInvitation(for respond: HaikinguRequestResponseEnum) {
        os_log("HikerBLEManager: respondToInvitation")
        
        guard let invitationCharactersitic, let central else {
            os_log("HikerBLEManager: Can not find invitation characteristic or central")
            return
        }
        
        if let data = respond.rawValue.data(using: .utf8) {
            peripheralManager
                .updateValue(
                    data,
                    for: invitationCharactersitic,
                    onSubscribedCentrals: [central]
                )
        }
    }
    
    func respondToInvitation(
        for respond: HaikinguRequestResponseEnum,
        central: CBCentral
    ) {
        os_log("HikerBLEManager: respondToInvitation")
        
        guard let invitationCharactersitic else {
            os_log("HikerBLEManager: Can not find invitation characteristic")
            return
        }
        
        if let data = respond.rawValue.data(using: .utf8) {
            peripheralManager
                .updateValue(
                    data,
                    for: invitationCharactersitic,
                    onSubscribedCentrals: [central]
                )
        }
    }
    
    func requestRest(for type: TypeOfRestEnum) {
        os_log("HikerBLEManager: requestRest for \(type.rawValue)")
        
        guard let restCharacteristic, let central else {
            os_log(
                "HikerBLEManager: Can not find notification characteristic or central"
            )
            return
        }
        
        if let data = type.rawValue.data(using: .utf8) {
            peripheralManager
                .updateValue(
                    data,
                    for: restCharacteristic,
                    onSubscribedCentrals: [central]
                )
        }
    }
    
    private func createService(
        uuid: HaikinguServiceBLEUUID,
        characteristics: [CBMutableCharacteristic]
    ) -> CBMutableService {
        let service = CBMutableService(type: uuid.cbuuid, primary: true)
        
        service.characteristics = characteristics
        
        return service
    }
    
    private func createCharacteristic(
        uuid: HaikinguCharacteristicBLEUUID,
        properties: CBCharacteristicProperties, value: Data?,
        permissions: CBAttributePermissions
    ) -> CBMutableCharacteristic {
        let characteristic = CBMutableCharacteristic(
            type: uuid.cbuuid,
            properties: properties,
            value: value,
            permissions: permissions
        )
        
        return characteristic
    }
}

extension HikerBLEManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        os_log("PeripheralManager: peripheralManagerDidUpdateState")
        switch peripheral.state {
            
        case .unknown:
            os_log("PeripheralManager: State - unknown\n")
            return
        case .resetting:
            os_log("PeripheralManager: State - resetting\n")
            return
        case .unsupported:
            os_log("PeripheralManager: State - unsupported\n")
            return
        case .unauthorized:
            os_log("PeripheralManager: State - unauthorized\n")
            return
        case .poweredOff:
            os_log("PeripheralManager: State - poweredOff\n")
            
            return
        case .poweredOn:
            os_log("PeripheralManager: State - poweredOn\n")
            
            peripheral.removeAllServices()
            self.startAdvertising()
            
            return
        @unknown default:
            os_log("PeripheralManager: State - unknown\n")
            return
        }
        
    }
    
    func peripheralManagerDidStartAdvertising(
        _ peripheral: CBPeripheralManager,
        error: (any Error)?
    ) {
        os_log("PeripheralManager: peripheralManagerDidStartAdvertising")
        
        if let error {
            os_log("PeripheralManager: ", error.localizedDescription)
            return
        }
    }
    
    func peripheralManager(
        _ peripheral: CBPeripheralManager,
        didReceiveWrite requests: [CBATTRequest]
    ) {
        os_log("PeripheralManager: didReceiveWrite")
        
        for request in requests {
            guard let data = request.value else {
                os_log("PeripheralManager: No Data Found!")
                
                return
            }
            
            if request.characteristic.isSendHikingInvitation, let invitor {
                guard let decodedData = String(data: data, encoding: .utf8) else {
                    return
                }
                
                os_log("PeripheralManager: Received invitation from central: \(decodedData)")
                self.peripheralDelegate?
                    .peripheralBLEManagerDidReceiveInvitation(
                        from: invitor,
                        plan: decodedData
                    )
            }
            
            if request.characteristic.isRequestForRest {
                guard let decodedData = String(data: data, encoding: .utf8) else {
                    return
                }
                
                os_log("PeripheralManager: Received request for rest from central: \(decodedData)")
                
                if let type = TypeOfRestEnum(rawValue: decodedData) {
                    self.peripheralDelegate?
                        .peripheralBLEManager(didReceiveRequestForRest: type)
                }
            }
            
            /// Send callback to central after received its username
            if request.characteristic.isUsername {
                guard let decodedData = String(data: data, encoding: .utf8) else {
                    return
                }
                
                peripheral.respond(to: request, withResult: .success)
                
                guard self.invitor != nil else {
                    self.invitor = Hiker(
                        id: request.central.identifier,
                        name: decodedData
                    )
                    return
                }
                
                self.invitor?.name = decodedData
            }
            
            /// Send callback to central after received the hiking plan
            if request.characteristic.isPlan {
                peripheral.respond(to: request, withResult: .success)
                
                do {
                    let decodedData = try JSONDecoder().decode(
                        Hiking.self,
                        from: data
                    )
                    
                    print("ID: ", decodedData.id)
                    print("Name: ", decodedData.name)
                    print("Track Length: ", decodedData.trackLength)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    func peripheralManager(
        _ peripheral: CBPeripheralManager,
        central: CBCentral,
        didSubscribeTo characteristic: CBCharacteristic
    ) {
        os_log("PeripheralManager: didSubscribeTo")
        os_log("PeripheralManager: Subscribed to \(characteristic.name) - \(characteristic.uuid)")
        
        if self.central != nil && self.central?.identifier != central.identifier {
            // MARK: reject the central
            self.respondToInvitation(for: .rejected, central: central)
            return
        }
        
        self.central = central
    }
    
    func peripheralManager(
        _ peripheral: CBPeripheralManager,
        central: CBCentral,
        didUnsubscribeFrom characteristic: CBCharacteristic
    ) {
        os_log("PeripheralManager: didUnsubscribeFrom")
        os_log("PeripheralManager: Unsunscribed from \(characteristic.name) - \(characteristic.uuid)")
        
        guard let connectedCentral = self.central, connectedCentral.identifier == central.identifier else {
            return
        }
        
        self.central = nil
        
        if let hiker = invitor {
            self.peripheralDelegate?.peripheralBLEManager(didDisconnect: hiker)
        }
    }
    
}

extension HikerBLEManager: StreamDelegate {
    
}
