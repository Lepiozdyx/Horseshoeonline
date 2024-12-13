//
//  Color+Extension.swift
//  Horseshoe
//
//  Created by Alex on 03.12.2024.
//

import SwiftUI

extension Color {
    static let milk = LinearGradient(
        colors: [
            Color.white,
            Color.customMilk
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct Color_Extension: View {
    var body: some View {
        ZStack {
            Color.milk.ignoresSafeArea()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    Color_Extension()
}
