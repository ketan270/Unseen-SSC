//
//  VisionDemoView.swift
//  Unseen
//
//  Created by Ketan Sharma on 17/01/26.
//

import SwiftUI

struct VisionDemoView: View {
    let type: VisionImpairmentType
    let severity: Double
    
    var body: some View {
        VStack(spacing: Theme.paddingLarge) {
            // Reading text demo
            VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                Text("Reading Text")
                    .font(Theme.headline)
                
                ReadingTextDemo(type: type, severity: severity)
            }
            
            // Distance vision demo
            VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                Text("Distance Vision")
                    .font(Theme.headline)
                
                DistanceVisionDemo(type: type, severity: severity)
            }
            
            // UI Elements demo
            VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                Text("Interface Elements")
                    .font(Theme.headline)
                
                UIElementsDemo(type: type, severity: severity)
            }
            
            // Icon grid demo
            VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                Text("Icons & Details")
                    .font(Theme.headline)
                
                IconGridDemo(type: type, severity: severity)
            }
        }
    }
}

// MARK: - Reading Text Demo
struct ReadingTextDemo: View {
    let type: VisionImpairmentType
    let severity: Double
    @State private var filteredImage: UIImage?
    
    var body: some View {
        Group {
            if let image = filteredImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color.white)
                    .cornerRadius(Theme.cornerRadius)
            } else {
                ProgressView()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(Theme.cornerRadius)
            }
        }
        .onChange(of: type) { _ in updatePreview() }
        .onChange(of: severity) { _ in updatePreview() }
        .onAppear { updatePreview() }
    }
    
    private func updatePreview() {
        let sampleImage = generateReadingTextImage()
        let capturedType = type
        let capturedSeverity = severity
        
        Task {
            let filtered = await Task.detached(priority: .userInitiated) {
                return sampleImage
            }.value
            filteredImage = VisionImpairmentFilter.shared.applyFilter(
                to: filtered,
                type: capturedType,
                severity: capturedSeverity
            )
        }
    }
    
    private func generateReadingTextImage() -> UIImage {
        let size = CGSize(width: 700, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineSpacing = 6
            
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            
            let bodyAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.darkGray,
                .paragraphStyle: paragraphStyle
            ]
            
            "Sample Reading Text".draw(at: CGPoint(x: 30, y: 25), withAttributes: titleAttrs)
            
            let bodyText = "This demonstrates how vision impairment affects reading clarity. Notice how text becomes harder to read as severity increases."
            bodyText.draw(in: CGRect(x: 30, y: 75, width: size.width - 60, height: 110), withAttributes: bodyAttrs)
        }
    }
}

// MARK: - Distance Vision Demo
struct DistanceVisionDemo: View {
    let type: VisionImpairmentType
    let severity: Double
    @State private var filteredImage: UIImage?
    
    var body: some View {
        Group {
            if let image = filteredImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color(.systemGray6))
                    .cornerRadius(Theme.cornerRadius)
            } else {
                ProgressView()
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(Theme.cornerRadius)
            }
        }
        .onChange(of: type) { _ in updatePreview() }
        .onChange(of: severity) { _ in updatePreview() }
        .onAppear { updatePreview() }
    }
    
    private func updatePreview() {
        let sampleImage = generateDistanceImage()
        let capturedType = type
        let capturedSeverity = severity
        
        Task {
            let filtered = await Task.detached(priority: .userInitiated) {
                return sampleImage
            }.value
            filteredImage = VisionImpairmentFilter.shared.applyFilter(
                to: filtered,
                type: capturedType,
                severity: capturedSeverity
            )
        }
    }
    
    private func generateDistanceImage() -> UIImage {
        let size = CGSize(width: 700, height: 250)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.systemGray6.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Draw distant objects (buildings/shapes)
            UIColor.systemBlue.setFill()
            let building1 = UIBezierPath(rect: CGRect(x: 60, y: 80, width: 90, height: 130))
            building1.fill()
            
            UIColor.systemGreen.setFill()
            let building2 = UIBezierPath(rect: CGRect(x: 220, y: 100, width: 70, height: 110))
            building2.fill()
            
            UIColor.systemOrange.setFill()
            let building3 = UIBezierPath(rect: CGRect(x: 380, y: 90, width: 80, height: 120))
            building3.fill()
            
            UIColor.systemPurple.setFill()
            let building4 = UIBezierPath(rect: CGRect(x: 530, y: 70, width: 100, height: 140))
            building4.fill()
            
            // Add text label
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
                .foregroundColor: UIColor.black
            ]
            "Distant Objects".draw(at: CGPoint(x: 260, y: 30), withAttributes: attrs)
        }
    }
}

// MARK: - UI Elements Demo
struct UIElementsDemo: View {
    let type: VisionImpairmentType
    let severity: Double
    @State private var filteredImage: UIImage?
    
    var body: some View {
        Group {
            if let image = filteredImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(Theme.cornerRadius)
            } else {
                ProgressView()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(Theme.cornerRadius)
            }
        }
        .onChange(of: type) { _ in updatePreview() }
        .onChange(of: severity) { _ in updatePreview() }
        .onAppear { updatePreview() }
    }
    
    private func updatePreview() {
        let sampleImage = generateUIElementsImage()
        let capturedType = type
        let capturedSeverity = severity
        
        Task {
            let filtered = await Task.detached(priority: .userInitiated) {
                return sampleImage
            }.value
            filteredImage = VisionImpairmentFilter.shared.applyFilter(
                to: filtered,
                type: capturedType,
                severity: capturedSeverity
            )
        }
    }
    
    private func generateUIElementsImage() -> UIImage {
        let size = CGSize(width: 700, height: 150)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Draw buttons
            let buttonColors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemRed]
            let buttonLabels = ["Primary", "Success", "Warning", "Danger"]
            
            for (index, color) in buttonColors.enumerated() {
                let x = CGFloat(index) * 160 + 40
                
                // Button background
                color.setFill()
                let buttonPath = UIBezierPath(roundedRect: CGRect(x: x, y: 50, width: 130, height: 50), cornerRadius: 10)
                buttonPath.fill()
                
                // Button text
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                    .foregroundColor: UIColor.white
                ]
                let label = buttonLabels[index]
                let textSize = label.size(withAttributes: attrs)
                let textX = x + (130 - textSize.width) / 2
                let textY: CGFloat = 50 + (50 - textSize.height) / 2
                label.draw(at: CGPoint(x: textX, y: textY), withAttributes: attrs)
            }
        }
    }
}

// MARK: - Icon Grid Demo
struct IconGridDemo: View {
    let type: VisionImpairmentType
    let severity: Double
    @State private var filteredImage: UIImage?
    
    var body: some View {
        Group {
            if let image = filteredImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color.white)
                    .cornerRadius(Theme.cornerRadius)
            } else {
                ProgressView()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(Theme.cornerRadius)
            }
        }
        .onChange(of: type) { _ in updatePreview() }
        .onChange(of: severity) { _ in updatePreview() }
        .onAppear { updatePreview() }
    }
    
    private func updatePreview() {
        let sampleImage = generateIconGridImage()
        let capturedType = type
        let capturedSeverity = severity
        
        Task {
            let filtered = await Task.detached(priority: .userInitiated) {
                return sampleImage
            }.value
            filteredImage = VisionImpairmentFilter.shared.applyFilter(
                to: filtered,
                type: capturedType,
                severity: capturedSeverity
            )
        }
    }
    
    private func generateIconGridImage() -> UIImage {
        let size = CGSize(width: 700, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Draw grid of small icons/shapes
            let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemPink]
            
            for row in 0..<2 {
                for col in 0..<6 {
                    let x = CGFloat(col) * 105 + 40
                    let y = CGFloat(row) * 85 + 35
                    let color = colors[(row * 6 + col) % colors.count]
                    
                    // Draw icon background
                    color.withAlphaComponent(0.3).setFill()
                    let bgPath = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 70, height: 70), cornerRadius: 14)
                    bgPath.fill()
                    
                    // Draw icon symbol
                    color.setFill()
                    let iconPath = UIBezierPath(ovalIn: CGRect(x: x + 25, y: y + 25, width: 20, height: 20))
                    iconPath.fill()
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VisionDemoView(type: .myopia, severity: 0.5)
            .padding()
    }
}
