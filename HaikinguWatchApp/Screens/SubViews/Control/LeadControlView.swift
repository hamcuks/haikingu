//
//  LeadControlScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI
import Swinject
import HealthKit

struct LeadControlView: View {
    @EnvironmentObject var metricsVM: MetricsVM
    @EnvironmentObject var navigationServices: NavigationServices
    @Binding var isPaused: Bool
    
    var body: some View {
       
            
        VStack(alignment: .center) {
            
            if metricsVM.workoutManager!.isWorkoutPaused == false {
                VStack(alignment: .center, spacing: 16) {
                    HKCircleButton(
                        imageButton: "pause.fill",
                        imageWidth: 35,
                        imageHeight: 35,
                        padding: 0,
                        imageColor: .black,
                        buttonColor: .orange) {
                            DispatchQueue.main.async {
                                metricsVM.workoutManager?.updateIsWorkoutPaused(to: true)
                                metricsVM.workoutManager?.pauseTimer()
                            }
                            metricsVM.isLeadPausedTapped = true
                            print("Paused Tapped")
                        }
                    
                    Text("Rest")
                        .font(Font.system(
                            size: 17,
                            weight: .semibold))
                }
                
            } else {
                HStack(alignment: .center, spacing: 18) {
                    VStack(alignment: .center, spacing: 16) {
                        HKCircleButton(
                            imageButton: "stop.fill",
                            imageWidth: 35,
                            imageHeight: 35,
                            padding: 0,
                            imageColor: .black,
                            buttonColor: .gray) {
                                DispatchQueue.main.async {
                                    metricsVM.workoutManager?.updateIsWorkoutEnded(to: true)
                                    metricsVM.workoutManager?.isWorkoutStart = false
                                    metricsVM.workoutManager?.session?.stopActivity(with: .now)
                                    Task {
                                        do{
                                            try await metricsVM.workoutManager?.session?.stopMirroringToCompanionDevice()
                                        } catch{
                                            print("Error to stop mirroring: \(error)")
                                        }
                                        
                                    }
                                    Task {
                                        await metricsVM.workoutManager?.stopWorkoutWatch()
                                    }
                                }
                                metricsVM.isLeadEndTapped = true
                                print("End Tapped")
                                DispatchQueue.main.async{
                                    metricsVM.pageNumber = 1
                                    metricsVM.workoutManager?.isWorkoutPaused = false
                                }
                                navigationServices.path.append("summary")
                                
                            }
                        Text("End")
                            .font(Font.system(
                                size: 17,
                                weight: .semibold))
                    }
                    
                    VStack(alignment: .center, spacing: 16) {
                        HKCircleButton(
                            imageButton: "play.fill",
                            imageWidth: 35,
                            imageHeight: 35,
                            padding: 8,
                            imageColor: .black,
                            buttonColor: .orange) {
                                DispatchQueue.main.async{
                                    metricsVM.workoutManager?.updateIsWorkoutPaused(to: false)
                                    metricsVM.workoutManager?.resumeTimer()
                                }
                                metricsVM.isLeadPausedTapped = false
                                
                                print("Play Tapped")
                            }
                        Text("Continue")
                            .font(Font.system(
                                size: 17,
                                weight: .semibold))
                    }
                }
            }
        }
        .navigationTitle("Control")
        .navigationBarTitleDisplayMode(.large)

    }
}


// #Preview {
//    LeadControlView()
//        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
//        .environmentObject(NavigationServices())
// }
