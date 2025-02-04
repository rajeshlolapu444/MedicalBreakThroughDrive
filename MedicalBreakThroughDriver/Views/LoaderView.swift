//
//  LoaderView.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import Foundation
import UIKit
import ImageIO

class LoaderView {
    static let shared = LoaderView()
    
    private var loaderView: UIView?
    
    private init() {}
    
    func showLoader(in view: UIView) {
        if loaderView != nil { return } // Prevent multiple loaders
        
        let loaderContainer = UIView(frame: view.bounds)
        loaderContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let loaderImageView = UIImageView()
        loaderImageView.contentMode = .scaleAspectFit
        loaderImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loaderImageView.center = loaderContainer.center
        
        if let gifImage = UIImage.gif(name: "Loader_pets") { // Change "loader" with your GIF file name
            loaderImageView.image = gifImage
        }
        
        loaderContainer.addSubview(loaderImageView)
        view.addSubview(loaderContainer)
        
        loaderView = loaderContainer
    }
    
    func hideLoader() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}
