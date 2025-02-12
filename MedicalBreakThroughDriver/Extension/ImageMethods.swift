//
//  ImageMethods.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import Foundation
import UIKit
import ImageIO
import SDWebImage

extension UIImage {
    static func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif"),
              let imageData = try? Data(contentsOf: bundleURL) else { return nil }
        
        return gif(data: imageData)
    }
    
    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return animatedImageWithSource(source)
    }
    
    private static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let frameCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        
        for i in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            let frameDuration = frameDurationAtIndex(i, source: source)
            duration += frameDuration
            images.append(UIImage(cgImage: cgImage))
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
    private static func frameDurationAtIndex(_ index: Int, source: CGImageSource) -> TimeInterval {
        let defaultFrameDuration = 0.1
        guard let frameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = frameProperties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval
        else { return defaultFrameDuration }
        
        return delayTime > 0 ? delayTime : defaultFrameDuration
    }
}
extension UIImageView {
    func setImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = PlaceHolderImage
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: PlaceHolderImage, options: .highPriority) { (image, error, _, _) in
            if let image = image {
                self.image = image
            } else {
                self.image = PlaceHolderImage
            }
        }
    }
}
