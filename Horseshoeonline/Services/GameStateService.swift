//
//  GameStateService.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation
import Combine

protocol GameStateServiceProtocol {
    var gameState: CurrentValueSubject<GameState, Never> { get }
    var timer: CurrentValueSubject<TimeInterval, Never> { get }
    
    func startGame()
    func pauseGame()
    func resumeGame()
    func endGame(withScore score: Int)
    func resetGame()
}

final class GameStateService: GameStateServiceProtocol {
    let gameState = CurrentValueSubject<GameState, Never>(.initial)
    let timer = CurrentValueSubject<TimeInterval, Never>(0)
    
    private var timerCancellable: AnyCancellable?
    private var countdownCancellable: AnyCancellable?
    
    func startGame() {
        resetGame()
        startCountdown()
    }
    
    func pauseGame() {
        timerCancellable?.cancel()
        gameState.send(.paused)
    }
    
    func resumeGame() {
        guard case .paused = gameState.value else { return }
        startGameTimer()
    }
    
    func endGame(withScore score: Int) {
        timerCancellable?.cancel()
        gameState.send(.finished(score))
    }
    
    func resetGame() {
        timerCancellable?.cancel()
        countdownCancellable?.cancel()
        timer.send(0)
        gameState.send(.initial)
    }
    
    private func startCountdown() {
        var countdown = 3
        gameState.send(.countdown(countdown))
        
        countdownCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                countdown -= 1
                if countdown > 0 {
                    self?.gameState.send(.countdown(countdown))
                } else {
                    self?.countdownCancellable?.cancel()
                    self?.startGameTimer()
                }
            }
    }
    
    private func startGameTimer() {
        gameState.send(.playing)
        
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let newTime = self.timer.value + 0.1
                
                if newTime >= Constants.gamePlayDuration {
                    // Score should be passed from outside
                    self.endGame(withScore: 0)
                } else {
                    self.timer.send(newTime)
                }
            }
    }
}
