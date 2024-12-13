//
//  MainBackgroundView.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import SwiftUI

struct MainBackgroundView: View {
    var isGetCoins = false
    var body: some View {
        Image(.bg)
            .resizable()
            .ignoresSafeArea()
            .overlay {
                if isGetCoins {
                    Image(.trees)
                        .resizable()
                        .ignoresSafeArea()
                }
            }
    }
}

#Preview {
    MainBackgroundView()
}
