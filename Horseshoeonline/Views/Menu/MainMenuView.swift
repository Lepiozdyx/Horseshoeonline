//
//  MainMenuView.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var vm = MainMenuViewModel()
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isPortrait: Bool { verticalSizeClass == .regular }
    var isIPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                MainBackgroundView()
                
                // Header
                MainMenuHeader(userData: vm.userData)
                
                VStack(spacing: 40) {
                    Spacer()
                    Spacer()
                    HStack(spacing: 20) {
                        NavigationLink {
                             PlayView()
                        } label: {
                            UnderlayView(
                                text: "PLAY",
                                fontSize: 30,
                                fontColor: .customRed,
                                width: 300,
                                height: 72
                            )
                        }
                        
                        NavigationLink {
                             GetCoinsView()
                        } label: {
                            UnderlayView(
                                text: "GET COINS",
                                fontSize: 30,
                                fontColor: .customRed,
                                width: 300,
                                height: 72
                            )
                        }
                    }
                    
                    HStack(spacing: 20) {
                        NavigationLink {
                             RulesView()
                        } label: {
                            UnderlayView(
                                text: "RULES",
                                fontSize: 30,
                                fontColor: .customRed,
                                width: 300,
                                height: 72
                            )
                        }
                        
                        NavigationLink {
                             LeaderboardView()
                        } label: {
                            UnderlayView(
                                text: "LEADERBOARD",
                                fontSize: 30,
                                fontColor: .customRed,
                                width: 300,
                                height: 72
                            )
                        }
                    }
                    Spacer()
                    
                    if isPortrait && isIPhone {
                        Text("*Use landscape orientation for the game")
                            .hsfont(.customMilk, 16)
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    MainMenuView()
}

struct MainMenuHeader: View {
    let userData: UserData
    
    var body: some View {
        HStack {
            // horseshoe counter
            CounterElementView(image: .horseshoe, text: "\(userData.horseshoes)")
            
            Spacer()
            // Player's name
            UnderlayView(
                text: userData.username,
                fontSize: 20,
                fontColor: .customRed,
                width: 230,
                height: 44
            )
            
            Spacer()
            // coins counter
            CounterElementView(image: .coin, text: "\(userData.coins)")
        }
        .padding()
    }
}
