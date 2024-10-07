//
//  SummaryScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct SummaryScreen: View {
    
    @EnvironmentObject var userServices: UserServices
    @EnvironmentObject var navigationServices: NavigationServices
    @EnvironmentObject var metricVM: MetricsVM
    @EnvironmentObject var summaryVM: SummaryVM
    @EnvironmentObject var homeVM: HomeVM
    @State var isBackHome: Bool = true
    
    var body: some View {
//        NavigationStack(path: navigationServices.$path) {
            ScrollView {
                VStack(alignment: .center, spacing: 12) {
                    SummaryFirstView(
                        // "Great job! You made it back safely after the hike! ⛰️"
                        titleText: "\(isBackHome ? "What a great journey to \(String(metricVM.workoutManager?.selectedDestinationName ?? "Your Destination"))! ⛰️" : "What a great journey to \(String(metricVM.workoutManager?.selectedDestinationName ?? "Your Destination"))! ⛰️")",
                        subtitleText: "\(isBackHome ? "Take your iPhone and capture your moment! It’s a memory you'll want to keep from your amazing hike! 📸" : "Take your iPhone and capture your moment! It’s a memory you'll want to keep from your amazing hike! 📸")")
                    // "See you on the next journey! 👋🏻👋🏻👋🏻"
                    Divider()
                    SummarySecondView()
//                    Divider()
//                    Text("\(isBackHome ? "" : "Just keep in mind to set a time to head back and try to get home before it gets too late!")")
//                        .font(Font.system(size: 12, weight: .light))
                    
                    HKTextButton(
                        titleButton: "\(isBackHome ? "Return Home" : (userServices.userType == .member ? "Request to leader" : "Set a reminder"))",
                        widthButton: 173, heightButton: 54) {
                            
                        // MARK: Navigate / add path into Another Screen
                            if isBackHome {
                                homeVM.isWorkoutStartedVM = false
                                metricVM.workoutManager?.isWorkoutPaused = false
                                metricVM.workoutManager?.isWorkoutEnded = false
                                navigationServices.path.removeLast(navigationServices.path.count)
                            } else {
                                if userServices.userType == .leader {
                                    navigationServices.path.append("reminder")
                                } else {
                                    navigationServices.path.removeLast(navigationServices.path.count)
                                }
                            }
                    }
                }
            }
            .navigationTitle("Summary")
            .toolbarForegroundStyle(.orange, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onChange(of: summaryVM.isBackToHomeVM){_, back in
                if back {
                    navigationServices.path.removeLast(navigationServices.path.count)
                }
            }
            
        }
//    }
}

struct SummaryFirstView: View {
    @EnvironmentObject var metricVM: MetricsVM
    
    var titleText: String
    var subtitleText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(titleText)")
                .font(Font.system(size: 14, weight: .medium))
            Text("\(subtitleText)")
                .font(Font.system(size: 12, weight: .medium))
            Spacer()
        }
    }
}
    
struct SummarySecondView: View {
    @EnvironmentObject var metricVM: MetricsVM
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HKSummaryText(imageSymbol: "stopwatch", titleSymbol: "Duration", valueSymbol: metricVM.formatterTime(metricVM.workoutManager!.elapsedTimeInterval), unitSymbol: "", colorSymbol: .white)
            
            HKSummaryText(imageSymbol: "point.topleft.down.to.point.bottomright.curvepath.fill", titleSymbol: "Total Length", valueSymbol: String(Int(metricVM.workoutManager!.distance)), unitSymbol: "M", colorSymbol: .white)
            
            HKSummaryElevationText(highEle: metricVM.workoutManager?.selectedDestinationElevMax ?? 0, downEle: metricVM.workoutManager?.selectedDestinationElevMin ?? 0)
            
            HKSummaryText(imageSymbol: "heart.fill", titleSymbol: "Avg. Heart Rate", valueSymbol: String(Int(metricVM.workoutManager?.heartRate ?? 0)), unitSymbol: "", colorSymbol: .red)
        }
    }
}

#Preview {
    SummaryScreen()
        .environmentObject(MetricsVM(workoutManager: WorkoutManager()))
}
