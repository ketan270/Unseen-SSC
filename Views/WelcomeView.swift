//
//  WelcomeView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct WelcomeView: View {
    let onStart: () -> Void

    // Experience data to show in the 4-card strip
    private let experiences: [(name: String, icon: String, colors: [Color], blurb: String)] = [
        ("Color Blindness",   "eye.fill",          [.purple, .blue],   "See through different eyes"),
        ("Vision Impairment", "eyeglasses",        [.indigo, .teal],   "Blur, distortion & blind spots"),
        ("Hearing Loss",      "ear.fill",          [.orange, .pink],   "Muffled sounds & high-freq loss"),
        ("Limited Mobility",  "hand.raised.fill",  [.green,  .cyan],   "Tremors & precise-tap challenges"),
    ]

    @State private var appeared = false

    var body: some View {
        ZStack {
            // ── Background ──────────────────────────────────────────────
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.04, blue: 0.16),
                         Color(red: 0.03, green: 0.03, blue: 0.09)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Subtle decorative blob
            Circle()
                .fill(Color.purple.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(x: -60, y: -200)

            VStack(spacing: 0) {

                // ── Hero ────────────────────────────────────────────────
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.06))
                            .frame(width: 120, height: 120)
                        Circle()
                            .fill(Color.white.opacity(0.04))
                            .frame(width: 84, height: 84)
                        Image(systemName: "eyes")
                            .font(.system(size: 42, weight: .light))
                            .foregroundColor(.white)
                    }

                    Text("Unseen")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Step into worlds you've never experienced")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 60)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : -20)
                .animation(.easeOut(duration: 0.6), value: appeared)

                // ── 4 Experience cards ───────────────────────────────────
                VStack(spacing: 12) {
                    Text("4 Interactive Experiences")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top, 36)

                    ForEach(experiences.indices, id: \.self) { i in
                        let exp = experiences[i]
                        HStack(spacing: 14) {
                            // Gradient icon badge
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: exp.colors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                Image(systemName: exp.icon)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(exp.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(exp.blurb)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.5))
                            }

                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(16)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 30)
                        .animation(
                            .easeOut(duration: 0.5).delay(0.15 + Double(i) * 0.08),
                            value: appeared
                        )
                    }
                }
                .padding(.horizontal, 28)

                Spacer(minLength: 32)

                // ── CTA ──────────────────────────────────────────────────
                Button(action: onStart) {
                    HStack(spacing: 10) {
                        Text("Begin Exploring")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .white.opacity(0.2), radius: 16)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.6), value: appeared)
            }
        }
        .onAppear { appeared = true }
    }
}

#Preview {
    WelcomeView(onStart: {})
}
