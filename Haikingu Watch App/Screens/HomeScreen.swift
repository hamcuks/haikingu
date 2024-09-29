//
//  HomeScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var navigationServices = NavigationServices()
    @EnvironmentObject var homeVM: HomeVM
    
    var body: some View {
        NavigationStack(path: $navigationServices.path) {
            VStack(alignment: .leading, spacing: 10){
                
                
                ScrollView {
                    
                    if homeVM.isHasContent {
                        if homeVM.isReturnHome {
                            ContentHomeScreen(navigationServices: navigationServices, titleHomeScreen: "Time to Go Home!", subtitleHomeScreen: "Don’t forget to head back in time and keep your energy up!", valueHomeScreen: homeVM.valueReturnHome)
                                .padding(.all, 10)
                        } else {
                            ContentHomeScreen(navigationServices: navigationServices, titleHomeScreen: "\(homeVM.titleDestination)", subtitleHomeScreen: "\(homeVM.subtitleDestination)", valueHomeScreen: homeVM.valueDestination)
                                .padding(.all, 10)
                        }
                    } else {
                        EmptyHomeScreen
                            .padding(.all, 10)
                    }
                }
            }
            .navigationTitle("Hikingu")
            .toolbarForegroundStyle(.orange, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: String.self) { destini in
                if destini == "metrics"{
                    MetricsScreen()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(MetricsVM())
                        .environmentObject(UserServices())
                } else if destini == "summary"{
                    SummaryScreen()
                        .environmentObject(UserServices())
                        .environmentObject(navigationServices)
                } else if destini == "reminder" {
//                    ReminderScreen()
                } 
            }
        }
        .onAppear {
            //MARK: TODO Something like refresh UI:
            ///1. after finish hiking (arrive into destination)
            ///2. after return back home
            
        }
    }
    
    private var EmptyHomeScreen: some View {
        
        VStack{
            Text("No Started Hiking")
                .font(Font.system(.body, weight: .medium))
                .padding(.bottom, 8)
            Text("To start hiking, Open the Haikingu app on your iPhone to set up your hike.")
                .multilineTextAlignment(.center)
                .font(Font.system(.footnote, weight: .light))
            
        }
    }
}

struct ContentHomeScreen: View {
    
    @ObservedObject var navigationServices : NavigationServices
    var titleHomeScreen: String
    var subtitleHomeScreen: String
    var valueHomeScreen: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
            
            VStack(alignment: .center, spacing: 16){
                VStack(alignment: .leading, spacing: 8){
                    Text("\(titleHomeScreen)")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 15, weight: .medium))
                    
                    Text("\(subtitleHomeScreen)")
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 13, weight: .light))
                    
                    HStack(spacing: 8){
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 17, height: 17)
                        Text("\(valueHomeScreen) left")
                            .font(Font.system(size: 15, weight: .light))
                    }
                    
                }
                HKTextButton(titleButton: "Go now!", widthButton: 148, heightButton: 40) {
                    navigationServices.path.append("metrics")
                }
            }
            .padding(.all, 8)
            
        }
    }
}

//#Preview {
//    HomeScreen(navigationServices: <#NavigationService#>)
//}
