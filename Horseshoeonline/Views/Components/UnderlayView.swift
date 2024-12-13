//
//  UnderlayView.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import SwiftUI

struct UnderlayView: View {
    let text: String
    let fontSize: CGFloat
    let fontColor: Color
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Text(text)
            .hsfont(fontColor, fontSize)
            .frame(maxWidth: width, maxHeight: height)
            .multilineTextAlignment(.center)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.milk)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.customRed, lineWidth: 3)
                    )
            )
    }
}

#Preview {
    UnderlayView(
        text: "PLAY",
        fontSize: 40,
        fontColor: .customRed,
        width: .infinity,
        height: .infinity
    )
    .padding()
}
