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
        
        TimelineView(MetricsTimelineSchedule(from: metricsVM.workoutManager?.session?.startDate ?? Date(),
                                             isPaused: metricsVM.workoutManager?.sessionState == .paused)) { context in
            VStack(alignment: .leading, spacing: 2) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        ElapsedTimeView(elapsedTime: elapsedTime(with: context.date), showSubseconds: context.cadence == .live)
                            .foregroundStyle(.white)
                        
                        RemainingTimeView(remainingTime: remainingTime(with: context.date)) //, showSubseconds: context.cadence == .live
                            .foregroundStyle(.orange)
                    }
                     
                    if metricsVM.workoutManager?.whatToDo == .timeToWalk {
                        Text("Hike Time for \(metricsVM.timerDistance) M")
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 14, weight: .medium))
                    } else {
                        Text("Rest Time")
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .font(Font.system(size: 14, weight: .medium))
                    }
                    
                }
    //            .border(.red)
                
                VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("\(Int(metricsVM.workoutManager!.heartRate))")
                                
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                                
                        }
                        .font(Font.system(size: 20, weight: .semibold))
                    
    //                .border(.red)
                    
                    HKMetricBiggerText(intvalue: metricsVM.workoutManager?.restTaken ?? 0, intMeasure: "x", intDesc: "Rest taken")
    //                    .border(.green)
                    HKMetricBiggerText(intvalue: Int(metricsVM.workoutManager!.distance), intMeasure: "M", intDesc: "Distance")
    //                    .border(.yellow)
                }
    //            Spacer()
            }
        }
        
    }
    
    func elapsedTime(with contextDate: Date) -> TimeInterval {
        return metricsVM.workoutManager?.builder?.elapsedTime(at: contextDate) ?? 0
    }
    
    func remainingTime(with contextDate: Date) -> TimeInterval {
        return metricsVM.workoutManager!.remainingTime
    }
}

// #Preview {
//    MetricsView()
//        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
// }
