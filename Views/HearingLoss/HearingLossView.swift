//
//  HearingLossView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI
import AVFoundation

struct HearingLossView: View {
    @StateObject private var audioSimulator = AudioSimulator()
    @State private var showInfo = false
    @State private var hearingLossLevel: Double = 0.0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ── Header ──────────────────────────────────────────────
                VStack(spacing: Theme.paddingSmall) {
                    Text("Hearing Loss")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)

                    Text(AccessibilityCondition.hearingLoss.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.paddingLarge)
                }
                .padding(.vertical, Theme.paddingLarge)
                .frame(maxWidth: .infinity)

                // ── What this simulates ─────────────────────────────────
                HStack(spacing: 0) {
                    hearingCell(icon: "waveform.path.ecg",               label: "Muffled voice",   color: .blue)
                    Divider().frame(height: 44)
                    hearingCell(icon: "waveform.badge.exclamationmark",   label: "High-freq loss",  color: .orange)
                    Divider().frame(height: 44)
                    hearingCell(icon: "ear.trianglebadge.exclamationmark",label: "Tinnitus",        color: .red)
                }
                .padding(.vertical, 10)
                .background(Color.orange.opacity(0.07))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal, Theme.paddingMedium)

                // ── Hearing Level Slider ─────────────────────────────────
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Hearing Level")
                            .font(Theme.headline)
                        Spacer()
                        Text(hearingLevelText)
                            .font(Theme.caption)
                            .foregroundColor(hearingLevelColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(hearingLevelColor.opacity(0.12))
                            .cornerRadius(10)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.blue)

                        Slider(value: $hearingLossLevel, in: 0...1)
                            .tint(.blue)
                            .accessibilityLabel("Hearing loss level")
                            .accessibilityValue(hearingLevelText)
                            .onChange(of: hearingLossLevel) { newValue in
                                audioSimulator.setHearingLoss(level: newValue)
                            }

                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(.red)
                    }

                    // Severity labels
                    HStack {
                        Text("Normal")
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Severe Loss")
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }

                    // Instruction nudge
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle.fill").foregroundColor(.blue)
                        Text("Drag the slider up → then tap a sound to hear the difference")
                            .font(.system(size: 12)).foregroundColor(.secondary)
                    }
                }
                .padding(Theme.paddingMedium)
                .contentCard()
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.top, Theme.paddingMedium)

                // ── Muffled notice ────────────────────────────────────────
                if hearingLossLevel > 0.3 {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sounds are becoming muffled and indistinct")
                                .font(Theme.body)
                                .fontWeight(.medium)
                            Text("Haptic feedback mirrors the audio intensity")
                                .font(Theme.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(Theme.paddingMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(Theme.buttonCornerRadius)
                    .padding(.horizontal, Theme.paddingMedium)
                    .padding(.top, Theme.paddingMedium)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // ── Audio visualizer ─────────────────────────────────────
                if audioSimulator.isPlaying || hearingLossLevel > 0 {
                    AudioVisualizerView(
                        isPlaying: audioSimulator.isPlaying,
                        volumeLevel: audioSimulator.volumeLevel,
                        hearingLossLevel: hearingLossLevel
                    )
                    .padding(.horizontal, Theme.paddingMedium)
                    .padding(.top, Theme.paddingMedium)
                    .transition(.opacity)
                }

                // ── Audio Scenarios ───────────────────────────────────────
                VStack(spacing: Theme.paddingSmall) {

                    HStack {
                        Text("Audio Scenarios")
                            .font(Theme.headline)
                        Spacer()
                    }
                    .padding(.top, Theme.paddingLarge)
                    .padding(.horizontal, Theme.paddingMedium)

                    Group {
                        AudioScenarioCard(
                            title: "Notification Sound",
                            icon: "bell.fill",
                            description: "A typical phone notification — 1 000 Hz tone",
                            color: .blue,
                            isPlaying: audioSimulator.isPlaying && audioSimulator.currentSound == "notification"
                        ) { audioSimulator.playSound("notification") }

                        AudioScenarioCard(
                            title: "Alarm",
                            icon: "alarm.fill",
                            description: "Morning alarm — 1 200 Hz continuous tone",
                            color: .orange,
                            isPlaying: audioSimulator.isPlaying && audioSimulator.currentSound == "alarm"
                        ) { audioSimulator.playSound("alarm") }

                        AudioScenarioCard(
                            title: "Voice Message",
                            icon: "waveform",
                            description: "Someone speaking — 340 Hz voice range",
                            color: .purple,
                            isPlaying: audioSimulator.isPlaying && audioSimulator.currentSound == "voice"
                        ) { audioSimulator.playSound("voice") }
                    }
                    .padding(.horizontal, Theme.paddingMedium)
                }

                // ── Tip banner ────────────────────────────────────────────
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Drag the slider up and tap a sound. Notice how high-frequency tones disappear first — exactly how real hearing loss progresses.")
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(Theme.paddingMedium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.08))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.top, Theme.paddingSmall)

                // ── Captions Demo ─────────────────────────────────────────
                CaptionDemoView(audioSimulator: audioSimulator)
                    .padding(.top, Theme.paddingLarge)
                    .padding(.horizontal, Theme.paddingMedium)
                    .padding(.bottom, Theme.paddingLarge)
            }
            .animation(.easeInOut(duration: 0.3), value: hearingLossLevel > 0.3)
            .animation(.easeInOut(duration: 0.3), value: audioSimulator.isPlaying)
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
            HearingLossInfoSheet()
        }
        .onDisappear {
            // Stop ALL audio when user navigates away from this screen
            audioSimulator.stopAll()
        }
    }

    private var hearingLevelText: String {
        switch hearingLossLevel {
        case 0..<0.2: return "Normal"
        case 0.2..<0.5: return "Mild Loss"
        case 0.5..<0.8: return "Moderate Loss"
        default: return "Severe Loss"
        }
    }

    private func hearingCell(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }

    private var hearingLevelColor: Color {
        switch hearingLossLevel {
        case 0..<0.2: return .green
        case 0.2..<0.5: return .yellow
        case 0.5..<0.8: return .orange
        default: return .red
        }
    }
}


// MARK: - Audio Scenario Card
struct AudioScenarioCard: View {
    let title: String
    let icon: String
    let description: String
    let color: Color
    let isPlaying: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.paddingMedium) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(isPlaying ? 0.35 : 0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: isPlaying ? "stop.fill" : icon)
                        .font(.title3)
                        .foregroundColor(color)
                }

                // Labels
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Theme.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // State indicator
                if isPlaying {
                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(color)
                                .frame(width: 3, height: CGFloat(8 + i * 5))
                        }
                    }
                } else {
                    Image(systemName: "play.fill")
                        .foregroundColor(color.opacity(0.6))
                }
            }
            .padding(Theme.paddingMedium)
            .frame(maxWidth: .infinity)
            .background(Color(.tertiarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(isPlaying ? color.opacity(0.5) : Color.white.opacity(0.1), lineWidth: isPlaying ? 1.5 : 1)
            )
            .cornerRadius(Theme.cardCornerRadius)
            .shadow(color: isPlaying ? color.opacity(0.2) : Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            .scaleEffect(isPlaying ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPlaying)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Info Sheet
struct HearingLossInfoSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Hearing loss can range from mild to profound and affects how people perceive sounds, speech, and environmental audio cues.")
                        .font(Theme.body)

                    Text(AccessibilityCondition.hearingLoss.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Design Tips")
                        .font(Theme.title2)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        TipRow(icon: "captions.bubble.fill",  text: "Always provide captions for videos and audio")
                        TipRow(icon: "bell.badge.fill",       text: "Use visual and haptic alerts, not just sound")
                        TipRow(icon: "waveform",              text: "Show visual waveforms alongside audio playback")
                        TipRow(icon: "textformat.size",       text: "Offer transcripts for spoken content")
                        TipRow(icon: "hand.wave.fill",        text: "Never rely on sound alone for critical info")
                    }
                }
                .padding()
            }
            .navigationTitle("About Hearing Loss")
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
    NavigationStack { HearingLossView() }
}
