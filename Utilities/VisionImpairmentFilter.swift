//
//  VisionImpairmentFilter.swift
//  Unseen
//
//  Created by Ketan Sharma on 17/01/26.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class VisionImpairmentFilter {
    @MainActor static let shared = VisionImpairmentFilter()
    private let context = CIContext()
    
    private init() {}
    
    /// Apply vision impairment filter to an image
    /// - Parameters:
    ///   - image: Input UIImage
    ///   - type: Type of vision impairment
    ///   - severity: Severity level from 0.0 (none) to 1.0 (severe)
    /// - Returns: Filtered UIImage
    func applyFilter(to image: UIImage, type: VisionImpairmentType, severity: Double) -> UIImage? {
        guard severity > 0 else { return image }
        guard let inputImage = CIImage(image: image) else { return image }
        
        let filteredImage: CIImage?
        
        switch type {
        case .myopia:
            filteredImage = applyMyopiaFilter(to: inputImage, severity: severity)
        case .hyperopia:
            filteredImage = applyHyperopiaFilter(to: inputImage, severity: severity)
        case .astigmatism:
            filteredImage = applyAstigmatismFilter(to: inputImage, severity: severity)
        case .presbyopia:
            filteredImage = applyPresbyopiaFilter(to: inputImage, severity: severity)
        }
        
        guard let outputImage = filteredImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    // MARK: - Myopia (Nearsightedness)
    /// Distant objects are blurry - entire image gets uniformly blurred
    private func applyMyopiaFilter(to image: CIImage, severity: Double) -> CIImage? {
        // For myopia, everything at distance is blurry
        // Apply uniform Gaussian blur across entire image
        let blurRadius = severity * 30.0 // 0 to 30 pixels
        
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = image
        blurFilter.radius = Float(blurRadius)
        
        return blurFilter.outputImage
    }
    
    // MARK: - Hyperopia (Farsightedness)
    /// Near objects are blurry - entire image gets uniformly blurred
    private func applyHyperopiaFilter(to image: CIImage, severity: Double) -> CIImage? {
        // For hyperopia, close-up things are blurry
        // Apply uniform Gaussian blur across entire image
        let blurRadius = severity * 25.0 // 0 to 25 pixels
        
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = image
        blurFilter.radius = Float(blurRadius)
        
        return blurFilter.outputImage
    }
    
    // MARK: - Astigmatism
    /// Objects appear stretched or distorted in one direction
    private func applyAstigmatismFilter(to image: CIImage, severity: Double) -> CIImage? {
        // Apply motion blur in one direction to simulate astigmatism
        let blurRadius = severity * 20.0
        
        let motionBlurFilter = CIFilter.motionBlur()
        motionBlurFilter.inputImage = image
        motionBlurFilter.radius = Float(blurRadius)
        motionBlurFilter.angle = Float.pi / 4 // 45 degrees
        
        guard let blurredImage = motionBlurFilter.outputImage else { return image }
        
        // Slightly reduce contrast
        let contrastFilter = CIFilter.colorControls()
        contrastFilter.inputImage = blurredImage
        contrastFilter.contrast = Float(1.0 - (severity * 0.15))
        
        return contrastFilter.outputImage
    }
    
    // MARK: - Presbyopia (Age-Related)
    /// Similar to hyperopia - uniform blur for close-up viewing
    private func applyPresbyopiaFilter(to image: CIImage, severity: Double) -> CIImage? {
        // Apply uniform blur like hyperopia
        let blurRadius = severity * 28.0
        
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = image
        blurFilter.radius = Float(blurRadius)
        
        guard let blurredImage = blurFilter.outputImage else { return image }
        
        // Reduce contrast slightly to simulate aging eyes
        let contrastFilter = CIFilter.colorControls()
        contrastFilter.inputImage = blurredImage
        contrastFilter.contrast = Float(1.0 - (severity * 0.2))
        contrastFilter.brightness = Float(severity * 0.05) // Slight brightness increase
        
        return contrastFilter.outputImage
    }
}
