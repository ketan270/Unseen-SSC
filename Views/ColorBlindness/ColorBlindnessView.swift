//
//  ColorBlindnessView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ColorBlindnessView: View {
    @State private var selectedType: ColorBlindnessType = .normal
    @State private var showInfo = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                VStack(spacing: Theme.paddingSmall) {
                    Text("Color Blindness")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(AccessibilityCondition.colorBlindness.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // What this simulates
                HStack(spacing: 0) {
                    conditionCell(icon: "eye.trianglebadge.exclamationmark", label: "Color shift",    color: .red)
                    Divider().frame(height: 44)
                    conditionCell(icon: "paintpalette",                       label: "Hue confusion",  color: .orange)
                    Divider().frame(height: 44)
                    conditionCell(icon: "circle.lefthalf.filled",             label: "Contrast loss",  color: .blue)
                }
                .padding(.vertical, 10)
                .background(Color.purple.opacity(0.07))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal)

                
                // Type selector
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Select Vision Type")
                            .font(Theme.headline)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.paddingMedium) {
                            ForEach(ColorBlindnessType.allCases) { type in
                                TypeChip(
                                    type: type,
                                    isSelected: selectedType == type,
                                    action: {
                                        withAnimation(Theme.springAnimation) {
                                            selectedType = type
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                
                // Current type info
                if selectedType != .normal {
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text(selectedType.description)
                                .font(Theme.body)
                                .fontWeight(.medium)
                        }
                        
                        Text("Affects \(selectedType.prevalence) of the population")
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(Theme.buttonCornerRadius)
                    .padding(.horizontal)
                }

                // Teaching nudge — small, unobtrusive
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("The entire screen is filtered in real-time — switch types to see the world through different eyes.")
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.08))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal)
                
                // Demo content
                ColorDemoView(filterType: selectedType)
                    .padding(.horizontal)
            }
            .padding(.bottom, Theme.paddingLarge)
        }
        .colorBlindnessFilter(selectedType)
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
            ColorBlindnessInfoSheet()
        }
    }

    private func conditionCell(icon: String, label: String, color: Color) -> some View {
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
}

struct TypeChip: View {
    let type: ColorBlindnessType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    isSelected ?
                        AnyView(Theme.primaryGradient) :
                        AnyView(Color(.tertiarySystemGroupedBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.buttonCornerRadius)
                        .stroke(
                            isSelected ? Color.clear : Color.white.opacity(0.15),
                            lineWidth: 1
                        )
                )
                .cornerRadius(Theme.buttonCornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorBlindnessInfoSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Color blindness affects how people perceive colors. It's usually genetic and affects more men than women.")
                        .font(Theme.body)
                    
                    Text(AccessibilityCondition.colorBlindness.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Design Tips")
                        .font(Theme.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        TipRow(icon: "checkmark.circle.fill", text: "Use patterns or labels in addition to color")
                        TipRow(icon: "checkmark.circle.fill", text: "Ensure sufficient contrast ratios")
                        TipRow(icon: "checkmark.circle.fill", text: "Test designs with color blindness simulators")
                        TipRow(icon: "checkmark.circle.fill", text: "Avoid red-green combinations for critical info")
                    }
                }
                .padding()
            }
            .navigationTitle("About Color Blindness")
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
    NavigationStack {
        ColorBlindnessView()
    }
}
