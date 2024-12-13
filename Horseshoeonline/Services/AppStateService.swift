//
//  AppStateService.swift
//  Horseshoe
//
//  Created by Alex on 06.12.2024.
//

import Foundation
import Combine

final class AppStateService {
    static let shared = AppStateService()
    
    private let storageService: StorageServiceProtocol
    private let userDataSubject = CurrentValueSubject<UserData, Never>(.empty)
    
    var userDataPublisher: AnyPublisher<UserData, Never> {
        userDataSubject.eraseToAnyPublisher()
    }
    
    private init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
        loadUserData()
    }
    
    func loadUserData() {
        if let data = storageService.getUserData() {
            userDataSubject.send(data)
        }
    }
    
    func updateUserData(_ userData: UserData) {
        storageService.saveUserData(userData)
        userDataSubject.send(userData)
    }
    
    func updateResources(horseshoes: Int? = nil, coins: Int? = nil) {
        var updatedUserData = userDataSubject.value
        
        if let horseshoes = horseshoes {
            updatedUserData.horseshoes = horseshoes
        }
        
        if let coins = coins {
            updatedUserData.coins = coins
        }
        
        storageService.saveUserData(updatedUserData)
        userDataSubject.send(updatedUserData)
    }
    
    func addHorseshoes(_ amount: Int) {
        let updatedUserData = UserData(
            username: userDataSubject.value.username,
            horseshoes: userDataSubject.value.horseshoes + amount,
            coins: userDataSubject.value.coins
        )
        updateUserData(updatedUserData)
    }
    
    func addCoins(_ amount: Int) {
        let updatedUserData = UserData(
            username: userDataSubject.value.username,
            horseshoes: userDataSubject.value.horseshoes,
            coins: userDataSubject.value.coins + amount
        )
        updateUserData(updatedUserData)
    }
    
    func spendHorseshoes(_ amount: Int) -> Bool {
        guard userDataSubject.value.horseshoes >= amount else { return false }
        let updatedUserData = UserData(
            username: userDataSubject.value.username,
            horseshoes: userDataSubject.value.horseshoes - amount,
            coins: userDataSubject.value.coins
        )
        updateUserData(updatedUserData)
        return true
    }
    
    func canPlayGetCoinsGame() -> Bool {
        return userDataSubject.value.horseshoes >= Constants.horseshoeCost
    }
}
