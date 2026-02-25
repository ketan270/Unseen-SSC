//
//  ColorBlindnessFilter.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

// Simplified color blindness filter using saturation and color adjustments
struct ColorBlindnessFilter: ViewModifier {
    let type: ColorBlindnessType
    
    func body(content: Content) -> some View {
        switch type {
        case .normal:
            content
        case .achromatopsia:
            content
                .saturation(0) // Complete grayscale
        case .protanopia, .deuteranopia:
            // Red-green color blindness - reduce red-green distinction
            content
                .saturation(0.6)
                .colorMultiply(Color(red: 0.9, green: 0.9, blue: 1.0))
        case .tritanopia:
            // Blue-yellow color blindness
            content
                .saturation(0.7)
                .colorMultiply(Color(red: 1.0, green: 0.95, blue: 0.9))
        }
    }
}

extension View {
    func colorBlindnessFilter(_ type: ColorBlindnessType) -> some View {
        self.modifier(ColorBlindnessFilter(type: type))
    }
}

