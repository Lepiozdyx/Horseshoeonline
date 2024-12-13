//
//  RulesView.swift
//  Horseshoe
//
//  Created by Alex on 12.12.2024.
//

import SwiftUI

struct RulesView: View {
    @StateObject private var urlManager = URLManager()
    
    var body: some View {
        WebView(url: URLManager.rulesURL, urlManager: urlManager)
    }
}

#Preview {
    RulesView()
}
