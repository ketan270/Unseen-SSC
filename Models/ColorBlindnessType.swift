//
//  ColorBlindnessType.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

enum ColorBlindnessType: String, CaseIterable, Identifiable {
    case normal = "Normal Vision"
    case protanopia = "Protanopia"
    case deuteranopia = "Deuteranopia"
    case tritanopia = "Tritanopia"
    case achromatopsia = "Achromatopsia"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .normal:
            return "Standard color vision"
        case .protanopia:
            return "Red-blind (no red cones)"
        case .deuteranopia:
            return "Green-blind (no green cones)"
        case .tritanopia:
            return "Blue-blind (no blue cones)"
        case .achromatopsia:
            return "Complete color blindness"
        }
    }
    
    var prevalence: String {
        switch self {
        case .normal:
            return "Most common"
        case .protanopia:
            return "~1% of males"
        case .deuteranopia:
            return "~1% of males"
        case .tritanopia:
            return "~1 in 15,000 (affects men & women equally)"
        case .achromatopsia:
            return "~1 in 30,000 people"
        }
    }
    
    // Color transformation matrices for simulating color blindness
    // Based on research by Brettel, Viénot and Mollon (1997)
    var transformMatrix: [Float] {
        switch self {
        case .normal:
            return [
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            ]
        case .protanopia:
            return [
                0.567, 0.433, 0, 0,
                0.558, 0.442, 0, 0,
                0, 0.242, 0.758, 0,
                0, 0, 0, 1
            ]
        case .deuteranopia:
            return [
                0.625, 0.375, 0, 0,
                0.7, 0.3, 0, 0,
                0, 0.3, 0.7, 0,
                0, 0, 0, 1
            ]
        case .tritanopia:
            return [
                0.95, 0.05, 0, 0,
                0, 0.433, 0.567, 0,
                0, 0.475, 0.525, 0,
                0, 0, 0, 1
            ]
        case .achromatopsia:
            return [
                0.299, 0.587, 0.114, 0,
                0.299, 0.587, 0.114, 0,
                0.299, 0.587, 0.114, 0,
                0, 0, 0, 1
            ]
        }
    }
}
