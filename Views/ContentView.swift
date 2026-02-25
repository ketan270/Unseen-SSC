//
//  ContentView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ContentView: View {
    // Shows welcome on EVERY launch (not persisted)
    @State private var showWelcome = true

    var body: some View {
        if showWelcome {
            WelcomeView {
                withAnimation(.easeInOut(duration: 0.45)) {
                    showWelcome = false
                }
            }
        } else {
            ConditionSelectorView(showWelcome: $showWelcome)
        }
    }
}

#Preview {
    ContentView()
}
