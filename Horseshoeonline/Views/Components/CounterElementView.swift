//
//  CounterElementView.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import SwiftUI

struct CounterElementView: View {
    let image: ImageResource
    let text: String
    
    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(6)
                .background(
                    Circle()
                        .foregroundStyle(.customRed)
                        .overlay(
                            Circle()
                                .stroke(.customMilk, lineWidth: 2)
                        )
                )
            
            UnderlayView(
                text: text,
                fontSize: 20,
                fontColor: .customRed,
                width: 141,
                height: 44
            )
        }
    }
}

#Preview {
    CounterElementView(image: .coin, text: "250")
        .padding()
        .background(Color.gray)
}
