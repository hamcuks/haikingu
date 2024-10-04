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
    @State var isBackHome: Bool = true
    
    var body: some View {
//        NavigationStack(path: navigationServices.$path) {
            ScrollView {
                VStack(alignment: .center, spacing: 12) {
                    SummaryFirstView(
                        titleText: "\(isBackHome ? "Great job! You made it back safely after the hike! ⛰️" : "What a great journey to Bidadari Lake! ⛰️")",
                        subtitleText: "\(isBackHome ? "See you on the next journey! 👋🏻👋🏻👋🏻" : "Take your iPhone and capture your moment! It’s a memory you'll want to keep from your amazing hike! 📸")")
                    Divider()
                    SummarySecondView()
//                    Divider()
//                    Text("\(isBackHome ? "" : "Just keep in mind to set a time to head back and try to get home before it gets too late!")")
//                        .font(Font.system(size: 12, weight: .light))
                    
                    HKTextButton(
                        titleButton: "\(isBackHome ? "Return Home" : (userServices.userType == .leader ? "Request to leader" : "Set a reminder"))",
                        widthButton: 173, heightButton: 54) {
                            
                        // MARK: Navigate / add path into Another Screen
                            if isBackHome {
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
            HKSummaryText(imageSymbol: "stopwatch", titleSymbol: "Duration", valueSymbol: metricVM.workoutManager?.workout?.totalTime ?? "00:00:00", unitSymbol: "", colorSymbol: .white)
            
            HKSummaryText(imageSymbol: "point.topleft.down.to.point.bottomright.curvepath.fill", titleSymbol: "Total Length", valueSymbol: metricVM.workoutManager?.workout?.totalWalkingDistance ?? "0", unitSymbol: "M", colorSymbol: .white)
            
            HKSummaryElevationText(highEle: 120, downEle: 80)
            
            HKSummaryText(imageSymbol: "heart.fill", titleSymbol: "Avg. Heart Rate", valueSymbol: metricVM.workoutManager?.workout?.averageHeartRate ?? "0", unitSymbol: "", colorSymbol: .red)
        }
    }
}

#Preview {
    SummaryScreen()
        .environmentObject(MetricsVM(workoutManager: WorkoutManager()))
}
