//
//  TypeOfRestEnum.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation

enum TypeOfRestEnum: String {
    case mandatoryBreak = "Break"
    case abnormalBpm = "Abnormal BPM"
    case timeToBreak = "Time to Break"
    case timeToWalk = "Time to Walk"
    case bpmAlreadyNormal = "BPM Already Normal"
    case notMoving = "Not Moving"
    
}

enum HikingStateEnum: String {
    case paused
    case notStarted
    case started
    case continued
    case finished
    
}

extension TypeOfRestEnum {
    func getTitle(for name: String?) -> String {
        switch self {
            
        case .mandatoryBreak:
            if let name {
                return "\(name) is requesting a break"
            }
            
            return "Someone's is requesting a break"
        case .abnormalBpm:
            if let name {
                return "Take a rest!!! \(name) needs a quick rest to recharge"
            }
            
            return "Stop!!! Your BPM is Too High"
        case .timeToBreak:
            return "Time to Rest 😃"
        case .timeToWalk:
            return "Time to Walk Again!"
        case .bpmAlreadyNormal:
            if let name {
                return "\(name) is ready to continue the journey"
            }
            
            return "Your BPM is Already Normal"
        case .notMoving:
            if let name {
                return "\(name) is detected not moving"
            }
            
            return "You are detected not moving"
        }
    }
    
    func getBody(for name: String?) -> String {
        switch self {
            
        case .mandatoryBreak:
            return "Someone's is requesting a break"
        case .abnormalBpm:
            if let name {
                return "Pause the journey and wait until \(name)'s energy is back"
            }
            
            return "Take a rest immediately until your heart rate is normal"
        case .timeToBreak:
            return "Enjoy your 10 minutes rest, then continue your hiking. Click here to see your timer"
        case .timeToWalk:
            return "End your rest, continue your journey to the destination"
        case .bpmAlreadyNormal:
            if name != nil {
                return "Continue your journey and keep your team safe"
            }
            
            return "Continue your journey and keep your heart rate safe"
        case .notMoving:
            if name != nil {
                return "Check your friends"
            }
            
            return "Do you need a rest or can you keep moving?"
        }
    }
}
