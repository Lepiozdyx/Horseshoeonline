//
//  GetCoinsViewModel.swift
//  Horseshoe
//
//  Created by Alex on 06.12.2024.
//

import Foundation
import SwiftUI
import Combine

struct CoinItem: Identifiable {
    let id = UUID()
    let position: CGPoint
}

enum GetCoinsGameState {
    case initial
    case playing
    case finished(Int)
}

@MainActor
final class GetCoinsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var coins: [CoinItem] = []
    @Published private(set) var gameState: GetCoinsGameState = .initial
    @Published private(set) var horsePosition: CGFloat = 0
    @Published private(set) var canStartGame = false
    
    private var coinGenerationTimer: AnyCancellable?
    private var horseAnimationTimer: AnyCancellable?
    
    // MARK: - Layout Properties
    private var screenSize: CGSize = .zero
    private var safeAreaInsets: EdgeInsets = .init()
    
    // MARK: - Computed Properties
    private var minX: CGFloat {
        safeAreaInsets.leading + Constants.Screen.itemSize/2
    }
    
    private var maxX: CGFloat {
        screenSize.width - safeAreaInsets.trailing - Constants.Screen.itemSize/2
    }
    
    // MARK: - Initialization
    init() {
        checkCanStartGame()
    }
    
    // MARK: - Public Methods
    func updateLayout(size: CGSize, safeArea: EdgeInsets) {
        screenSize = size
        safeAreaInsets = safeArea
        
        if case .initial = gameState {
            // Start position off screen
            horsePosition = -size.width * 0.1
        }
    }
    
    func startGame() {
        guard canStartGame else { return }
        guard AppStateService.shared.canPlayGetCoinsGame() else { return }
        guard AppStateService.shared.spendHorseshoes(Constants.horseshoeCost) else { return }
        
        checkCanStartGame()
        startHorseAnimation()
        startGeneratingCoins()
        gameState = .playing
    }
    
    func resetGame() {
        coinGenerationTimer?.cancel()
        horseAnimationTimer?.cancel()
        coins.removeAll()
        gameState = .initial
        horsePosition = -screenSize.width * 0.1
        checkCanStartGame()
    }
    
    // MARK: - Private Methods
    private func checkCanStartGame() {
        canStartGame = AppStateService.shared.canPlayGetCoinsGame()
    }
    
    private func startGeneratingCoins() {
        coinGenerationTimer = Timer.publish(
            every: Constants.Game.GetCoins.coinGenerationPeriod,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.generateNewCoin()
        }
    }
    
    private func generateNewCoin() {
        guard coins.count < Constants.Game.GetCoins.maxFallingCoins else { return }
        
        let xPosition = CGFloat.random(in: minX...maxX)
        let coin = CoinItem(
            position: CGPoint(x: xPosition, y: -Constants.Screen.itemSize)
        )
        coins.append(coin)
    }
    
    private func startHorseAnimation() {
        let step = screenSize.width / (Constants.Game.GetCoins.horseDuration * 60) // 60fps
        
        horseAnimationTimer = Timer.publish(every: 1/60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let newPosition = self.horsePosition + step
                if newPosition >= self.screenSize.width * 1.1 {
                    self.finishGame()
                } else {
                    self.horsePosition = newPosition
                }
            }
    }
    
    private func finishGame() {
        coinGenerationTimer?.cancel()
        horseAnimationTimer?.cancel()
        
        let coinsEarned = Int.random(in: Constants.minCoinsReward...Constants.maxCoinsReward)
        AppStateService.shared.addCoins(coinsEarned)
        gameState = .finished(coinsEarned)
    }
}
