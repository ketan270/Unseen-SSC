//
//  InteractionTasksView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

// MARK: - Container
struct InteractionTasksView: View {
    let difficultyLevel: Double

    var body: some View {
        VStack(spacing: Theme.paddingLarge) {

            // Section header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Try These Tasks")
                        .font(Theme.headline)
                    Text("Notice how harder it becomes as difficulty increases")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }

            TapTargetTask(difficultyLevel: difficultyLevel)
            DragTask(difficultyLevel: difficultyLevel)
            PreciseTapTask(difficultyLevel: difficultyLevel)
        }
    }
}

// MARK: - Task 1: Tap the moving (shaking) target
struct TapTargetTask: View {
    let difficultyLevel: Double
    @State private var tapped = 0
    @State private var total  = 5
    @State private var lastTapMissed = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingSmall) {

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Task 1 — Tap the Button")
                        .font(Theme.headline)
                    instructionLine(icon: "hand.tap.fill",
                                    text: "Tap the green button \(total) times")
                }
                Spacer()
                progressBadge(current: tapped, total: total, color: .green)
            }

            // Difficulty notice
            if difficultyLevel > 0 {
                difficultyBanner(
                    text: "The button shakes — this simulates hand tremors",
                    color: .orange
                )
            }

            // The button (shakes with difficulty)
            HStack {
                Spacer()
                Button(action: handleTap) {
                    ZStack {
                        Circle()
                            .fill(tapped >= total ? Color.green : Color.green.opacity(0.85))
                            .frame(width: 72, height: 72)
                            .shadow(color: .green.opacity(0.4), radius: 8)
                        if tapped >= total {
                            Image(systemName: "checkmark")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        } else {
                            Text("\(total - tapped)")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        }
                    }
                }
                .modifier(ShakeModifier(amount: difficultyLevel > 0.05 ? difficultyLevel * 14 : 0, isActive: tapped < total && difficultyLevel > 0.05))
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Tap button")
                .accessibilityValue("\(total - tapped) taps remaining")
                Spacer()
            }
            .padding(.vertical, 8)

            // Miss feedback
            if lastTapMissed {
                HStack(spacing: 4) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                    Text("Missed! Try again").font(Theme.caption).foregroundColor(.red)
                }
                .transition(.opacity)
            }

            if tapped >= total {
                successRow(text: "All \(total) taps done! 🎉")
            }
        }
        .padding(Theme.paddingMedium)
        .contentCard()
    }

    private func handleTap() {
        guard tapped < total else { return }
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        withAnimation { tapped += 1 }
        if tapped >= total {
            UIAccessibility.post(notification: .announcement, argument: "Task 1 complete!")
        }
    }
}

// MARK: - Task 2: Drag to target
struct DragTask: View {
    let difficultyLevel: Double

    // Layout is driven by GeometryReader; positions are set in onAppear
    @State private var startPos: CGPoint      = .zero
    @State private var circlePos: CGPoint     = .zero
    @State private var targetPos: CGPoint     = .zero
    @State private var isOverTarget           = false
    @State private var completed              = false
    @State private var pulse: Bool            = false
    @State private var dragNoise: Double      = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingSmall) {

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Task 2 — Drag to Target")
                        .font(Theme.headline)
                    instructionLine(icon: "arrow.right.circle.fill",
                                    text: "Drag the orange circle to the blue ring →")
                }
                Spacer()
                if completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }

            if difficultyLevel > 0 {
                difficultyBanner(
                    text: "Random drift added — like shaky or stiff hands",
                    color: .orange
                )
            }

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                ZStack {
                    // Track line
                    Path { p in
                        p.move(to: CGPoint(x: 60, y: h / 2))
                        p.addLine(to: CGPoint(x: w - 60, y: h / 2))
                    }
                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))

                    // Target ring
                    ZStack {
                        Circle()
                            .fill(isOverTarget ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                            .frame(width: 70, height: 70)
                        Circle()
                            .strokeBorder(isOverTarget ? Color.green : Color.blue,
                                          lineWidth: isOverTarget ? 3 : 2)
                            .frame(width: 70, height: 70)
                        Text("Drop\nhere")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(isOverTarget ? .green : .blue)
                            .multilineTextAlignment(.center)
                    }
                    .position(CGPoint(x: w - 55, y: h / 2))

                    // Arrow hint (idle)
                    if !completed && circlePos == startPos {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.orange.opacity(0.6))
                            .offset(x: 20)
                            .position(CGPoint(x: w / 2, y: h / 2))
                    }

                    // Draggable circle
                    ZStack {
                        Circle()
                            .fill(completed ? Color.green : Color.orange)
                            .frame(width: 48, height: 48)
                            .shadow(color: (completed ? Color.green : Color.orange).opacity(0.4), radius: 6)
                        if !completed {
                            Image(systemName: "hand.draw.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .scaleEffect(pulse ? 1.12 : 1.0)
                    .position(circlePos)
                    .gesture(
                        DragGesture()
                            .onChanged { v in
                                var p = v.location
                                if difficultyLevel > 0 {
                                    let noise = difficultyLevel * 22
                                    p.x += CGFloat.random(in: -noise...noise)
                                    p.y += CGFloat.random(in: -noise...noise)
                                }
                                // Clamp inside bounds
                                p.x = min(max(p.x, 24), w - 24)
                                p.y = min(max(p.y, 24), h - 24)
                                circlePos = p

                                let target = CGPoint(x: w - 55, y: h / 2)
                                let dist   = hypot(p.x - target.x, p.y - target.y)
                                isOverTarget = dist < 38
                            }
                            .onEnded { _ in
                                if isOverTarget && !completed {
                                    completed = true
                                    withAnimation { circlePos = CGPoint(x: w - 55, y: h / 2) }
                                    let gen = UINotificationFeedbackGenerator()
                                    gen.notificationOccurred(.success)
                                    UIAccessibility.post(notification: .announcement, argument: "Drag task completed!")
                                } else if !completed {
                                    // Spring back
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                        circlePos = startPos
                                    }
                                }
                            }
                    )
                    .disabled(completed)
                }
                .onAppear {
                    startPos  = CGPoint(x: 55, y: h / 2)
                    circlePos = startPos
                }
            }
            .frame(height: 110)

            if completed { successRow(text: "Dropped in target! 🎯") }
        }
        .padding(Theme.paddingMedium)
        .contentCard()
        .onAppear {
            // Pulse the draggable circle to signal "I am draggable"
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

// MARK: - Task 3: Tap only green
struct PreciseTapTask: View {
    let difficultyLevel: Double
    @State private var score  = 0
    @State private var misses = 0

    // 12 cells: indices 0,3,6,9 are green
    private func isGreen(_ i: Int) -> Bool { i % 3 == 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingSmall) {

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Task 3 — Tap Only Green")
                        .font(Theme.headline)
                    instructionLine(icon: "circle.grid.3x3.fill",
                                    text: "Tap every green tile, avoid red ones")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Label("\(score)", systemImage: "checkmark.circle.fill")
                        .font(Theme.caption).foregroundColor(.green)
                    Label("\(misses)", systemImage: "xmark.circle.fill")
                        .font(Theme.caption).foregroundColor(.red)
                }
            }

            if difficultyLevel > 0 {
                difficultyBanner(
                    text: "Tiles shake — easy to hit the wrong one",
                    color: .orange
                )
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10) {
                ForEach(0..<12, id: \.self) { i in
                    Button(action: { handleTap(isCorrect: isGreen(i)) }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isGreen(i) ? Color.green : Color.red)
                                .frame(minHeight: 54)
                            Image(systemName: isGreen(i) ? "checkmark" : "xmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .modifier(IndexedShakeModifier(index: i, amount: difficultyLevel > 0.05 ? difficultyLevel * 10 : 0, isActive: difficultyLevel > 0.05))
                    .accessibilityLabel(isGreen(i) ? "Green tile — tap this" : "Red tile — avoid")
                }
            }

            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Circle().fill(Color.green).frame(width: 10, height: 10)
                    Text("Tap these").font(.system(size: 11)).foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.red).frame(width: 10, height: 10)
                    Text("Avoid these").font(.system(size: 11)).foregroundColor(.secondary)
                }
            }
        }
        .padding(Theme.paddingMedium)
        .contentCard()
    }

    private func handleTap(isCorrect: Bool) {
        if isCorrect {
            score += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else {
            misses += 1
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

// MARK: - Shake modifier
private struct ShakeModifier: ViewModifier {
    let amount: CGFloat
    let isActive: Bool

    func body(content: Content) -> some View {
        if !isActive || amount < 0.5 {
            content
        } else {
            content
                .modifier(TimelineShakeModifier(amount: amount))
        }
    }
}

private struct TimelineShakeModifier: ViewModifier {
    let amount: CGFloat

    func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 0.08)) { timeline in
            var rng = SeededRandomGenerator(seed: UInt64(timeline.date.timeIntervalSince1970 * 1000))
            let offset = CGSize(
                width:  CGFloat.random(in: -amount...amount, using: &rng),
                height: CGFloat.random(in: -amount...amount, using: &rng)
            )
            content.offset(offset)
        }
    }
}

private struct SeededRandomGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

private struct IndexedShakeModifier: ViewModifier {
    let index: Int
    let amount: CGFloat
    let isActive: Bool

    func body(content: Content) -> some View {
        if !isActive || amount < 0.5 {
            content
        } else {
            TimelineView(.animation(minimumInterval: 0.1)) { timeline in
                var rng = SeededRandomGenerator(seed: UInt64(timeline.date.timeIntervalSince1970 * 1000) &+ UInt64(index * 7919))
                let offset = CGSize(
                    width:  CGFloat.random(in: -amount...amount, using: &rng),
                    height: CGFloat.random(in: -amount...amount, using: &rng)
                )
                content.offset(offset)
            }
        }
    }
}

// MARK: - Shared helper views
private func instructionLine(icon: String, text: String) -> some View {
    HStack(spacing: 5) {
        Image(systemName: icon)
            .font(.system(size: 11))
            .foregroundColor(.blue)
        Text(text)
            .font(.system(size: 12))
            .foregroundColor(.secondary)
    }
}

private func difficultyBanner(text: String, color: Color) -> some View {
    HStack(spacing: 6) {
        Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 11))
            .foregroundColor(color)
        Text(text)
            .font(.system(size: 12))
            .foregroundColor(color)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(color.opacity(0.1))
    .cornerRadius(8)
}

private func progressBadge(current: Int, total: Int, color: Color) -> some View {
    Text("\(current)/\(total)")
        .font(.system(size: 13, weight: .bold, design: .monospaced))
        .foregroundColor(current >= total ? .white : color)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(current >= total ? color : color.opacity(0.15))
        .cornerRadius(12)
}

private func successRow(text: String) -> some View {
    HStack(spacing: 6) {
        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        Text(text).font(Theme.caption).foregroundColor(.green)
    }
    .transition(.opacity.combined(with: .move(edge: .bottom)))
}

#Preview {
    ScrollView {
        InteractionTasksView(difficultyLevel: 0.5)
            .padding()
    }
}
