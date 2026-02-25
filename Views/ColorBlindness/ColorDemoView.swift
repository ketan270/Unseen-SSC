//
//  ColorDemoView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ColorDemoView: View {
    let filterType: ColorBlindnessType
    
    var body: some View {
        VStack(spacing: Theme.paddingLarge) {
            // Traffic light demo
            DemoSection(title: "Traffic Light") {
                TrafficLightDemo()
            }
            
            // Color swatches
            DemoSection(title: "Color Palette") {
                ColorSwatchDemo()
            }
            
            // UI buttons
            DemoSection(title: "Interface Buttons") {
                ButtonDemo()
            }
            
            // Chart demo
            DemoSection(title: "Data Visualization") {
                ChartDemo()
            }
        }
    }
}

struct DemoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            Text(title)
                .font(Theme.headline)
            
            content
                .padding()
                .frame(maxWidth: .infinity)
                .contentCard()
        }
    }
}

struct TrafficLightDemo: View {
    var body: some View {
        HStack(spacing: 40) {
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                Text("Stop")
                    .font(.caption)
            }
            
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 50, height: 50)
                Text("Caution")
                    .font(.caption)
            }
            
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                Text("Go")
                    .font(.caption)
            }
        }
    }
}

struct ColorSwatchDemo: View {
    let colors: [(String, Color)] = [
        ("Red", .red),
        ("Orange", .orange),
        ("Yellow", .yellow),
        ("Green", .green),
        ("Blue", .blue),
        ("Purple", .purple)
    ]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
            ForEach(colors, id: \.0) { name, color in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(height: 60)
                    
                    Text(name)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ButtonDemo: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                DemoButton(title: "Success", color: .green, icon: "checkmark")
                DemoButton(title: "Error", color: .red, icon: "xmark")
            }
            
            HStack(spacing: 12) {
                DemoButton(title: "Warning", color: .orange, icon: "exclamationmark")
                DemoButton(title: "Info", color: .blue, icon: "info")
            }
        }
    }
}

struct DemoButton: View {
    let title: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct ChartDemo: View {
    let data: [(String, Double, Color)] = [
        ("A", 0.7, .red),
        ("B", 0.5, .green),
        ("C", 0.9, .blue),
        ("D", 0.6, .orange)
    ]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            ForEach(data, id: \.0) { label, value, color in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: 40, height: CGFloat(value * 100))
                    
                    Text(label)
                        .font(.caption)
                }
            }
        }
        .frame(height: 120)
    }
}

#Preview {
    ScrollView {
        ColorDemoView(filterType: .deuteranopia)
            .padding()
    }
}
