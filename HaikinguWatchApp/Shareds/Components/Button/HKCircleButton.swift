//
//  HKCircleButton.swift
//  Haikingu Watch App
//
//  Created by Bayu Septyan Nur Hidayat on 27/09/24.
//

import SwiftUI

struct HKCircleButton: View {
    
    var imageButton: String
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    var padding: CGFloat
    var imageColor: Color
    var buttonColor: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        }label: {
            Image(systemName: "\(imageButton)")
                .resizable()
                .frame(width: imageWidth,
                       height: imageHeight)
//                .border(.red)
                .padding(.leading, padding)

        }
        .buttonStyle(.borderless)
        .frame(width: 77, height: 77)
        .foregroundStyle(imageColor)
        .background(buttonColor)
        .clipShape(Circle())
//        .border(.red)
    }
}

#Preview {
    HKCircleButton(imageButton: "play.fill", imageWidth: 35, imageHeight: 35, padding: 8, imageColor: .black, buttonColor: .red) {
        print("kntot")
    }
}
