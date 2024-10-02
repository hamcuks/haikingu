//
//  HomeScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//
import SwiftUI
import HealthKit
import Swinject

struct HomeScreen: View {
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var navigationServices: NavigationServices
    
        var body: some View {
            NavigationStack(path: $navigationServices.path) {
                VStack(alignment: .leading, spacing: 10) {
                    //            ScrollView {
                    if homeVM.isHasContent {
                        if homeVM.isReturnHome {
                            ContentOpeningScreen()
                                .padding(.all, 10)
                        } else {
                            ContentOpeningScreen()
                                .padding(.all, 10)
                        }
                    } else {
                        emptyOpeningScreen
                            .padding(.all, 10)
                    }
                    //            }
                }
                .navigationTitle("Haikingu")
                .toolbarForegroundStyle(.orange, for: .navigationBar)
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: String.self) { destini in
                    if destini == "metrics" {
                        MetricsScreen()
                    } else if destini == "summary" {
                        //                Container.shared.resolve(SummaryScreen.self)
                    } else if destini == "reminder" {
                        //                    ReminderScreen()
                    }
                }
                .onAppear() {
                    homeVM.workoutManager?.requestAuthorization()
                }
        }
    }
    private var emptyOpeningScreen: some View {
        VStack {
            Text("No Started Hiking")
                .font(Font.system(.body, weight: .medium))
                .padding(.bottom, 8)
            Text("To start hiking, Open the Haikingu app on your iPhone to set up your hike.")
                .multilineTextAlignment(.center)
                .font(Font.system(.footnote, weight: .light))
        }
    }
}

struct ContentOpeningScreen: View {
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var navigationServices: NavigationServices
    @EnvironmentObject var workoutManager: WorkoutManager
  
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(homeVM.titleDestination ?? "Time to Go Home!")")
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 15, weight: .medium))
                        
                        Text("\(homeVM.subtitleDestination ?? "Don't forget to head back in time and keep your energy up!")")
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 13, weight: .light))
                        
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 17, height: 17)
                            Text("\(homeVM.valueDestination ?? "00:00:00 left")")
                                .font(Font.system(size: 15, weight: .light))
                        }
                    }
                    HKTextButton(titleButton: "Go now!", widthButton: 148, heightButton: 40) {
                        navigationServices.path.append("metrics")
                        startWorkout()
                        print("button tappep")
                    }
                }
                .padding(.all, 8)
            }
    }
    
    private func startWorkout() {
        Task {
            do {
                let configuration = HKWorkoutConfiguration()
                configuration.activityType = .hiking
                configuration.locationType = .outdoor
                try await homeVM.workoutManager?.startWorkout(workoutConfiguration: configuration)
            } catch {
                print("error bang gagal")
            }
        }
    }
    
}

#Preview {
    HomeScreen()
        .environmentObject(Container.shared.resolve(HomeVM.self)!)
        .environmentObject(NavigationServices())
}
