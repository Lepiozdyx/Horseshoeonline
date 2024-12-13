//
//  PlayView.swift
//  Horseshoe
//
//  Created by Alex on 05.12.2024.
//

import SwiftUI

struct PlayView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PlayViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MainBackgroundView()
                
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
                
                switch viewModel.gameState {
                case .initial:
                    startButton
                case .countdown(let count):
                    countdownView(count: count)
                case .playing:
                    gameView(in: geometry)
                case .finished:
                    gameOverView
                case .paused:
                    EmptyView()
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
        Button {
            viewModel.startGame()
        } label: {
            UnderlayView(
                text: "START",
                fontSize: 30,
                fontColor: .customRed,
                width: 200,
                height: 64
            )
        }
    }
    
    private func countdownView(count: Int) -> some View {
        Text("\(count)")
            .hsfont(.customRed, 50)
            .transition(.scale)
    }
    
    private func gameView(in geometry: GeometryProxy) -> some View {
        ZStack {
            // Timer
            VStack {
                UnderlayView(
                    text: String(format: "%.0f", viewModel.timeRemaining),
                    fontSize: 30,
                    fontColor: .customRed,
                    width: 150,
                    height: 44
                )
                
                Spacer()
            }
            .padding(.top)
            
            // Falling items area
            ForEach(viewModel.items) { item in
                FallingItemView(
                    item: item,
                    screenHeight: geometry.size.height,
                    onTap: {
                        viewModel.tapItem(item)
                    }
                )
            }
            
            // Penalty overlay
            if viewModel.isPenalty {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .allowsHitTesting(false)
                
                UnderlayView(
                    text: "Wait 5 seconds",
                    fontSize: 30,
                    fontColor: .customRed,
                    width: 300,
                    height: 80
                )
                .transition(.scale)
                .allowsHitTesting(false)
            }
        }
    }
    
    private var gameOverView: some View {
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
                    HStack {
                        Text("YOU GOT + \(viewModel.score)")
                            .hsfont(.customRed, 30)
                        
                        Image(.horseshoe)
                            .resizable()
                            .frame(width: 30, height: 35)
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

struct FallingItemView: View {
    let item: GameItem
    let screenHeight: CGFloat
    let onTap: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Image(item.type.imageName)
            .resizable()
            .frame(width: Constants.Screen.itemSize, height: Constants.Screen.itemSize)
            .position(x: item.position.x, y: item.position.y + offset)
            .opacity(item.isEnabled ? 1 : 0)
            .onTapGesture {
                guard item.isEnabled else { return }
                onTap()
            }
            .onAppear {
                withAnimation(.linear(duration: Constants.Game.Play.itemFallingDuration)) {
                    offset = screenHeight + Constants.Screen.itemSize * 2
                }
            }
    }
}

#Preview {
    NavigationView {
        PlayView()
    }
}
