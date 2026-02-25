//
//  ConditionSelectorView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ConditionSelectorView: View {
    @Binding var showWelcome: Bool
    @State private var showInfo = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.paddingLarge) {
                    // Header
                    VStack(spacing: Theme.paddingSmall) {
                        Text("Choose an\nExperience")
                            .font(Theme.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Discover how others experience the world")
                            .font(Theme.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, Theme.paddingLarge)
                    
                    // Experience cards
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: Theme.paddingMedium) {
                        ForEach(AccessibilityCondition.allCases) { condition in
                            NavigationLink(destination: destinationView(for: condition)) {
                                ExperienceCard(condition: condition) {}
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, Theme.paddingMedium)
                    
                    // Footer note
                    Text("Tap a card to begin exploring")
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, Theme.paddingLarge)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            showWelcome = true
                        }
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showInfo = true }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            InfoSheetView()
        }
    }
    
    @ViewBuilder
    private func destinationView(for condition: AccessibilityCondition) -> some View {
        switch condition {
        case .colorBlindness:
            ColorBlindnessView()
        case .visionImpairment:
            VisionImpairmentView()
        case .hearingLoss:
            HearingLossView()
        case .limitedMobility:
            LimitedMobilityView()
        }
    }
}

#Preview {
    ConditionSelectorView(showWelcome: .constant(false))
}
