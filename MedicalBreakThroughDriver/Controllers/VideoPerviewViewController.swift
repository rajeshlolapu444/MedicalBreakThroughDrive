//
//  VideoPerviewViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 07/02/25.
//

import UIKit
import AVKit

class VideoPerviewViewController: UIViewController {
    @IBOutlet weak var viewVideoPlyer: UIView!
    
    @IBOutlet weak var previewImg: UIImageView!
    //MARK: - Variable
    var player: AVPlayer?
    var selectedVideoURL:String?
    var selectedVideoComment:String?

    var mediaData : MediaItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mediaData?.type == .video {
            self.videoPreview()
        } else {
            self.imagePreview()
        }
        
    }
    
    func videoPreview() {
        previewImg.isHidden = true
        viewVideoPlyer.isHidden = false
        let url = URL.init(string: mediaData?.url.absoluteString ?? "")
        player = AVPlayer(url: url!)
        player?.rate = 1 //auto play
        let playerFrame = CGRect(x: 0, y: 0, width: viewVideoPlyer.bounds.width, height: viewVideoPlyer.bounds.height)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = playerFrame
        playerViewController.showsPlaybackControls = true
        
        addChild(playerViewController)
        viewVideoPlyer.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)

    }
    func imagePreview() {
        previewImg.isHidden = false
        viewVideoPlyer.isHidden = true
        previewImg.image = UIImage(contentsOfFile: mediaData?.url.path ?? "")
    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
