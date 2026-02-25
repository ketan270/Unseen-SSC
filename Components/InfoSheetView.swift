//
//  InfoSheetView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct InfoSheetView: View {
    @Environment(\.dismiss) var dismiss 
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    // About section
                    VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                        Text("About Unseen")
                            .font(Theme.title)
                            .fontWeight(.bold)
                        
                        Text("Unseen is an educational app designed to build empathy and understanding by simulating how people with different disabilities experience digital interfaces and the world around them.")
                            .font(Theme.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Purpose section
                    VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                        Text("Our Purpose")
                            .font(Theme.title2)
                            .fontWeight(.semibold)
                        
                        Text("By experiencing these simulations, you'll gain insight into the daily challenges faced by millions of people and understand why accessible design matters.")
                            .font(Theme.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Accessibility tips
                    VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                        Text("Design for Everyone")
                            .font(Theme.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                            TipRow(icon: "paintpalette.fill", text: "Don't rely on color alone to convey information")
                            TipRow(icon: "captions.bubble.fill", text: "Always provide captions for audio and video")
                            TipRow(icon: "hand.tap.fill", text: "Make touch targets large and easy to tap")
                            TipRow(icon: "textformat.size", text: "Support Dynamic Type for text scaling")
                            TipRow(icon: "speaker.wave.2.fill", text: "Provide visual alternatives to audio cues")
                        }
                    }
                    
                    Divider()
                    
                    // Resources
                    VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                        Text("Learn More")
                            .font(Theme.title2)
                            .fontWeight(.semibold)
                        
                        Text("Visit Apple's Human Interface Guidelines for comprehensive accessibility best practices.")
                            .font(Theme.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(Theme.paddingLarge)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Information")
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

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(text)
                .font(Theme.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InfoSheetView()
}
