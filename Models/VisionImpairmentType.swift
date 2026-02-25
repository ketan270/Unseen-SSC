//
//  VisionImpairmentType.swift
//  Unseen
//
//  Created by Ketan Sharma on 17/01/26.
//

import SwiftUI

enum VisionImpairmentType: String, CaseIterable, Identifiable {
    case myopia = "Nearsightedness"
    case hyperopia = "Farsightedness"
    case astigmatism = "Astigmatism"
    case presbyopia = "Age-Related Vision"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .myopia:
            return "binoculars.fill"
        case .hyperopia:
            return "book.fill"
        case .astigmatism:
            return "waveform.path"
        case .presbyopia:
            return "calendar"
        }
    }
    
    var description: String {
        switch self {
        case .myopia:
            return "Distant objects appear blurry while near objects are clear"
        case .hyperopia:
            return "Near objects appear blurry while distant objects are clearer"
        case .astigmatism:
            return "Objects appear stretched or distorted in one direction"
        case .presbyopia:
            return "Age-related difficulty focusing on near objects, especially when reading"
        }
    }
    
    var prevalence: String {
        switch self {
        case .myopia:
            return "30-90% of population (varies by region, highest in East Asia)"
        case .hyperopia:
            return "~25% of population"
        case .astigmatism:
            return "~33% of population"
        case .presbyopia:
            return "Nearly 100% of people over 45 years old"
        }
    }
    
    var causes: String {
        switch self {
        case .myopia:
            return "Eyeball is too long or cornea is too curved, causing light to focus in front of the retina"
        case .hyperopia:
            return "Eyeball is too short or cornea is too flat, causing light to focus behind the retina"
        case .astigmatism:
            return "Irregular curvature of the cornea or lens causes light to focus unevenly"
        case .presbyopia:
            return "Natural aging process reduces the eye's ability to focus on close objects"
        }
    }
    
    var correction: String {
        switch self {
        case .myopia:
            return "Concave (minus) lenses in glasses or contacts, or LASIK surgery"
        case .hyperopia:
            return "Convex (plus) lenses in glasses or contacts, or LASIK surgery"
        case .astigmatism:
            return "Cylindrical lenses in glasses or toric contact lenses"
        case .presbyopia:
            return "Reading glasses, bifocals, progressive lenses, or multifocal contacts"
        }
    }
    
    var designTips: [String] {
        switch self {
        case .myopia:
            return [
                "Ensure important information is visible at normal viewing distance",
                "Provide zoom functionality for distant content",
                "Use clear, high-contrast text",
                "Avoid relying solely on small distant details"
            ]
        case .hyperopia:
            return [
                "Make text and UI elements large enough to read comfortably",
                "Provide adjustable font sizes",
                "Use high contrast for close-up content",
                "Avoid tiny buttons or small touch targets"
            ]
        case .astigmatism:
            return [
                "Use clear, simple fonts without decorative elements",
                "Ensure adequate spacing between lines and elements",
                "Avoid thin lines that may appear distorted",
                "Provide high contrast to improve clarity"
            ]
        case .presbyopia:
            return [
                "Support Dynamic Type and adjustable font sizes",
                "Use minimum 16pt font size for body text",
                "Provide adequate line spacing",
                "Ensure good contrast for reading",
                "Consider larger default text sizes for older users"
            ]
        }
    }
    
    var severityLabel: (min: String, max: String) {
        switch self {
        case .myopia:
            return ("Perfect Vision", "-8.00 (Severe)")
        case .hyperopia:
            return ("Perfect Vision", "+6.00 (Severe)")
        case .astigmatism:
            return ("None", "Severe")
        case .presbyopia:
            return ("Age 20", "Age 65+")
        }
    }
}
