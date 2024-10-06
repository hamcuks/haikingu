//
//  HKSummaryText.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 28/09/24.
//

import SwiftUI

struct HKSummaryText: View {
    
    var imageSymbol: String
    var titleSymbol: String
    var valueSymbol: String
    var unitSymbol: String
    var colorSymbol: Color
    
    var body: some View {
        HStack {
            Image(systemName: "\(imageSymbol)")
                .font(Font.system(size: 28, weight: .semibold))
                .foregroundStyle(colorSymbol)
            VStack(alignment: .leading) {
                Text("\(titleSymbol)")
                    .font(Font.system(size: 14, weight: .light))
                
                HStack(alignment: .bottom) {
                    Text("\(valueSymbol)")
                        .font(Font.system(size: 28, weight: .semibold))
                    Text("\(unitSymbol)")
                        .font(Font.system(size: 24, weight: .regular))
                }
            }
        }
    }
}

struct HKSummaryElevationText: View {
    
    var highEle: Int
    var downEle: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.up.right")
                .font(Font.system(size: 32, weight: .semibold))
                
            VStack(alignment: .leading) {
                Text("Elevation")
                    .font(Font.system(size: 14, weight: .light))
                
                HStack(alignment: .bottom) {
                    Text("\(highEle)")
                        .font(Font.system(size: 32, weight: .semibold))
                    Text("M")
                        .font(Font.system(size: 24, weight: .regular))
                }
                
                HStack(alignment: .bottom) {
                    Text("\(downEle)")
                        .font(Font.system(size: 32, weight: .semibold))
                    Text("M")
                        .font(Font.system(size: 24, weight: .regular))
                }
            }
            
            VStack {
                Image(systemName: "chevron.up")
                    .font(Font.system(size: 32, weight: .semibold))
                    .padding(.top, 25)
                
                Image(systemName: "chevron.down")
                    .font(Font.system(size: 32, weight: .semibold))
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    HKSummaryElevationText(highEle: 95, downEle: 65)
}
