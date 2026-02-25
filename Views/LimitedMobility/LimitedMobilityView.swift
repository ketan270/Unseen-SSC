//
//  LimitedMobilityView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct LimitedMobilityView: View {
    @State private var difficultyLevel: Double = 0.0
    @State private var showInfo = false
    @State private var taskResetID = UUID()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ── Header ───────────────────────────────────────────────
                VStack(spacing: Theme.paddingSmall) {
                    Text("Limited Mobility")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)

                    Text(AccessibilityCondition.limitedMobility.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.paddingLarge)
                }
                .padding(.vertical, Theme.paddingLarge)
                .frame(maxWidth: .infinity)

                // ── What this simulates ────────────────────────────────
                HStack(spacing: 12) {
                    VStack(spacing: 6) {
                        Image(systemName: "hand.raised.slash")
                            .font(.system(size: 28))
                            .foregroundColor(.purple)
                        Text("Tremors")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 6) {
                        Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                            .font(.system(size: 28))
                            .foregroundColor(.purple)
                        Text("Stiffness")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 6) {
                        Image(systemName: "target")
                            .font(.system(size: 28))
                            .foregroundColor(.purple)
                        Text("Miss-taps")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(Theme.paddingMedium)
                .background(Color.purple.opacity(0.07))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal, Theme.paddingMedium)

                // ── Difficulty slider ──────────────────────────────────
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Motor Difficulty")
                            .font(Theme.headline)
                        Spacer()
                        Text(difficultyText)
                            .font(Theme.caption)
                            .foregroundColor(difficultyColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(difficultyColor.opacity(0.12))
                            .cornerRadius(10)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "hand.raised.fill").foregroundColor(.green)
                        Slider(value: $difficultyLevel, in: 0...1) { editing in
                            // Reset all tasks the moment the user releases the slider
                            if !editing {
                                taskResetID = UUID()
                            }
                        }
                        .tint(.purple)
                        .accessibilityLabel("Motor difficulty level")
                        .accessibilityValue(difficultyText)
                        Image(systemName: "hand.raised.slash.fill").foregroundColor(.red)
                    }

                    HStack {
                        Text("No tremor").font(Theme.caption).foregroundColor(.secondary)
                        Spacer()
                        Text("Severe tremor").font(Theme.caption).foregroundColor(.secondary)
                    }

                    // Short instruction nudge
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.purple)
                        Text("Drag the slider → then try the interactive tasks below")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(Theme.paddingMedium)
                .contentCard()
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.top, Theme.paddingMedium)

                // ── Info card (appears at moderate+ difficulty) ────────
                if difficultyLevel > 0.3 {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "hand.raised.slash.fill")
                            .foregroundColor(.purple)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(difficultyText) — \(difficultyDescription)")
                                .font(Theme.body).fontWeight(.medium)
                            Text("Notice how every small interaction becomes a challenge")
                                .font(Theme.caption).foregroundColor(.secondary)
                        }
                    }
                    .padding(Theme.paddingMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.purple.opacity(0.08))
                    .cornerRadius(Theme.buttonCornerRadius)
                    .padding(.horizontal, Theme.paddingMedium)
                    .padding(.top, Theme.paddingSmall)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // ── Tasks ──────────────────────────────────────────────
                InteractionTasksView(difficultyLevel: difficultyLevel)
                    .id(taskResetID)
                    .padding(.horizontal, Theme.paddingMedium)
                    .padding(.top, Theme.paddingLarge)
                    .padding(.bottom, Theme.paddingLarge)
            }
            .animation(.easeInOut(duration: 0.3), value: difficultyLevel > 0.3)
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            LimitedMobilityInfoSheet()
        }
    }
    
    private var difficultyText: String {
        switch difficultyLevel {
        case 0..<0.2: return "Normal"
        case 0.2..<0.5: return "Mild"
        case 0.5..<0.8: return "Moderate"
        default: return "Severe"
        }
    }

    private var difficultyColor: Color {
        switch difficultyLevel {
        case 0..<0.2: return .green
        case 0.2..<0.5: return .yellow
        case 0.5..<0.8: return .orange
        default: return .red
        }
    }

    private var difficultyDescription: String {
        switch difficultyLevel {
        case 0.2..<0.5: return "slight hand tremor, like early Parkinson's"
        case 0.5..<0.8: return "strong tremor, like moderate arthritis"
        default: return "severe tremor, requires assistive technology"
        }
    }
}


// MARK: - Info Sheet
struct LimitedMobilityInfoSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Limited mobility can affect fine motor control, making precise touch interactions very challenging. Conditions include arthritis, Parkinson's disease, stroke, cerebral palsy, and many others.")
                        .font(Theme.body)

                    Text(AccessibilityCondition.limitedMobility.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Design Tips")
                        .font(Theme.title2).fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        TipRow(icon: "largecircle.fill.circle",  text: "Touch targets must be at least 44×44 pt")
                        TipRow(icon: "arrow.left.and.right",     text: "Space out interactive elements generously")
                        TipRow(icon: "mic.fill",                 text: "Support Voice Control and Switch Control")
                        TipRow(icon: "clock.arrow.circlepath",   text: "Never use time-pressured interactions")
                        TipRow(icon: "arrow.uturn.backward",     text: "Allow undo for any destructive action")
                    }
                }
                .padding()
            }
            .navigationTitle("About Limited Mobility")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack { LimitedMobilityView() }
}
