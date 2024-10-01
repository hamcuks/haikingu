//
//  HaikinguApp.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import SwiftUI

@main
struct HaikinguWatchAppApp: App {
    @Inject var homeVM : HomeVM
    @Inject var metricsVM : MetricsVM
    @StateObject var userServices = UserServices()
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(NavigationServices())
                .environmentObject(homeVM)
                .environmentObject(metricsVM)
                .environmentObject(userServices)
        }
    }
}
