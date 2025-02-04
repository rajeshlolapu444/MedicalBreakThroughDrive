//
//  TextFieldMethods.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 30/01/25.
//

import Foundation
import UIKit

extension UITextField {
    func customizeTextField(cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat, placeholderColor: UIColor, leftPadding: CGFloat, rightPadding: CGFloat) {
        // Set the corner radius
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        // Set the border color and width
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        // Set the placeholder color
        if let placeholder = self.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        // Set padding for left and right
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
}
