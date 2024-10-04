//
//  HKBiggerSmallText.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct HKMetricBiggerText: View {
    
    var intvalue: Int
    var intMeasure: String
    var intDesc: String
    
    var body: some View {
//        GeometryReader { geo in
            HStack(spacing: 4) {
                HStack(spacing: 0) {
                    Text("\(intvalue)")
                        .font(Font.system(size: 24, weight: .semibold))
                    Text("\(intMeasure)")
                        .font(Font.system(size: 20, weight: .regular))
                        .padding(.top, 3)
                }
                Text("\(intDesc)")
                    .font(Font.system(size: 12, weight: .semibold))
                    .padding(.top, 8)
            }
//            .onAppear{
//                print("width \(geo.size.width), height \(geo.size.height)")
//            }
            
        }
//    }
}

#Preview {
    HKMetricBiggerText(intvalue: 1000, intMeasure: "M", intDesc: "Left length")
}
