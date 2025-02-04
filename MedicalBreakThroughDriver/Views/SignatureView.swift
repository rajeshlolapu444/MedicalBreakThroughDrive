//
//  SignatureView.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 31/01/25.
//

import Foundation
import UIKit

class SignatureView: UIView {
    
    private var path = UIBezierPath()
    private var previousPoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            previousPoint = touch.location(in: self)
            path.move(to: previousPoint!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let previousPoint = previousPoint {
            let currentPoint = touch.location(in: self)
            path.addLine(to: currentPoint)
            self.previousPoint = currentPoint
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.lineWidth = 3
        path.lineCapStyle = .round
        path.stroke()
    }
    
    func clear() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    func getImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
