//
//  MetricsScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 29/09/24.
//

import SwiftUI

struct MetricsScreen: View {
    @EnvironmentObject var userServices: UserServices
    @EnvironmentObject var metricsVM: MetricsVM
    
    var body: some View {
//        NavigationStack {
            TabView(selection: $metricsVM.pageNumber) {
                
                if userServices.userType == .member {
                    MemberControlView()
                        .environmentObject(metricsVM)
                        .tag(0)
                } else if userServices.userType == .leader {
                    LeadControlView()
                        .environmentObject(metricsVM)
                        .tag(0)
                }
                
                MetricsView()
                    .environmentObject(metricsVM)
                    .tag(1)
                
            }
            .tabViewStyle(.page)
            .navigationBarBackButtonHidden(true)
//            .background(DisableSwipeBackGesture())
//        }
    }
    
}

#Preview {
    MetricsScreen()
        .environmentObject(UserServices())
}
