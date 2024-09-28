//
//  SummaryScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct SummaryScreen: View {
    
    @State var stack: [Int] = [Int]()
    @State var isLeader: Bool = false
    @State var isBackHome: Bool = true
    
    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView {
                VStack(alignment: .center, spacing: 12) {
                    SummaryFirstView(
                        titleText: "\(isBackHome ? "Great job! You made it back safely after the hike! ⛰️" : "What a great journey to Bidadari Lake! ⛰️")",
                        subtitleText: "\(isBackHome ? "See you on the next journey! 👋🏻👋🏻👋🏻" : "Take your iPhone and capture your moment! It’s a memory you'll want to keep from your amazing hike! 📸")")
                    Divider()
                    SummarySecondView()
                    Divider()
                    Text("\(isBackHome ? "" : "Just keep in mind to set a time to head back and try to get home before it gets too late!")")
                        .font(Font.system(size: 12, weight: .light))
                    HKTextButton(titleButton: "\(isBackHome ? "Return Home" : (isLeader ? "Request to leader" : "Set a reminder"))", widthButton: 173, heightButton: 54) {
                        //MARK: TODO Navigate into Another Screen
                        print("\(isBackHome ? "Return Home" : (isLeader ? "Request to leader" : "Set reminder tapped"))")
                    }
                }
            }
            .navigationTitle("Summary")
            .toolbarForegroundStyle(.orange, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}


struct SummaryFirstView: View {
    
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
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HKSummaryText(imageSymbol: "stopwatch", titleSymbol: "Duration", valueSymbol: "1.25.30", unitSymbol: "", colorSymbol: .white)
            
            HKSummaryText(imageSymbol: "point.topleft.down.to.point.bottomright.curvepath.fill", titleSymbol: "Total Lenght", valueSymbol: "4350", unitSymbol: "M", colorSymbol: .white)
            
            HKSummaryElevationText(highEle: 120, downEle: 80)
            
            HKSummaryText(imageSymbol: "heart.fill", titleSymbol: "Avg. Heart Rate", valueSymbol: "120", unitSymbol: "", colorSymbol: .red)
        }
    }
}

#Preview {
    SummaryScreen()
}
