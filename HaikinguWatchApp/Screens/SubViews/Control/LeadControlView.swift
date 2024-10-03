//
//  LeadControlScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI
import Swinject

struct LeadControlView: View {
    @EnvironmentObject var metricsVM: MetricsVM
    @EnvironmentObject var navigationServices: NavigationServices
    @Binding var isPaused: Bool
    
    var body: some View {
        NavigationStack(path: $navigationServices.path){
            
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
                            metricsVM.workoutManager?.updateIsWorkoutPaused(to: true)
                            metricsVM.isLeadPausedTapped = true
                            metricsVM.workoutManager?.pauseTimer()
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
                                metricsVM.workoutManager?.session?.stopActivity(with: .now)
                                metricsVM.isLeadEndTapped = true
                                if let workout = metricsVM.workoutManager?.workout {
                                    print("Total Time: \(workout.totalTime)") // Pastikan data sudah diisi
                                    print("Total Distance: \(workout.totalWalkingDistance)")
                                    print("Average Heart Rate: \(workout.averageHeartRate)")
                                } else {
                                    print("Workout data is nil. Make sure it is initialized properly.")
                                }
                                print("End Tapped")
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
                                metricsVM.workoutManager?.updateIsWorkoutPaused(to: false)
                                metricsVM.isLeadPausedTapped = false
                                metricsVM.workoutManager?.resumeTimer()
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
        .navigationDestination(for: String.self) { destini in
            if destini == "metrics" {
                MetricsScreen()
            } else if destini == "summary" {
                SummaryScreen()
            } else if destini == "reminder" {
                //                    ReminderScreen()
            }
        }
    }
    }
}

//#Preview {
//    LeadControlView()
//        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
//        .environmentObject(NavigationServices())
//}
