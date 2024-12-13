//
//  LeaderboardEntry.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation

struct LeaderboardEntry: Identifiable, Comparable {
    let id = UUID()
    let username: String
    let coins: Int
    let isCurrentUser: Bool
    
    static func < (lhs: LeaderboardEntry, rhs: LeaderboardEntry) -> Bool {
        return lhs.coins > rhs.coins
    }
}
