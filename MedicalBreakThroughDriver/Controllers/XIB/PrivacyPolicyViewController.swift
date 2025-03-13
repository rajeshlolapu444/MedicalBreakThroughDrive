//
//  PrivacyPolicyViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/03/25.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
   // @IBOutlet weak var textV: UITextView!
    
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fixedFrame = CGRect(x: 0, y: 0, width:containerView.frame.width - 10, height:containerView.frame.height)
        webView = WKWebView(frame: fixedFrame)
        containerView.addSubview(webView)
        if let url = URL(string: "https://medicalbreakthrough.com/pages/driver-privacypolicy") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
