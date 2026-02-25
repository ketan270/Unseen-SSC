//
//  Theme.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct Theme {
    // MARK: - Colors
    
    // App-wide gradient (purple to blue) - used for backgrounds
    static let appGradient = LinearGradient(
        colors: [
            Color(red: 0.39, green: 0.40, blue: 0.95), // #6366F1 - Indigo
            Color(red: 0.55, green: 0.36, blue: 0.96), // #8B5CF6 - Purple
            Color(red: 0.66, green: 0.33, blue: 0.97)  // #A855F7 - Fuchsia
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Primary gradient for buttons and accents
    static let primaryGradient = LinearGradient(
        colors: [Color.blue, Color.purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let selectableCardBackground = Color(.tertiarySystemBackground)
    static let selectableCardBorder = Color.white.opacity(0.12)
    static let selectedCardGradient = LinearGradient(
        colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Card on gradient background
    static let cardOnGradientBackground = Color.white.opacity(0.95)
    
    // MARK: - Typography
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
    
    // MARK: - Spacing
    static let paddingXSmall: CGFloat = 4
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32
    
    // MARK: - Layout
    static let cornerRadius: CGFloat = 20
    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 12
    
    // MARK: - Shadows
    static let cardShadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
        Color.black.opacity(0.1),
        10,
        0,
        5
    )
    
    // Enhanced shadow for cards on gradient
    static let cardOnGradientShadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
        Color.black.opacity(0.15),
        20,
        0,
        10
    )
    
    // MARK: - Animation
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let easeAnimation = Animation.easeInOut(duration: 0.3)
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cardCornerRadius)
            .shadow(
                color: Theme.cardShadow.color,
                radius: Theme.cardShadow.radius,
                x: Theme.cardShadow.x,
                y: Theme.cardShadow.y
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(Theme.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.primaryGradient)
            .cornerRadius(Theme.buttonCornerRadius)
    }
    
    // Content card with border for dark mode visibility
    func contentCard() -> some View {
        self
            .background(Color(.tertiarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .cornerRadius(Theme.cardCornerRadius)
    }
    
    func selectableCard(isSelected: Bool) -> some View {
        self
            .background(
                Group {
                    if isSelected {
                        Theme.selectedCardGradient
                    } else {
                        Theme.selectableCardBackground
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(
                        isSelected
                        ? Color.clear
                        : Theme.selectableCardBorder,
                        lineWidth: 1
                    )
            )
            .cornerRadius(Theme.cardCornerRadius)
            .shadow(
                color: isSelected
                ? Color.black.opacity(0.35)
                : Color.black.opacity(0.2),
                radius: isSelected ? 10 : 6,
                x: 0,
                y: 4
            )
            .scaleEffect(isSelected ? 1.03 : 1.0)
            .animation(Theme.springAnimation, value: isSelected)
    }
}
