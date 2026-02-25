//
//  VisionImpairmentView.swift
//  Unseen
//
//  Created by Ketan Sharma on 17/01/26.
//

import SwiftUI

struct VisionImpairmentView: View {
    @State private var selectedType: VisionImpairmentType = .myopia
    @State private var severity: Double = 0.5
    @State private var showInfo = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                VStack(spacing: Theme.paddingSmall) {
                    Text("Vision Impairment")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(AccessibilityCondition.visionImpairment.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)

                // What this simulates
                HStack(spacing: 0) {
                    visionCell(icon: "scope",         label: "Blur",        color: .blue)
                    Divider().frame(height: 44)
                    visionCell(icon: "wand.and.rays",  label: "Distortion",  color: .purple)
                    Divider().frame(height: 44)
                    visionCell(icon: "circle.dashed",  label: "Blind spots", color: .orange)
                }
                .padding(.vertical, 10)
                .background(Color.indigo.opacity(0.07))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal)
                
                // Type selector (matching color blindness design)
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Select Vision Type")
                            .font(Theme.headline)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.paddingMedium) {
                            ForEach(VisionImpairmentType.allCases) { type in
                                VisionTypeChip(
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
                VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text(selectedType.description)
                            .font(Theme.body)
                            .fontWeight(.medium)
                    }
                    
                    Text("Affects \(selectedType.prevalence)")
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(Theme.buttonCornerRadius)
                .padding(.horizontal)
                
                // Severity control
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Severity")
                            .font(Theme.headline)
                        
                        Spacer()
                        
                        Text(severityText)
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "eye")
                            .foregroundColor(.green)
                        
                        Slider(value: $severity, in: 0...1)
                            .tint(.blue)
                            .accessibilityLabel("Vision impairment severity")
                            .accessibilityValue(severityText)
                        
                        Image(systemName: "eye.slash")
                            .foregroundColor(.red)
                    }
                    
                    // Severity labels
                    HStack {
                        Text(selectedType.severityLabel.min)
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(selectedType.severityLabel.max)
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }

                    // Small instruction nudge
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.blue)
                        Text("Drag the slider — the preview below updates live")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .contentCard()
                .padding(.horizontal)
                
                // Demo content (matching color blindness structure)
                VisionDemoView(type: selectedType, severity: severity)
                    .padding(.horizontal)
            }
            .padding(.bottom, Theme.paddingLarge)
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
            VisionImpairmentInfoSheet(selectedType: selectedType)
        }
    }
    
    private var severityText: String {
        let percentage = Int(severity * 100)
        
        switch severity {
        case 0..<0.2:
            return "Mild (\(percentage)%)"
        case 0.2..<0.5:
            return "Moderate (\(percentage)%)"
        case 0.5..<0.8:
            return "Severe (\(percentage)%)"
        default:
            return "Very Severe (\(percentage)%)"
        }
    }

    private func visionCell(icon: String, label: String, color: Color) -> some View {
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

// MARK: - Vision Type Chip (matching ColorBlindness TypeChip design)
struct VisionTypeChip: View {
    let type: VisionImpairmentType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 18)
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

// MARK: - Info Sheet
struct VisionImpairmentInfoSheet: View {
    @Environment(\.dismiss) var dismiss
    let selectedType: VisionImpairmentType
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Vision impairment affects how clearly we see objects at different distances. Most people develop some form of vision impairment during their lifetime.")
                        .font(Theme.body)
                    
                    Text(AccessibilityCondition.visionImpairment.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Design Tips")
                        .font(Theme.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        ForEach(selectedType.designTips, id: \.self) { tip in
                            TipRow(icon: "checkmark.circle.fill", text: tip)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("About Vision Impairment")
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
        VisionImpairmentView()
    }
}
