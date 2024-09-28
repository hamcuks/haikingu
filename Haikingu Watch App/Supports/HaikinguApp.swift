//
//  HaikinguApp.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import SwiftUI

@main
struct Haikingu_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
//    private let workoutManager = WorkoutManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
