//
//  ContentViewModel.swift
//  Horseshoe
//
//  Created by Alex on 05.12.2024.
//

import Foundation

enum AppState {
    case loading
    case webView
    case registration
    case mainMenu
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published private(set) var appState: AppState = .loading
    
    private let storageService: StorageServiceProtocol
    let urlManager: URLManager
    
    init(
        storageService: StorageServiceProtocol = StorageService(),
        urlManager: URLManager = URLManager()
    ) {
        self.storageService = storageService
        self.urlManager = urlManager
    }
    
    func onAppear() {
        Task {            
            if urlManager.provenURL != nil {
                appState = .webView
                return
            }
            
            do {
                if try await urlManager.checkInitialURL() {
                    appState = .webView
                } else {
                    determineInitialState()
                }
            } catch {
                determineInitialState()
            }
        }
    }
    
    private func determineInitialState() {
        if let userData = storageService.getUserData(),
           !userData.username.isEmpty {
            appState = .mainMenu
        } else {
            appState = .registration
        }
    }
    
    func completeRegistration() {
        appState = .mainMenu
    }
}
