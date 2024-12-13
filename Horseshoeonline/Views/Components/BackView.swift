//
//  BackView.swift
//  Horseshoe
//
//  Created by Alex on 05.12.2024.
//

import SwiftUI

struct BackView: View {
    var body: some View {
        Image(systemName: "arrow.left")
            .foregroundStyle(.white)
            .padding(6)
            .background(
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.customRed)
                    .overlay(
                        Circle()
                            .stroke(.customMilk, lineWidth: 2)
                    )
            )
    }
}

#Preview {
    BackView()
}
