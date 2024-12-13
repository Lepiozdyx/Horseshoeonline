//
//  Text+Extension.swift
//  Horseshoe
//
//  Created by Alex on 03.12.2024.
//

import SwiftUI

extension Text {
    func hsfont(_ color: Color, _ size: CGFloat) -> some View {
        self
            .foregroundStyle(color)
            .font(.system(size: size, weight: .bold))
    }
}

struct Text_Extension: View {
    var body: some View {
        Text("PLAY")
            .hsfont(.customRed, 30)
    }
}

#Preview {
    Text_Extension()
}
