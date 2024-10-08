//
//  WorkoutManager+iOS+Extension.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 30/09/24.
//

import Foundation
import os
import HealthKit
import WatchConnectivity

// MARK: - Workout session management
//
extension WorkoutManager: WorkoutServiceIos {
    
    func setDelegate(_ delegate: any WorkoutDelegate) {
        self.delegate = delegate
    }
    
    func setDelegateV2(_ delegate: any WorkoutDelegateV2) {
        self.delegateV2 = delegate
    }
    
    func startWatchWorkout(workoutType: HKWorkoutActivityType) async throws {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        try await healthStore.startWatchApp(toHandle: configuration)
    }
    
    func retrieveRemoteSession() {
        /**
         HealthKit calls this handler when a session starts mirroring.
         */
        healthStore.workoutSessionMirroringStartHandler = { mirroredSession in
            Task { @MainActor in
                self.resetWorkout()
                self.session = mirroredSession
                self.session?.delegate = self
                Logger.shared.log("Start mirroring remote session: \(mirroredSession)")
            }
        }
    }
    
    func handleReceivedData(_ data: Data) throws {
        if let elapsedTime = try? JSONDecoder().decode(WorkoutElapsedTime.self, from: data) {
            var currentElapsedTime: TimeInterval = 0
            if session?.state == .running {
                currentElapsedTime = elapsedTime.timeInterval + Date().timeIntervalSince(elapsedTime.date)
            } else {
                currentElapsedTime = elapsedTime.timeInterval
            }
            elapsedTimeInterval = currentElapsedTime
            updateElapsedTimeInterval(to: elapsedTimeInterval)
        } else if let statisticsArray = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: HKStatistics.self, from: data) {
            for statistics in statisticsArray {
                updateForStatistics(statistics)
            }
        }
    }
    
    func requestHealthAccess() {
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
            } catch {
                Logger.shared.log("Failed to request authorization: \(error)")
            }
        }
    }
    
    func sendPausedToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "triggerPaused": "paused"
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendResumedToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "triggerResume": "resume"
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendEndedToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "triggerEnded": "ended"
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendDestinationNameToWatch(destination name: String) {
        if WCSession.default.isReachable {
            let message = [
                "destination": name
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendDestinationElevMaxToWatch(elevMax: Int) {
        if WCSession.default.isReachable {
            let message = [
                "maxelev": elevMax
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendDestinationElevMinToWatch(elevMin: Int) {
        if WCSession.default.isReachable {
            let message = [
                "elevmin": elevMin
            ] as [String: Any]
            do{
                try WCSession.default.updateApplicationContext(message)
            }catch{
                print("error sending data rest taken via app context: \(error.localizedDescription)")
            }
        }
    }
    
    func sendStartToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "isStart": true
            ] as [String: Any]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
    }
    
    func sendToHomeToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "isBackToHome": true
            ] as [String: Any]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
    }
    
    func sendRoleLeaderToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "roleLeader": "leader"
            ] as [String: Any]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
    }
    
    func sendRoleMemberToWatch() {
        if WCSession.default.isReachable {
            let message = [
                "roleMember": "member"
            ] as [String: Any]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
    }
    
}

extension WorkoutManager: WCSessionDelegate {
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let start = message["isWorkoutStart"] as? Bool {
            DispatchQueue.main.async {
                if start {
                    self.isWorkoutStarted = true
                    self.delegateV2?.didUpdateIsWorkoutStarted(self.isWorkoutStarted)
                }
            }
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let remaining = applicationContext["timerStart"] as? TimeInterval {
            DispatchQueue.main.async {
                self.remainingTime = remaining
            }
            
        } else if let elapsed = applicationContext["elapsed"] as? TimeInterval {
            DispatchQueue.main.async {
                self.elapsedTimeInterval = elapsed
                self.delegate?.didUpdateElapsedTimeInterval(elapsed)
            }
        } else if let walk = applicationContext["toDoWalk"] as? Int {
            DispatchQueue.main.async {
                self.whatToDo = .timeToWalk
                self.updateWhatToDo(to: self.whatToDo)
                self.delegate?.didUpdateWhatToDo(self.whatToDo)
            }
        } else if let toDo = applicationContext["toDoRest"] as? Int {
            DispatchQueue.main.async {
                self.whatToDo = .timeToRest
                self.updateWhatToDo(to: self.whatToDo)
                self.delegate?.didUpdateWhatToDo(self.whatToDo)
            }
        } else if let speed = applicationContext["speed"] as? Double {
            DispatchQueue.main.async {
                self.speed = speed
                self.updateSpeed(to: speed)
                self.delegate?.didUpdateSpeed(speed)
            }
        } else if let restTaken = applicationContext["restTaken"] as? Int {
            DispatchQueue.main.async {
                self.restTaken = restTaken
                self.updateRestAmount(to: restTaken)
                self.delegate?.didUpdateRestAmount(restTaken)
            }
        } else if let distance = applicationContext["distance"] as? Double {
            DispatchQueue.main.async {
                self.distance = distance
                self.delegate?.didUpdateDistance(distance)
            }
        } else if let isWorkoutPaused = applicationContext["isWorkoutPaused"] as? Bool {
            DispatchQueue.main.async {
                self.isWorkoutPaused = isWorkoutPaused
            }
        } else if let isWorkoutEnded = applicationContext["isWorkoutEnded"] as? Bool {
            DispatchQueue.main.async {
                self.isWorkoutEnded = isWorkoutEnded
            }
        } 
    }
}
