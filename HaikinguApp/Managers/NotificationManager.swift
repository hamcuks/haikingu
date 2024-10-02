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
    
    func requestRest(for rest: TypeOfRestEnum, name: String?) {
        let content = UNMutableNotificationContent()
        
        content.title = rest.getTitle(for: name)
        content.body = rest.getBody(for: name)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error: \(error)")
            }
        }
    }
    
    func createReminder(for title: String, body: String, date: Date, reminder: TimeInterval) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Buat trigger untuk notifikasi
        let triggerDate = date.addingTimeInterval(-reminder)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully for \(triggerDate)")
            }
        }
        
    }
}
