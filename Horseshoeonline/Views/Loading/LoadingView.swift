//
//  LoadingView.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack {
                Image(.logo)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .shadow(color: .yellow, radius: isAnimating ? 3 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.98)
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Text("LOADING...")
                    .hsfont(.customMilk, 32)
            }
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    LoadingView()
}
