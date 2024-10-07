//
//  HaikinguApp.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import SwiftUI

@main
struct HaikinguWatchAppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Inject var homeVM: HomeVM
    @Inject var metricsVM: MetricsVM
    @Inject var summaryVM: SummaryVM
    @StateObject var userServices = UserServices()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(NavigationServices())
                .environmentObject(homeVM)
                .environmentObject(metricsVM)
                .environmentObject(summaryVM)
                .environmentObject(userServices)
        }
    }
}
