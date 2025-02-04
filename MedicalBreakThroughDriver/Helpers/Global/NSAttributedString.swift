//
//  NSAttributedString.swift
//  Done
//
//  Created by Tarun Sahu on 21/03/24.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func withIcon(atEndOfText text: String, icon: UIImage, iconSize: CGSize) -> NSAttributedString {
        
        let fullText = "\(text) ***" // Adding placeholder at the end of text
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Find the range of the placeholder
        if let range = fullText.range(of: "***") {
            // Create NSTextAttachment with your icon
            let attachment = NSTextAttachment()
            attachment.image = icon
            attachment.bounds = CGRect(origin: .init(x: 0, y: -3), size: iconSize)
            
            // Create attributed string with image
            let attachmentString = NSAttributedString(attachment: attachment)
            
            // Replace the placeholder with the image
            attributedString.replaceCharacters(in: NSRange(range, in: fullText), with: attachmentString)
            
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowBlurRadius = 1.0
            shadow.shadowOffset = CGSize(width: 0, height: 1)
            attributedString.addAttribute(.shadow, value: shadow, range: NSRange(location: 0, length: attributedString.length))
            
        }
        return attributedString
    }
    public static func attributedText(firstText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let secondText = "x"
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Goldplay Bold", size: 15) ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white
        ]
        
        let firstAttributedString = NSAttributedString(string: firstText, attributes: firstAttributes)
        attributedString.append(firstAttributedString)
        
        let space = "  "
        let spaceAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Goldplay Bold", size: 6) ?? UIFont.systemFont(ofSize: 6)
        ]
        let spaceAttributedString = NSAttributedString(string: space, attributes: spaceAttributes)
        attributedString.append(spaceAttributedString)
        
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Goldplay Bold", size: 11) ?? UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.white,
        ]
        let secondAttributedString = NSAttributedString(string: secondText, attributes: secondAttributes)
        attributedString.append(secondAttributedString)
        
        // Calculate the total height of the attributed string
        let totalHeight = attributedString.size().height
        
        // Calculate the vertical offset to center the attributed string
        let verticalOffset = (totalHeight - firstAttributedString.size().height) / 2
        
        // Apply the baseline offset to the entire attributed string
        attributedString.addAttribute(.baselineOffset, value: verticalOffset, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
}

extension NSAttributedString.Key {
    static let customAction = NSAttributedString.Key(rawValue: "CustomAction")
}
