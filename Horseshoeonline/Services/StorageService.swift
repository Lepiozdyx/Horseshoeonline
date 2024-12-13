//
//  StorageService.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation

protocol StorageServiceProtocol {
    func saveUserData(_ userData: UserData)
    func getUserData() -> UserData?
}

final class StorageService: StorageServiceProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveUserData(_ userData: UserData) {
        if let data = try? JSONEncoder().encode(userData) {
            userDefaults.set(data, forKey: Constants.storageKey)
        }
    }
    
    func getUserData() -> UserData? {
        guard let data = userDefaults.data(forKey: Constants.storageKey) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(UserData.self, from: data)
    }
}
