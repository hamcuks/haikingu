//
//  HKTextButton.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 27/09/24.
//

import SwiftUI

struct HKTextButton: View {
    var titleButton: String
    var widthButton: CGFloat
    var heightButton: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        }label: {
            Text("\(titleButton)")
                .foregroundColor(.black)
        }
        .frame(width: widthButton, height: heightButton)
        .buttonStyle(.borderless)
        .foregroundStyle(.red)
        .background(.orange)
        .clipShape(.capsule)
    }
}

#Preview {
    HKTextButton(titleButton: "Hallo Dunia!", widthButton: 150, heightButton: 40) {
        print("Kntol lo")
    }
}
