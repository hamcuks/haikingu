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
    @EnvironmentObject var navigationServices: NavigationServices
    @State var isPaused: Bool = false
    
    var body: some View {
//        NavigationStack(path: $navigationServices.path){
            ZStack {
                TabView(selection: $metricsVM.pageNumber) {
                    
                    if metricsVM.roleVM == .member {
                        MemberControlView()
                            .tag(0)
                    } else if metricsVM.roleVM == .leader {
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
            .onChange(of: metricsVM.isWorkoutEnded) { _, ended in
                navigationServices.path.append("summary")
                Task {
                    
                    await metricsVM.workoutManager?.stopWorkoutWatch()
                    
                    
                }
            }
//        }
        
        
        
    }
    
}

//#Preview {
//    MetricsScreen()
//        .environmentObject(UserServices())
//        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
//}
