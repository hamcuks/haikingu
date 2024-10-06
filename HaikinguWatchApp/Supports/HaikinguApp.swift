//
//  HaikinguApp.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import SwiftUI
import Swinject

@main
struct HaikinguWatchAppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Inject var homeVM: HomeVM
    @Inject var metricsVM: MetricsVM
    @Inject var sumarryVM: SummaryVM
    @StateObject var userServices = UserServices()
    @StateObject var appState = AppState()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationServices())
                .environmentObject(homeVM)
                .environmentObject(metricsVM)
                .environmentObject(userServices)
                .environmentObject(appState)
                .onAppear {
                    appDelegate.appState = appState
                }
                
        }
    }
}
