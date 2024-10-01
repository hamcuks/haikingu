//
//  MetricsScreen.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI
import Swinject

struct MetricsView: View {
    @EnvironmentObject var metricsVM: MetricsVM
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(metricsVM.stopwatchTimer.timeInterval)")
                        .font(Font.system(size: 16, weight: .medium))
                    
                    Text("\(metricsVM.timer)")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 34, weight: .bold))
                        .foregroundStyle(Color(.orange))
                }
                
                Text("Hike Time for \(metricsVM.timerDistance) M")
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .font(Font.system(size: 14, weight: .medium))
                    .border(.blue)
            }
//            .border(.red)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(Int(metricsVM.workoutManager!.heartRate))")
                        
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        
                }
                .font(Font.system(size: 24, weight: .semibold))
//                .border(.red)
                
                HKMetricBiggerText(intvalue: metricsVM.restAmount, intMeasure: "x", intDesc: "Rest taken")
//                    .border(.green)
                HKMetricBiggerText(intvalue: metricsVM.leftLength, intMeasure: "M", intDesc: "Left length")
//                    .border(.yellow)
            }
//            Spacer()
        }

    }
}

#Preview {
    MetricsView()
        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
}
