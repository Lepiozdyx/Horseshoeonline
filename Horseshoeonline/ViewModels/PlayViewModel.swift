//
//  PlayViewModel.swift
//  Horseshoe
//
//  Created by Alex on 05.12.2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class PlayViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var items: [GameItem] = []
    @Published private(set) var gameState: GameState = .initial
    @Published private(set) var timeRemaining: TimeInterval = Constants.gamePlayDuration
    @Published private(set) var isPenalty = false
    @Published private(set) var score = 0
    
    // MARK: - Private Properties
    private let gameStateService: GameStateServiceProtocol
    private var penaltyTimer: AnyCancellable?
    private var itemGenerationTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
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
    init(gameStateService: GameStateServiceProtocol = GameStateService()) {
        self.gameStateService = gameStateService
        setupSubscriptions()
    }
    
    // MARK: - Public Methods
    func updateLayout(size: CGSize, safeArea: EdgeInsets) {
        screenSize = size
        safeAreaInsets = safeArea
    }
    
    func startGame() {
        gameStateService.startGame()
    }
    
    func resetGame() {
        gameStateService.resetGame()
        items.removeAll()
        score = 0
        isPenalty = false
        penaltyTimer?.cancel()
        itemGenerationTimer?.cancel()
    }
    
    func tapItem(_ item: GameItem) {
        guard case .playing = gameState,
              !isPenalty,
              item.isEnabled else { return }
        
        if item.type.isHorseshoe {
            score += 1
            updateUserData()
        } else {
            activatePenalty()
        }
        
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isEnabled = false
        }
    }
    
    // MARK: - Private Methods
    private func setupSubscriptions() {
        gameStateService.gameState
            .sink { [weak self] state in
                self?.gameState = state
                if case .playing = state {
                    self?.startGeneratingItems()
                }
            }
            .store(in: &cancellables)
        
        gameStateService.timer
            .sink { [weak self] time in
                self?.timeRemaining = Constants.gamePlayDuration - time
            }
            .store(in: &cancellables)
    }
    
    private func startGeneratingItems() {
        itemGenerationTimer = Timer.publish(
            every: Constants.Game.Play.itemGenerationPeriod,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.generateNewItem()
        }
    }
    
    private func generateNewItem() {
        guard items.count < Constants.Game.Play.maxFallingItems else { return }
        
        // Determine item type with 20% chance for horseshoe
        let itemType: GameItemType = Int.random(in: 1...5) == 1
            ? .horseshoe
            : GameItemType.randomNonHorseshoe
        
        // Calculate random X position within safe area
        let xPosition = CGFloat.random(in: minX...maxX)
        
        let item = GameItem(
            type: itemType,
            position: CGPoint(x: xPosition, y: -Constants.Screen.itemSize)
        )
        items.append(item)
    }
    
    private func activatePenalty() {
        isPenalty = true
        penaltyTimer = Timer.publish(every: Constants.penaltyDuration, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                self?.isPenalty = false
            }
    }
    
    private func updateUserData() {
        AppStateService.shared.addHorseshoes(1)
    }
}
