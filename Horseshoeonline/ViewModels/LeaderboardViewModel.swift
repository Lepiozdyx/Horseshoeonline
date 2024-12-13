//
//  LeaderboardViewModel.swift
//  Horseshoe
//
//  Created by Alex on 06.12.2024.
//

import Foundation
import Combine

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published private(set) var leaderboardEntries: [LeaderboardEntry] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let opponents: [(name: String, coins: Int)] = [
        ("Newbie", 2940),
        ("Oliver18", 2606),
        ("Soph1a", 2370),
        ("JLucas", 2007),
        ("Ava", 1680),
        ("Eth@n", 1408),
        ("Isabella_Cruize", 1130),
        ("Mas0n", 720),
        ("Mia2001", 399)
    ]
    
    init() {
        AppStateService.shared.userDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] userData in
                self?.updateLeaderboard(with: userData)
            }
            .store(in: &cancellables)
    }
    
    private func updateLeaderboard(with userData: UserData) {
        var entries = opponents.map { opponent in
            LeaderboardEntry(
                username: opponent.name,
                coins: opponent.coins,
                isCurrentUser: false
            )
        }
        
        let userEntry = LeaderboardEntry(
            username: "\(userData.username) (YOU)",
            coins: userData.coins,
            isCurrentUser: true
        )
        entries.append(userEntry)
        
        leaderboardEntries = entries.sorted()
    }
}
