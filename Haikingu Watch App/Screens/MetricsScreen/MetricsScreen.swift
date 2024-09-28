//
//  MetricsScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct MetricsScreen: View {
    var stopwatchTimer: Timer = Timer()
    var timer: String = "24.59"
    var timerDistance: Int = 1670
    var bpmValue: Int = 100
    var restAmount: Int = 1
    var leftLength: Int = 4270
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading,spacing: 0) {
                    Text("\(stopwatchTimer.timeInterval)")
                        .font(Font.system(size: 16, weight: .medium))
                    
                    Text("\(timer)")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 34, weight: .bold))
                        .foregroundStyle(Color(.orange))
                }
                
                Text("Hike Time for \(timerDistance) M")
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .font(Font.system(size: 14, weight: .medium))
                    .border(.blue)
            }
//            .border(.red)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack{
                    Text("\(bpmValue)")
                        
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        
                }
                .font(Font.system(size: 24, weight: .semibold))
//                .border(.red)
                
                HKMetricBiggerText(intvalue: restAmount, intMeasure: "x", intDesc: "Rest taken")
//                    .border(.green)
                HKMetricBiggerText(intvalue: leftLength, intMeasure: "M", intDesc: "Left length")
//                    .border(.yellow)
            }
            Spacer()
        }

    }
}

#Preview {
    MetricsScreen()
}
