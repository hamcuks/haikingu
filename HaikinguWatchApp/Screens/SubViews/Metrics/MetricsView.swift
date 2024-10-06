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
        ZStack {
            // Konten utama MetricsView
            TimelineView(MetricsTimelineSchedule(from: metricsVM.workoutManager?.session?.startDate ?? Date(),
                                                 isPaused: metricsVM.workoutManager?.sessionState == .paused)) { context in
                VStack(alignment: .leading, spacing: 2) {
                    VStack(alignment: .leading, spacing: 0) {
                        ElapsedTimeView(elapsedTime: elapsedTime(with: context.date))
                            .foregroundStyle(.white)
                        
                        RemainingTimeView(remainingTime: remainingTime(with: context.date))
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
                .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("\(Int(metricsVM.workoutManager!.heartRate))")
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                    .font(Font.system(size: 20, weight: .semibold))
                    
                    HKMetricBiggerText(intvalue: metricsVM.workoutManager?.restTaken ?? 0, intMeasure: "x", intDesc: "Rest taken")
                    HKMetricBiggerText(intvalue: Int(metricsVM.workoutManager!.distance), intMeasure: "M", intDesc: "Distance")
                }
//                .border(.red)
                .padding(.trailing, 50)
            }
            .padding()
//            .border(.red)
            
            if metricsVM.isPersonTiredVM {
                VStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.red)
                    
                    // Title dari alert
                    Text("BPM too High!")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    // Title dari alert
                    Text("Take a rest immediately!")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2, reservesSpace: true)
                        .padding(.bottom, 10)

                    Button {
                        metricsVM.isPersonTiredVM = false // Tutup alert
                    } label: {
                        Text("Rest Now!")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(15)
                .shadow(radius: 10)
                .transition(.scale)
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

 #Preview {
    MetricsView()
        .environmentObject(Container.shared.resolve(MetricsVM.self)!)
 }
