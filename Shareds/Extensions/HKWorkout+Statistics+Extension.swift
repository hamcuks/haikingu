//
//  HKWorkout+Statistics+Extension.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 03/10/24.
//

import Foundation
import HealthKit

// MARK: - Workout statistics
//
extension HKWorkout {
    var totalTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        print("Ini value duration : \(formatter)")
        return formatter.string(from: duration) ?? ""
    }
    
    var averageWalkingSpeed: String {
        var value: Double = 0
        if let statistics = statistics(for: HKQuantityType(.walkingSpeed)),
           let average = statistics.averageQuantity() {
            value = average.doubleValue(for: HKUnit.mile().unitDivided(by: HKUnit.hour()))
        }
        let measurement = Measurement(value: value, unit: UnitSpeed.kilometersPerHour)
        let numberStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0))
        print("Ini value walking speed : \(measurement)")
        return measurement.formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle: numberStyle))
    }

    var totalWalkingDistance: String {
        var value: Double = 0
        if let statistics = statistics(for: HKQuantityType(.distanceWalkingRunning)),
           let sum = statistics.sumQuantity() {
            value = sum.doubleValue(for: .meter())
        }
        let measurement = Measurement(value: value, unit: UnitLength.meters)
        let numberStyle: FloatingPointFormatStyle<Double> = .number.precision(.fractionLength(2))
        print("Ini value distance : \(measurement)")
        return measurement.formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: numberStyle))
    }
    
    var totalEnergy: String {
        var value: Double = 0
        if let statistics = statistics(for: HKQuantityType(.activeEnergyBurned)),
           let sum = statistics.sumQuantity() {
            value = sum.doubleValue(for: .kilocalorie())
        }
        let measurement = Measurement(value: value, unit: UnitEnergy.kilocalories)
        let numberStyle = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0))
        return measurement.formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: numberStyle))
    }
    
    var averageHeartRate: String {
        var value: Double = 0
        if let statistics = statistics(for: HKQuantityType(.heartRate)),
           let average = statistics.mostRecentQuantity() {
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            value = average.doubleValue(for: heartRateUnit)
        }
        print("ini value average heart rate: \(value)")
        return value.formatted(.number.precision(.fractionLength(0))) + " bpm"
    }
}
