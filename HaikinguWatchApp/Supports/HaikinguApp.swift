//
//  HaikinguApp.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import SwiftUI

@main
struct HaikinguWatchAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(HomeVM())
                .environmentObject(UserServices())
        }
    }
}
