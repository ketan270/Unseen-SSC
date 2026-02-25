//
//  ExperienceCard.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ExperienceCard: View {
    let condition: AccessibilityCondition
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            // Icon
            HStack {
                Image(systemName: condition.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Title
            Text(condition.rawValue)
                .font(Theme.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Description - fixed to 2 lines
            Text(condition.description)
                .font(Theme.body)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .multilineTextAlignment(.leading)
                .frame(height: 44, alignment: .top) // Fixed height for 2 lines
        }
        .padding(Theme.paddingLarge)
        .frame(maxWidth: .infinity)
        .frame(height: 220) // Increased slightly for better spacing
        .background(
            LinearGradient(
                colors: condition.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(Theme.cornerRadius)
        .shadow(
            color: condition.gradient[0].opacity(0.3),
            radius: 15,
            x: 0,
            y: 8
        )
    }
}

#Preview {
    VStack {
        ExperienceCard(condition: .colorBlindness) {}
        ExperienceCard(condition: .hearingLoss) {}
        ExperienceCard(condition: .limitedMobility) {}
    }
    .padding()
}
