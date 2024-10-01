//
//  MemberControlView.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct MemberControlView: View {
    
    @EnvironmentObject var metricsVM: MetricsVM
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if !metricsVM.isMemberRequestRest {
                    VStack(alignment: .center, spacing: 16){
                        HKCircleButton(imageButton: "pause.fill", imageWidth: 35, imageHeight: 35, padding: 0, imageColor: .black, buttonColor: .orange) {
                            metricsVM.isMemberRequestRest = true
                            print("Request Tapped")
                        }
                        
                        Text("Request Rest")
                            .font(Font.system(.body, weight: .semibold))
                    }
                } else {
                    VStack(alignment: .center, spacing: 16){
                        
                        HKCircleButton(imageButton: "clock.fill", imageWidth: 35, imageHeight: 35, padding: 0, imageColor: .black, buttonColor: .orange) {
                            
                            //MARK: Another function triggered
                            
                            metricsVM.isMemberRequestRest = false   
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
    MemberControlView()
}
