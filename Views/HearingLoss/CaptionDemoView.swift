//
//  CaptionDemoView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

// MARK: - Data
struct CaptionLine: Identifiable {
    let id = UUID()
    let speaker: String
    let text: String
    let color: Color
    let icon: String
    let holdSeconds: Double   // how long to display after typing
}

// MARK: - View
struct CaptionDemoView: View {
    /// Passed in from HearingLossView so the conversation audio
    /// uses the same engine/filter that the slider controls.
    let audioSimulator: AudioSimulator

    @State private var showCaptions    = true
    @State private var isPlaying       = false
    @State private var currentIndex    = 0
    @State private var displayedText   = ""
    @State private var typingTask: Task<Void, Never>?
    @State private var progress: Double = 0

    // A 6-line doctor's appointment — each speaker has a distinct pitch
    private let conversation: [CaptionLine] = [
        CaptionLine(speaker: "Doctor",  text: "Good morning! How are you feeling today?",
                    color: .blue,   icon: "stethoscope",    holdSeconds: 1.2),
        CaptionLine(speaker: "Patient", text: "I've had a headache and dizziness since morning.",
                    color: .purple, icon: "person.fill",    holdSeconds: 1.2),
        CaptionLine(speaker: "Doctor",  text: "Any nausea or sensitivity to bright light?",
                    color: .blue,   icon: "stethoscope",    holdSeconds: 1.2),
        CaptionLine(speaker: "Patient", text: "Yes — bright lights make it much worse.",
                    color: .purple, icon: "person.fill",    holdSeconds: 1.2),
        CaptionLine(speaker: "Doctor",  text: "Sounds like a migraine. I'll prescribe relief.",
                    color: .blue,   icon: "stethoscope",    holdSeconds: 1.2),
        CaptionLine(speaker: "Alarm",   text: "⚠️ Medication reminder — take your pill now!",
                    color: .orange, icon: "bell.badge.fill", holdSeconds: 1.5),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {

            // ── Title + CC Toggle ──────────────────────────────────────
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Captions Demo")
                        .font(Theme.headline)
                    Text("Play a real conversation — toggle CC to feel the difference")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
                ccToggleButton
            }

            // ── Status banner ──────────────────────────────────────────
            HStack(spacing: 8) {
                Image(systemName: showCaptions ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(showCaptions ? .green : .orange)
                Text(showCaptions
                     ? "Captions ON — every word is readable"
                     : "Captions OFF — audio is the only channel")
                    .font(Theme.caption)
                    .foregroundColor(showCaptions ? .green : .orange)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background((showCaptions ? Color.green : Color.orange).opacity(0.12))
            .cornerRadius(Theme.buttonCornerRadius)
            .animation(.easeInOut(duration: 0.25), value: showCaptions)

            // ── Conversation screen ────────────────────────────────────
            conversationScreen

            // ── Progress + stop ────────────────────────────────────────
            if isPlaying { progressRow }

            // ── Play button ────────────────────────────────────────────
            if !isPlaying {
                Button(action: startPlayback) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play Conversation")
                    }
                    .primaryButtonStyle()
                }
            }

            // ── Speaker legend (idle only) ─────────────────────────────
            if !isPlaying { speakerLegend }

            // ── Teaching callout ───────────────────────────────────────
            teachingCallout
        }
        .frame(maxWidth: .infinity)
        .onDisappear {
            // Stop TTS and cancel typing when view leaves the screen
            typingTask?.cancel()
            audioSimulator.stopSpeech()
        }
    }

    // MARK: - Sub-views
    private var ccToggleButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.25)) { showCaptions.toggle() }
        }) {
            HStack(spacing: 6) {
                Image(systemName: showCaptions ? "captions.bubble.fill" : "captions.bubble")
                    .font(.system(size: 13, weight: .semibold))
                Text(showCaptions ? "CC On" : "CC Off")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(showCaptions ? .white : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(showCaptions ? Color.blue : Color(.tertiarySystemGroupedBackground))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(showCaptions ? 0 : 0.15), lineWidth: 1)
            )
        }
    }

    private var conversationScreen: some View {
        ZStack(alignment: .bottomLeading) {
            // Black background
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .fill(Color.black)

            // Idle state
            if !isPlaying {
                VStack(spacing: 10) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.35))
                    Text("Tap Play to start")
                        .font(Theme.caption)
                        .foregroundColor(.white.opacity(0.3))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // No-captions mode message
            if !showCaptions && isPlaying {
                VStack(spacing: 10) {
                    Image(systemName: "waveform.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.25))
                    Text("Audio only — no captions")
                        .font(Theme.caption)
                        .foregroundColor(.white.opacity(0.3))
                    Text("Can you follow the conversation?")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.2))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // Caption bubble
            if showCaptions && isPlaying && currentIndex < conversation.count {
                let line = conversation[currentIndex]
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    // Speaker label
                    HStack(spacing: 5) {
                        Image(systemName: line.icon)
                            .font(.system(size: 11, weight: .semibold))
                        Text(line.speaker.uppercased())
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .tracking(1)
                    }
                    .foregroundColor(line.color)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)

                    // Caption text
                    Text(displayedText + (displayedText.count < conversation[currentIndex].text.count ? "▌" : ""))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(line.color.opacity(0.8).cornerRadius(10))
                        .padding(.horizontal, 12)
                        .padding(.bottom, 14)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .transition(.opacity)
                .id(currentIndex)
            }

            // Sound-wave overlay (always visible when playing)
            if isPlaying {
                HStack(spacing: 4) {
                    ForEach(0..<6, id: \.self) { i in
                        SoundWaveBar(index: i, isPlaying: true)
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: .topTrailing)
                .padding(10)
            }
        }
        .frame(height: 240)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
    }

    private var progressRow: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3).fill(Color(.systemGray5)).frame(height: 4)
                    RoundedRectangle(cornerRadius: 3).fill(Color.blue)
                        .frame(width: geo.size.width * progress, height: 4)
                        .animation(.linear(duration: 0.3), value: progress)
                }
            }
            .frame(height: 4)
            HStack {
                Text("Line \(min(currentIndex + 1, conversation.count)) of \(conversation.count)")
                    .font(Theme.caption).foregroundColor(.secondary)
                Spacer()
                Button(action: stopPlayback) {
                    HStack(spacing: 4) {
                        Image(systemName: "stop.fill")
                        Text("Stop")
                    }
                    .font(Theme.caption).foregroundColor(.red)
                }
            }
        }
    }

    private var speakerLegend: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Scene: Doctor's appointment")
                .font(.system(size: 12, weight: .semibold)).foregroundColor(.secondary)
            HStack(spacing: 18) {
                ForEach([
                    ("stethoscope", "Doctor",  Color.blue),
                    ("person.fill", "Patient", Color.purple),
                    ("bell.badge.fill", "Alarm", Color.orange)
                ], id: \.1) { icon, name, color in
                    HStack(spacing: 4) {
                        Image(systemName: icon).font(.system(size: 11)).foregroundColor(color)
                        Text(name).font(.system(size: 12)).foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private var teachingCallout: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill").foregroundColor(.yellow)
                Text("Try it yourself").font(.system(size: 13, weight: .semibold))
            }
            Text("Drag the hearing level slider up THEN press Play. The speech formants — consonants first, then vowels — disappear as loss increases. Toggle CC Off to also remove the safety net of captions. This is everyday life for 466 million people.")
                .font(Theme.caption).foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(0.08))
        .cornerRadius(Theme.buttonCornerRadius)
    }

    // MARK: - Playback Logic
    private func startPlayback() {
        isPlaying     = true
        currentIndex  = 0
        progress      = 0
        displayedText = ""
        playLine(at: 0)
    }

    private func stopPlayback() {
        typingTask?.cancel(); typingTask = nil
        audioSimulator.stopSpeech()          // stop TTS
        isPlaying     = false
        displayedText = ""
        currentIndex  = 0
        progress      = 0
    }

    private func playLine(at index: Int) {
        guard index < conversation.count else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { stopPlayback() }
            return
        }

        currentIndex  = index
        displayedText = ""
        progress      = Double(index) / Double(conversation.count)

        let line = conversation[index]

        // 🔊 Speak the actual caption text aloud (offline TTS)
        audioSimulator.speakCaption(line.text, speaker: line.speaker)

        typingTask = Task {
            // Type each character at ~40 ms
            for char in line.text {
                try? await Task.sleep(nanoseconds: 40_000_000)
                guard !Task.isCancelled else { return }
                await MainActor.run { displayedText.append(char) }
            }

            // Hold the completed caption, then move on
            try? await Task.sleep(nanoseconds: UInt64(line.holdSeconds * 1_000_000_000))
            guard !Task.isCancelled else { return }

            await MainActor.run {
                audioSimulator.stopSpeech()           // stop current speaker
                withAnimation(.easeInOut(duration: 0.2)) {
                    playLine(at: index + 1)
                }
            }
        }
    }
}

// MARK: - Sound Wave Bar
private struct SoundWaveBar: View {
    let index: Int
    let isPlaying: Bool
    @State private var height: CGFloat = 4

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.white.opacity(0.6))
            .frame(width: 3, height: height)
            .onAppear { animate() }
    }

    private func animate() {
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 0.3...0.6))
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.1)
        ) {
            height = CGFloat.random(in: 6...22)
        }
    }
}

#Preview {
    ScrollView {
        CaptionDemoView(audioSimulator: AudioSimulator())
            .padding()
    }
}
