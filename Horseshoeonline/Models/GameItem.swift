//
//  GameItem.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation

enum GameItemType: String, Codable {
    case horseshoe
    case boots
    case gloves
    case helmet
    case saddle
    case stick
    
    var imageName: ImageResource {
        switch self {
        case .horseshoe: return .horseshoe
        case .boots: return .boots
        case .gloves: return .gloves
        case .helmet: return .helmet
        case .saddle: return .saddle
        case .stick: return .stick
        }
    }
    
    static var randomNonHorseshoe: GameItemType {
        let types: [GameItemType] = [.boots, .gloves, .helmet, .saddle, .stick]
        return types.randomElement() ?? .boots
    }
    
    var isHorseshoe: Bool {
        self == .horseshoe
    }
}

struct GameItem: Identifiable {
    let id = UUID()
    let type: GameItemType
    var position: CGPoint
    var isEnabled: Bool = true
}

enum GameState {
    case initial
    case countdown(Int)
    case playing
    case paused
    case finished(Int)
}
