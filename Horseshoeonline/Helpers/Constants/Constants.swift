//
//  Constants.swift
//  Horseshoe
//
//  Created by Alex on 03.12.2024.
//

import Foundation

enum Constants {
    enum Game {
        enum Play {
            static let itemFallingDuration: TimeInterval = 2.5
            static let itemGenerationPeriod: TimeInterval = 0.7
            static let maxFallingItems = 43
        }
        
        enum GetCoins {
            static let horseDuration: TimeInterval = 2.5
            static let coinFallingDuration: TimeInterval = 1.3
            static let coinGenerationPeriod: TimeInterval = 0.3
            static let maxFallingCoins = 10
        }
    }
    
    enum Screen {
        static let itemSize: CGFloat = 60
    }
    
    static let gamePlayDuration: TimeInterval = 30 // 30 seconds
    static let penaltyDuration: TimeInterval = 5
    static let horseshoeCost: Int = 10 // 10 points
    static let minCoinsReward: Int = 5
    static let maxCoinsReward: Int = 20
    static let storageKey = "userData"
    static let initial = "https://hsonline.pro/json"
    static let rules = "https://hsonline.pro/rules.html"
}
