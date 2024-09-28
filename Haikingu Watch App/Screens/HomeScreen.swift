//
//  HomeScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct HomeScreen: View {
    var isReturnHome: Bool = false
    @State var stack = [Int]()
    
    var body: some View {
        NavigationStack(path: $stack) {
            VStack(alignment: .leading, spacing: 10){
                
                ScrollView {
                    
                    if isReturnHome {
                        ReturnHomeScreen()
                            .padding(.all, 10)
                    } else {
                        EmptyHomeScreen()
                            .padding(.all, 10)
                    }
                }
            }
            .navigationTitle("Hikingu")
            .toolbarForegroundStyle(.orange, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
}

struct EmptyHomeScreen: View {
    var body: some View {
        
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

struct ReturnHomeScreen: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
            
            VStack(alignment: .center, spacing: 16){
                VStack(alignment: .leading, spacing: 8){
                    Text("Time to Go Home!")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 15, weight: .medium))
                    
                    Text("Don’t forget to head back in time and keep your energy up!")
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 13, weight: .light))
                    
                    HStack(spacing: 8){
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 17, height: 17)
                        Text("1.20.59 left")
                            .font(Font.system(size: 15, weight: .light))
                    }
                    
                }
                HKTextButton(titleButton: "Go now!", widthButton: 148, heightButton: 40) {
                    print("Go now tapped")
                }
            }
            .padding(.all, 8)
            
        }
    }
}

#Preview {
    HomeScreen()
}
