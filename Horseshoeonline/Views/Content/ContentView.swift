//
//  ContentView.swift
//  Horseshoe
//
//  Created by Alex on 03.12.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .loading:
                LoadingView()
            case .webView:
                if let url = viewModel.urlManager.provenURL {
                    WebView(url: url, urlManager: viewModel.urlManager)
                } else {
                    WebView(url: URLManager.initialURL, urlManager: viewModel.urlManager)
                }
            case .registration:
                RegistrationView { viewModel.completeRegistration() }
            case .mainMenu:
                MainMenuView()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView()
}
