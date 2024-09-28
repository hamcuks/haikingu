//
//  LeadControlScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct LeadControlScreen: View {
    
    @State var isPausedTapped: Bool = false
    @State var isEndTapped: Bool = false
    @State var stack = [Int]()
    
    var body: some View {
        
        NavigationStack(path: $stack) {
            VStack(alignment: .center) {
                
                if !isPausedTapped {
                    VStack(alignment: .center, spacing: 16){
                        HKCircleButton(imageButton: "pause.fill", imageWidth: 35, imageHeight: 35, padding: 0, imageColor: .black, buttonColor: .orange) {
                            isPausedTapped = true
                            print("Paused Tapped")
                        }
                        
                        Text("Rest")
                            .font(Font.system(
                                size: 17,
                                weight: .semibold))
                    }
                    
                } else {
                    HStack(alignment: .center, spacing: 18) {
                        VStack(alignment: .center, spacing: 16){
                            HKCircleButton(imageButton: "stop.fill", imageWidth: 35, imageHeight: 35, padding: 0, imageColor: .black, buttonColor: .gray) {
                                isEndTapped = true
                                print("End Tapped")
                            }
                            Text("End")
                                .font(Font.system(
                                    size: 17,
                                    weight: .semibold))
                        }
                            
                        VStack(alignment: .center, spacing: 16){
                            HKCircleButton(imageButton: "play.fill", imageWidth: 35, imageHeight: 35, padding: 8, imageColor: .black, buttonColor: .orange) {
                                isPausedTapped = false
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
        }
        
    }
}

#Preview {
    LeadControlScreen()
}
