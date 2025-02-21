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

    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

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
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }
        player?.play()
    }
}

