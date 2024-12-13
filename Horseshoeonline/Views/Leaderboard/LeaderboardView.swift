//
//  LeaderboardView.swift
//  Horseshoe
//
//  Created by Alex on 06.12.2024.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LeaderboardViewModel()
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        BackView()
                    }
                    Spacer()
                }
                .padding()
                
                UnderlayView(
                    text: "",
                    fontSize: 0,
                    fontColor: .customRed,
                    width: .infinity,
                    height: .infinity
                )
                .overlay(alignment: .top) {
                    UnderlayView(
                        text: "LEADERBOARD",
                        fontSize: 30,
                        fontColor: .customRed,
                        width: 300,
                        height: 54
                    )
                    .offset(y: -45)
                }
                .overlay {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(Array(viewModel.leaderboardEntries.enumerated()), id: \.element.id) { index, entry in
                                LeaderboardEntryView(
                                    position: index + 1,
                                    entry: entry
                                )
                            }
                        }
                        .padding(20)
                    }
                    .padding(.top, 10)
                }
                .padding(.top)
                .padding(20)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LeaderboardEntryView: View {
    let position: Int
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack {
            Text("\(position). \(entry.username)")
                .hsfont(entry.isCurrentUser ? .customRed : .customMilk, 20)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(entry.coins)")
                .hsfont(entry.isCurrentUser ? .customRed : .customMilk, 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.black.opacity(0.5))
        )
    }
}

#Preview {
    NavigationView {
        LeaderboardView()
    }
}
