//
//  PreviewViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 21/02/25.
//

import UIKit
import AVKit

class PreviewViewController: UIViewController {
    
    var deliveryImage: DeliveryImages?
    var selectedIndex: Int = 0
    var deliveryImages: [DeliveryImages] = []
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        debugPrint(selectedIndex,"selectedIndex")
        deliveryImage = deliveryImages[selectedIndex]
        if let deliveryImage = deliveryImage {
            if deliveryImage.type == "image", let urlString = deliveryImage.url, let url = URL(string: urlString) {
                setupImageView(url: url)
            } else if deliveryImage.type == "video", let urlString = deliveryImage.url, let url = URL(string: urlString) {
                setupVideoPlayer(url: url)
            } else {
                if let urlString = deliveryImage.url, let url = URL(string: urlString) {
                    setupImageView(url: url)
                }
            }
        }
    }
    
    private func setupImageView(url: URL) {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Load image asynchronously
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = PlaceHolderImage
                }
            }
        }
    }
    private func setupVideoPlayer(url: URL) {
        debugPrint(url,"setupVideoPlayer")
        // Stop and release the previous player before setting a new one
        player?.pause()
        player?.isMuted = true
        player = nil
        playerViewController?.player = nil
        playerViewController?.view.removeFromSuperview()
        playerViewController?.removeFromParent()
       // DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Create a new AVPlayer instance
            self.player = AVPlayer(url: url)
           // self.player?.rate = 1 // Auto play
            //self.player?.isMuted = false
            // Create a new AVPlayerViewController instance
            self.playerViewController = AVPlayerViewController()
            self.playerViewController?.player = self.player
            self.playerViewController?.view.frame = self.view.bounds
            self.playerViewController?.showsPlaybackControls = true
            
            // Add as a child view controller
            if let playerVC = self.playerViewController {
                self.addChild(playerVC)
                self.view.addSubview(playerVC.view)
                playerVC.didMove(toParent: self)
            }
        //}
    }
}

