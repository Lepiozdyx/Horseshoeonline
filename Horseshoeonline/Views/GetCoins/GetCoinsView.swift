//
//  GetCoinsView.swift
//  Horseshoe
//
//  Created by Alex on 06.12.2024.
//

import SwiftUI

struct GetCoinsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GetCoinsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MainBackgroundView(isGetCoins: true)
                
                VStack {
                    HStack {
                        Button {
                            viewModel.resetGame()
                            dismiss()
                        } label: {
                            BackView()
                        }
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
                
                // Game content
                Group {
                    switch viewModel.gameState {
                    case .initial:
                        startButton
                    case .playing:
                        gameView(in: geometry)
                    case .finished(let coins):
                        gameOverView(coins: coins)
                    }
                }
            }
            .onAppear {
                viewModel.updateLayout(
                    size: geometry.size,
                    safeArea: geometry.safeAreaInsets
                )
            }
            .onChange(of: geometry.size) { newSize in
                viewModel.updateLayout(
                    size: newSize,
                    safeArea: geometry.safeAreaInsets
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var startButton: some View {
        VStack {
            if !viewModel.canStartGame {
                Text("NOT ENOUGH HORSESHOES")
                    .hsfont(.customMilk, 20)
            }
            
            UnderlayView(
                text: "",
                fontSize: 30,
                fontColor: viewModel.canStartGame ? .customRed : .gray,
                width: 250,
                height: 64
            )
            .overlay {
                HStack {
                    Text("START")
                        .hsfont(.customRed, 30)
                    Image(.horseshoe)
                        .resizable()
                        .frame(width: 35, height: 40)
                    Text("10")
                        .hsfont(.customRed, 30)
                }
            }
        }
        .onTapGesture {
            viewModel.startGame()
        }
        .disabled(!viewModel.canStartGame)
        .opacity(viewModel.canStartGame ? 1 : 0.5)
    }
    
    private func gameView(in geometry: GeometryProxy) -> some View {
        ZStack {
            // Falling coins
            ForEach(viewModel.coins) { coin in
                FallingCoinView(
                    coin: coin,
                    screenHeight: geometry.size.height
                )
            }
            
            // Running horse
            RunningHorseView(
                position: viewModel.horsePosition,
                screenWidth: geometry.size.width
            )
        }
    }
    
    private func gameOverView(coins: Int) -> some View {
        VStack(spacing: 20) {
            UnderlayView(
                text: "",
                fontSize: 0,
                fontColor: .customRed,
                width: 300,
                height: 200
            )
            .overlay {
                VStack(spacing: 30) {
                    Text("CONGRATULATIONS!")
                        .hsfont(.customRed, 20)
                    
                    HStack {
                        Text("YOU GOT + \(coins)")
                            .hsfont(.customRed, 30)
                        
                        Image(.coin)
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        UnderlayView(
                            text: "MENU",
                            fontSize: 30,
                            fontColor: .customRed,
                            width: 200,
                            height: 50
                        )
                    }
                }
            }
        }
    }
}

struct FallingCoinView: View {
    let coin: CoinItem
    let screenHeight: CGFloat
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Image(.coin)
            .resizable()
            .frame(width: Constants.Screen.itemSize, height: Constants.Screen.itemSize)
            .position(x: coin.position.x, y: coin.position.y + offset)
            .onAppear {
                withAnimation(.linear(duration: Constants.Game.GetCoins.coinFallingDuration)) {
                    offset = screenHeight + Constants.Screen.itemSize * 2
                }
            }
    }
}

struct RunningHorseView: View {
    let position: CGFloat
    let screenWidth: CGFloat
    
    @State private var currentFrame = 1
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.height * 0.25
            
            Image("horse\(currentFrame)")
                .resizable()
                .frame(width: size * 1.5, height: size)
                .position(x: position, y: geometry.size.height * 0.75)
                .onChange(of: position) { newPosition in
                    updateHorseAnimation(position: newPosition)
                }
        }
    }
    
    private func updateHorseAnimation(position: CGFloat) {
        let progress = position / screenWidth
        if progress < 0.33 {
            currentFrame = 1
        } else if progress < 0.66 {
            currentFrame = 2
        } else {
            currentFrame = 3
        }
    }
}

#Preview {
    NavigationView {
        GetCoinsView()
    }
}
