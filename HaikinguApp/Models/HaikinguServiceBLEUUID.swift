//
//  HaikinguServiceBLEUUID.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation
import CoreBluetooth

enum HaikinguServiceBLEUUID: String, CaseIterable {
    case notification = "A70D863F-1053-4055-A86A-5A500055C100"
    case username = "FA1AEA61-6376-4B12-A1D2-10201EC1897B"
    case plan = "432FE70E-BD09-45F8-B27A-3026A519DE5B"
    
    var cbuuid: CBUUID {
        CBUUID(string: self.rawValue)
    }
}

enum HaikinguCharacteristicBLEUUID: String, CaseIterable {
    case requestForRest = "20E849D8-FCF2-4C1A-9D3C-C2AEA02A650C"
    case sendHikingInvitation = "F38DAA69-FC2D-4507-B13A-430E7CE9892B"
    case username = "73EEA5A6-F5F7-49F4-9AA0-09EE887BE868"
    case plan = "27D4DD6D-19ED-4CAB-AD5E-347009C4DD0C"
    
    var cbuuid: CBUUID {
        CBUUID(string: self.rawValue)
    }
}

extension CBService {
    private var hikingUUID: HaikinguServiceBLEUUID? {
        return HaikinguServiceBLEUUID(rawValue: self.uuid.uuidString)
    }
    
    var isNotificationService: Bool {
        self.hikingUUID == .notification
    }
    
    var isUsernameService: Bool {
        self.hikingUUID == .username
    }
    
    var isPlanService: Bool {
        self.hikingUUID == .plan
    }
}

extension CBCharacteristic {
    private var hikingUUID: HaikinguCharacteristicBLEUUID? {
        return HaikinguCharacteristicBLEUUID(rawValue: self.uuid.uuidString)
    }
    
    var isRequestForRest: Bool {
        self.hikingUUID == .requestForRest
    }
    
    var isSendHikingInvitation: Bool {
        self.hikingUUID == .sendHikingInvitation
    }
    
    var isUsername: Bool {
        self.hikingUUID == .username
    }
    
    var isPlan: Bool {
        self.hikingUUID == .plan
    }
    
    var name: String {
        if isRequestForRest {
            return "Rest"
        }
        
        if isSendHikingInvitation {
            return "Hiking Invitation"
        }
        
        if isUsername {
            return "Username"
        }
        
        if isPlan {
            return "Plan"
        }
        
        return "No Name"
    }
    
}
