//
//  RegistrationViewModel.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation

final class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    
    func saveUsername() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedUsername.isEmpty {
            let userData = UserData(
                username: trimmedUsername,
                horseshoes: 0,
                coins: 0
            )
            AppStateService.shared.updateUserData(userData)
        }
    }
}
