//
//  AccessibilityCondition.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

enum AccessibilityCondition: String, CaseIterable, Identifiable {
    case colorBlindness = "Color Blindness"
    case visionImpairment = "Vision Impairment"
    case hearingLoss = "Hearing Loss"
    case limitedMobility = "Limited Mobility"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .colorBlindness:
            return "eye.fill"
        case .visionImpairment:
            return "eyeglasses"
        case .hearingLoss:
            return "ear.fill"
        case .limitedMobility:
            return "hand.raised.fill"
        }
    }
    
    var description: String {
        switch self {
        case .colorBlindness:
            return "Experience how color vision deficiencies affect daily interactions"
        case .visionImpairment:
            return "See the world through blurred vision like nearsightedness or farsightedness"
        case .hearingLoss:
            return "Understand the challenges of navigating a world designed for hearing"
        case .limitedMobility:
            return "Feel the difficulty of precise motor control and interaction"
        }
    }
    
    var gradient: [Color] {
        switch self {
        case .colorBlindness:
            return [Color.purple, Color.blue]
        case .visionImpairment:
            return [Color.indigo, Color.teal]
        case .hearingLoss:
            return [Color.orange, Color.pink]
        case .limitedMobility:
            return [Color.green, Color.cyan]
        }
    }
    
    var statistics: String {
        switch self {
        case .colorBlindness:
            return "~8% of men and ~0.5% of women have some form of color vision deficiency"
        case .visionImpairment:
            return "~75% of adults need vision correction (glasses or contacts)"
        case .hearingLoss:
            return "Over 1.5 billion people worldwide (1 in 5) experience some degree of hearing loss"
        case .limitedMobility:
            return "595M+ have osteoarthritis; 11M+ have Parkinson's — conditions affecting fine motor control"
        }
    }
    
    var impact: String {
        switch self {
        case .colorBlindness:
            return "Color-coded information, traffic lights, charts, and UI elements can be difficult or impossible to distinguish"
        case .visionImpairment:
            return "Small text, low contrast, and detailed images become difficult to see without proper correction"
        case .hearingLoss:
            return "Audio alerts, videos without captions, and sound-dependent interfaces create barriers to access"
        case .limitedMobility:
            return "Small touch targets, precise gestures, and time-sensitive interactions can be frustrating or impossible"
        }
    }
}
