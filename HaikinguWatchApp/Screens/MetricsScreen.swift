//
//  MetricsScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 29/09/24.
//

import SwiftUI
import Swinject

struct MetricsScreen: View {
    @EnvironmentObject var userServices: UserServices
    @EnvironmentObject var metricsVM: MetricsVM
    @State var isPaused: Bool = false

    var body: some View {
        ZStack {
            TabView(selection: $metricsVM.pageNumber) {
                
                if userServices.userType == .member {
                    MemberControlView()
                        .tag(0)
                } else if userServices.userType == .leader {
                    LeadControlView(isPaused: $isPaused)
                        .tag(0)
                }
           
                MetricsView()
                    .tag(1)
                
            }
            .onChange(of: metricsVM.workoutManager!.isWorkoutPaused) { _, paused in
                if paused {
                    isPaused = true
                } else {
                    isPaused = false
                }
            }
            .tabViewStyle(.page)
            
        }
        .navigationBarBackButtonHidden(true)
//            .background(DisableSwipeBackGesture())
        
    }
    
}

#Preview {
    MetricsScreen()
        .environmentObject(UserServices())
        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
}
