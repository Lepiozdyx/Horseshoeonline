//
//  UserData.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation

struct UserData: Codable {
    var username: String
    var horseshoes: Int
    var coins: Int
    
    static let empty = UserData(username: "", horseshoes: 0, coins: 0)
}
