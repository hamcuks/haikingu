//
//  NotificationManager.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 01/10/24.
//

import Foundation
import UserNotifications

class NotificationManager: NotificationService {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { _, error in
            if let error {
                print("NotificationManager: ", error.localizedDescription)
                return
            }
            
            print("NotificationManager: Success request for authorization")
        }
    }
    
    func requestRest(for rest: TypeOfRestEnum) {
        let content = UNMutableNotificationContent()
        content.title = rest.getTitle(for: "Fitra")
        content.body = rest.getBody(for: "Fitra")
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error: \(error)")
            }
        }
    }
    
    func createReminder(for title: String, body: String, date: Date, reminder: TimeInterval) {
        
    }
}
