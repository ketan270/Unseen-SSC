//
//  AudioSimulator.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import Foundation
import AVFoundation
import Combine
import UIKit

@MainActor
class AudioSimulator: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isPlaying = false
    @Published var currentSound: String?
    @Published var volumeLevel: Double = 0.0

    // Two players share one pre-mixer → one low-pass filter
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?         // scenario sounds
    private var convoPlayerNode: AVAudioPlayerNode?    // looping beep (alarm)
    private var lowPassFilter: AVAudioUnitEQ?

    /// Speaks the actual caption text aloud — offline, built-in iOS TTS
    private let speechSynth = AVSpeechSynthesizer()

    private var hearingLossLevel: Double = 0.0
    private var hapticTask: Task<Void, Never>?
    private var volumeTask: Task<Void, Never>?
    private var hapticElapsed: TimeInterval = 0
    private var volumeStep: Int = 0

    // Fixed 44 100 Hz mono format used everywhere
    private static let sampleRate: Double = 44_100
    private static let audioFormat = AVAudioFormat(
        standardFormatWithSampleRate: sampleRate, channels: 1)!

    override init() {
        super.init()
        setupAudioSession()
        setupAudioEngine()
    }

    // MARK: - Session ----------------------------------------------------------------
    private func setupAudioSession() {
        do {
            let s = AVAudioSession.sharedInstance()
            try s.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try s.setActive(true)
        } catch {}
    }

    // MARK: - Engine -----------------------------------------------------------------
    private func setupAudioEngine() {
        let engine     = AVAudioEngine()
        let player     = AVAudioPlayerNode()
        let convo      = AVAudioPlayerNode()
        let preMix     = AVAudioMixerNode()           // combines both players
        let filter     = AVAudioUnitEQ(numberOfBands: 1)

        for node in [player, convo, preMix, filter] as [AVAudioNode] {
            engine.attach(node)
        }

        // Both players → preMixer → lowPassFilter → mainMixer → output
        let fmt = AudioSimulator.audioFormat
        engine.connect(player, to: preMix,  format: fmt)
        engine.connect(convo,  to: preMix,  format: fmt)
        engine.connect(preMix, to: filter,  format: fmt)
        engine.connect(filter, to: engine.mainMixerNode, format: fmt)

        // Start filter fully open
        let band = filter.bands[0]
        band.filterType = .lowPass
        band.frequency  = 20_000
        band.bypass     = false

        do {
            try engine.start()
            self.audioEngine     = engine
            self.playerNode      = player
            self.convoPlayerNode = convo
            self.lowPassFilter   = filter
        } catch {}
    }

    // MARK: - Hearing Loss -----------------------------------------------------------
    /// Exponential cutoff: real hearing loss hits high frequencies dramatically.
    /// level=0   → 20 000 Hz (no effect)
    /// level=0.3 → ~3 700 Hz (consonants lost)
    /// level=0.5 → ~1 400 Hz (speech very muffled)
    /// level=0.8 → ~  320 Hz (only low rumble remains)
    func setHearingLoss(level: Double) {
        hearingLossLevel = level
        guard let filter = lowPassFilter else { return }

        let cutoff: Float
        if level < 0.01 {
            cutoff = 20_000
        } else {
            // 20000 * 0.04^level  — exponential drop
            cutoff = Float(20_000 * pow(0.04, level))
        }
        filter.bands[0].frequency = max(150, cutoff)

        // Volume also drops (but less than filter — both effects combine)
        let vol = Float(max(0, 1.0 - 0.75 * level))
        audioEngine?.mainMixerNode.outputVolume = vol
    }

    // MARK: - Scenario Playback -----------------------------------------------------
    func playSound(_ soundName: String) {
        if isPlaying { stopPlayback(); return }
        playTone(for: soundName)
    }

    private func playTone(for soundName: String) {
        guard let player = playerNode,
              let engine = audioEngine, engine.isRunning else {
            setupAudioSession(); setupAudioEngine(); return
        }

        let (frequency, duration): (Float, TimeInterval) = switch soundName {
            case "notification": (1_000, 0.6)
            case "alarm":        (1_200, 1.4)
            case "voice":        (0,     2.2)   // 0 = use speech formants
            default:             (440,   0.8)
        }

        let buffer: AVAudioPCMBuffer?
        if soundName == "voice" {
            buffer = generateSpeechBuffer(duration: duration, speakerHz: 200)
        } else {
            buffer = generateTone(frequency: frequency, duration: duration)
        }
        guard let buf = buffer else { return }

        currentSound = soundName
        isPlaying    = true
        volumeLevel  = 1.0

        startHapticFeedback(duration: duration)
        startVolumeAnimation(duration: duration)

        player.scheduleBuffer(buf, at: nil,
                              completionCallbackType: .dataPlayedBack) { [weak self] _ in
            DispatchQueue.main.async { self?.stopPlayback() }
        }
        player.play()
    }

    // MARK: - Caption Speech (AVSpeechSynthesizer — offline, built-in TTS) ----------

    /// Speaks the given text using the device's built-in TTS.
    ///
    /// Volume uses an exponential dB curve matching audiological hearing loss:
    ///   level 0.00 (normal)   → vol 1.00, rate 0.50
    ///   level 0.25 (mild)     → vol 0.55, rate 0.44  — soft consonants harder
    ///   level 0.50 (moderate) → vol 0.22, rate 0.38  — clearly quieter, harder to parse
    ///   level 0.75 (severe)   → vol 0.06, rate 0.31  — barely audible
    ///   level 1.00 (profound) → vol 0.02, rate 0.25  — essentially inaudible
    func speakCaption(_ text: String, speaker: String) {
        if speechSynth.isSpeaking { speechSynth.stopSpeaking(at: .immediate) }
        let utterance = AVSpeechUtterance(string: text)
        utterance.pitchMultiplier = pitchFor(speaker: speaker)
        // Exponential volume: 10^(-3.5 * level) → 1.0 at 0, 0.22 at 0.5, 0.02 at 1.0
        utterance.volume = Float(max(0.02, pow(10.0, -3.5 * hearingLossLevel)))
        // Rate slows with loss — impaired listeners need slower speech to parse words
        utterance.rate = Float(max(0.25, 0.50 - 0.25 * hearingLossLevel))
        speechSynth.speak(utterance)
    }

    func stopSpeech() {
        speechSynth.stopSpeaking(at: .immediate)
    }

    /// Stops ALL audio — engine sounds + TTS. Call from onDisappear.
    func stopAll() {
        stopPlayback()
        stopSpeech()
        convoPlayerNode?.stop()
    }

    private func pitchFor(speaker: String) -> Float {
        switch speaker {
        case "Doctor":  return 0.82
        case "Patient": return 1.18
        case "Alarm":   return 1.50
        default:        return 1.00
        }
    }

    // MARK: - Alarm loop (used only for looping alarm beep if needed) ---------------
    func startAlarmLoop() {
        guard let convo = convoPlayerNode,
              let engine = audioEngine, engine.isRunning else { return }
        convo.stop()
        if let buf = generateTone(frequency: 900, duration: 0.5) {
            convo.scheduleBuffer(buf, at: nil, options: .loops)
            convo.play()
        }
    }

    func stopAlarmLoop() { convoPlayerNode?.stop() }

    // MARK: - Tone Generation -------------------------------------------------------

    /// Simple single-frequency sine tone with fade envelope.
    private func generateTone(frequency: Float, duration: TimeInterval) -> AVAudioPCMBuffer? {
        let sr          = Float(AudioSimulator.sampleRate)
        let frameCount  = AVAudioFrameCount(sr * Float(duration))
        guard let buf   = AVAudioPCMBuffer(pcmFormat: AudioSimulator.audioFormat,
                                           frameCapacity: frameCount) else { return nil }
        buf.frameLength = frameCount
        guard let data  = buf.floatChannelData?[0] else { return nil }

        let fade = Int(sr * 0.02)  // 20 ms
        for f in 0..<Int(frameCount) {
            let t      = Float(f) / sr
            let sample = sin(2 * .pi * frequency * t)
                       + sin(2 * .pi * frequency * 2 * t) * 0.25
            let fadeIn  = f < fade ? Float(f) / Float(fade) : 1.0
            let fadeOut = f > Int(frameCount) - fade
                       ? Float(Int(frameCount) - f) / Float(fade) : 1.0
            data[f] = sample * 0.35 * fadeIn * fadeOut
        }
        return buf
    }

    /// Speech-like buffer with multiple formants — demonstrates hearing loss clearly.
    ///
    /// Formant stack (energy at these frequencies):
    ///   F0  = speakerHz          (fundamental pitch — survives all but most severe loss)
    ///   F1  ~ speakerHz * 3      (~vowel body)
    ///   F2  = 1 800 Hz           (vowel colour — lost at moderate loss ~0.5)
    ///   F3  = 2 800 Hz           (clarity — lost at mild-moderate ~0.35)
    ///   F4  = 4 500 Hz           (consonant cues — lost first, even at ~0.25)
    ///   F5  = 6 500 Hz           (sibilants: s, sh — very first to go)
    ///
    /// This means at increasing hearing loss levels the user literally HEARS
    /// the consonants disappear, then vowel quality, then just a muddy rumble.
    private func generateSpeechBuffer(duration: TimeInterval,
                                      speakerHz: Float) -> AVAudioPCMBuffer? {
        let sr         = Float(AudioSimulator.sampleRate)
        let frameCount = AVAudioFrameCount(sr * Float(duration))
        guard let buf  = AVAudioPCMBuffer(pcmFormat: AudioSimulator.audioFormat,
                                          frameCapacity: frameCount) else { return nil }
        buf.frameLength = frameCount
        guard let data  = buf.floatChannelData?[0] else { return nil }

        // (frequency Hz, relative amplitude)
        let formants: [(Float, Float)] = [
            (speakerHz,         0.40),
            (speakerHz * 3.0,   0.22),
            (1_800,             0.18),
            (2_800,             0.12),
            (4_500,             0.07),
            (6_500,             0.04),
        ]

        let fade = Int(sr * 0.02)
        for f in 0..<Int(frameCount) {
            let t = Float(f) / sr

            // Speech amplitude modulation ~5 Hz (syllable rhythm)
            let syllable = (sin(2 * .pi * 5.0 * t) * 0.3 + 0.7)

            var sample: Float = 0
            for (freq, amp) in formants {
                sample += sin(2 * .pi * freq * t) * amp
            }

            let fadeIn  = f < fade ? Float(f) / Float(fade) : 1.0
            let fadeOut = f > Int(frameCount) - fade
                       ? Float(Int(frameCount) - f) / Float(fade) : 1.0
            data[f] = sample * syllable * fadeIn * fadeOut * 0.25
        }
        return buf
    }

    // MARK: - Haptic + Volume Anim --------------------------------------------------
    private func startHapticFeedback(duration: TimeInterval) {
        let gen = UIImpactFeedbackGenerator(style: .medium)
        gen.prepare()
        let level = hearingLossLevel
        gen.impactOccurred(intensity: CGFloat(max(0.1, 1.0 - level)))

        hapticElapsed = 0
        let interval = 0.25
        hapticTask?.cancel()
        hapticTask = Task { @MainActor in
            for _ in 0..<(Int(duration / interval) + 1) {
                if Task.isCancelled { break }
                hapticElapsed += interval
                if hapticElapsed >= duration { break }
                gen.impactOccurred(intensity: CGFloat(max(0, 0.5 * (1 - hearingLossLevel))))
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
            hapticTask = nil
        }
    }

    private func startVolumeAnimation(duration: TimeInterval) {
        volumeLevel = 1.0
        volumeStep = 0
        let steps    = 20
        let interval = duration / Double(steps)
        volumeTask?.cancel()
        volumeTask = Task { @MainActor in
            for _ in 0..<steps {
                if Task.isCancelled { break }
                volumeStep += 1
                if volumeStep >= steps {
                    volumeLevel = 0
                    break
                }
                volumeLevel = 1.0 - Double(volumeStep) / Double(steps)
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
            volumeTask = nil
        }
    }

    // MARK: - Stop ------------------------------------------------------------------
    func stopPlayback() {
        playerNode?.stop()
        hapticTask?.cancel()
        hapticTask = nil
        volumeTask?.cancel()
        volumeTask = nil
        isPlaying    = false
        currentSound = nil
        volumeLevel  = 0
    }
}
