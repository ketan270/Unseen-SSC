//
//  AudioVisualizerView.swift
//  Unseen
//
//  Created by Ketan Sharma on 17/01/26.
//

import SwiftUI

struct AudioVisualizerView: View {
    let isPlaying: Bool
    let volumeLevel: Double
    let hearingLossLevel: Double
    
    @State private var animationPhase: Double = 0
    
    var body: some View {
        VStack(spacing: Theme.paddingMedium) {
            // Waveform visualization
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<20, id: \.self) { index in
                    WaveformBar(
                        index: index,
                        isPlaying: isPlaying,
                        volumeLevel: volumeLevel,
                        hearingLossLevel: hearingLossLevel,
                        animationPhase: animationPhase
                    )
                }
            }
            .frame(height: 80)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(Theme.cornerRadius)
            
            // Volume meter
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Volume")
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(volumeLevel * 100))%")
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 8)
                        
                        // Volume bar
                        RoundedRectangle(cornerRadius: 4)
                            .fill(volumeColor)
                            .frame(width: geometry.size.width * volumeLevel, height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal)
        }
        .onAppear {
            if isPlaying {
                startAnimation()
            }
        }
        .onChange(of: isPlaying) { newValue in
            if newValue {
                startAnimation()
            }
        }
    }
    
    private var volumeColor: Color {
        switch volumeLevel {
        case 0..<0.3:
            return .red
        case 0.3..<0.6:
            return .orange
        case 0.6..<0.8:
            return .yellow
        default:
            return .green
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 0.1).repeatForever(autoreverses: false)) {
            animationPhase += 1
        }
    }
}

struct WaveformBar: View {
    let index: Int
    let isPlaying: Bool
    let volumeLevel: Double
    let hearingLossLevel: Double
    let animationPhase: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(barColor)
            .frame(height: barHeight)
            .animation(.easeInOut(duration: 0.3), value: isPlaying)
    }
    
    private var barHeight: CGFloat {
        if !isPlaying {
            return 4
        }
        
        // Simulate frequency spectrum
        let baseHeight = sin(Double(index) * 0.5 + animationPhase * 0.5) * 30 + 40
        let volumeAdjusted = baseHeight * volumeLevel
        
        return max(4, volumeAdjusted)
    }
    
    private var barColor: Color {
        // High frequencies (right side) are more affected by hearing loss
        let frequencyPosition = Double(index) / 20.0
        
        if frequencyPosition > 0.6 && hearingLossLevel > 0.5 {
            return .red.opacity(0.7)
        } else if frequencyPosition > 0.4 && hearingLossLevel > 0.3 {
            return .orange.opacity(0.7)
        } else {
            return .blue.opacity(0.7)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AudioVisualizerView(
            isPlaying: true,
            volumeLevel: 0.7,
            hearingLossLevel: 0.3
        )
        
        AudioVisualizerView(
            isPlaying: false,
            volumeLevel: 0.0,
            hearingLossLevel: 0.0
        )
    }
    .padding()
}
