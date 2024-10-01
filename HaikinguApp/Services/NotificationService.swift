//
//  NotificationService.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 01/10/24.
//

import Foundation

protocol NotificationService {
    func requestPermission()
    func requestRest(for rest: TypeOfRestEnum)
    func createReminder(for title: String, body: String, date: Date, reminder: TimeInterval)
}
