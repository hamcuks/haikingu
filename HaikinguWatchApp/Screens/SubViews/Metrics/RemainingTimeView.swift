//
//  RemainingTimeView.swift
//  HaikinguApp
//
//  Created by I Gusti Ngurah Surya Ardika Dinataputra on 02/10/24.
//

import SwiftUI

struct RemainingTimeView: View {
    var remainingTime: TimeInterval = 0
    var showSubseconds = false
    @State private var timeFormatter = RemainingTimeFormatter()

    var body: some View {
        Text(NSNumber(value: remainingTime), formatter: timeFormatter)
            .lineLimit(2)
            .font(Font.system(size: 34, weight: .bold))
//            .onChange(of: showSubseconds) { (_, newValue) in
//                timeFormatter.showSubseconds = newValue
//            }
    }
}

class RemainingTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }


        return formattedString
    }
}
