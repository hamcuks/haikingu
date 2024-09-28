//
//  MemberControlScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct MemberControlScreen: View {
    
    @State var isRequestRest: Bool = true
    @State var stack = [Int]()
    
    var body: some View {
        NavigationStack(path: $stack) {
            VStack {
                
                if !isRequestRest {
                    VStack(alignment: .center, spacing: 16){
                        HKCircleButton(imageButton: "pause.fill", imageWidth: 35, imageHeight: 35, padding: 0, imageColor: .black, buttonColor: .orange) {
                            isRequestRest = true
                            print("Request Tapped")
                        }
                        
                        Text("Request Rest")
                            .font(Font.system(.body, weight: .semibold))
                    }
                } else {
                    VStack(alignment: .center, spacing: 16){
                        
                        HKCircleButton(imageButton: "clock.fill", imageWidth: 35, imageHeight: 35, padding: 0, imageColor: .black, buttonColor: .orange) {
                            
                            //MARK: Another function triggered
                            
                            isRequestRest = false   
                        }
                        Text("Requested")
                            .font(Font.system(.body, weight: .semibold))
                    }
                    .onAppear {
                        //MARK: Something Triggered
                    }
                }
            }
            .navigationTitle("Control")
        }
    }
}

#Preview {
    MemberControlScreen()
}
