//
//  MainMenuViewModel.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import Foundation
import Combine

final class MainMenuViewModel: ObservableObject {
    @Published private(set) var userData: UserData = .empty
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        AppStateService.shared.userDataPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.userData, on: self)
            .store(in: &cancellables)
    }
}
