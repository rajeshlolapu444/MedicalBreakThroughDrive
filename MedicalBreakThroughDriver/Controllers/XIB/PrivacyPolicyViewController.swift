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
        if let url = URL(string: "https://www.medicalbreakthrough.com/driver-privacypolicy.html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    private func loadHTMLFile() {
        guard let fileURL = Bundle.main.url(forResource: PrivacyPolicy, withExtension: "html") else {
            print("HTML file not found")
            return
        }
        
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
    }
    //    private func loadRTFFile() {
    //        guard let fileURL = Bundle.main.url(forResource: "privacy-policy", withExtension: "html") else {
    //            print("File not found")
    //            return
    //        }
    //
    //        do {
    //            let attributedString = try NSAttributedString(
    //                url: fileURL,
    //                options: [.documentType: NSAttributedString.DocumentType.html],
    //                documentAttributes: nil
    //            )
    //            textV.attributedText = attributedString
    //        } catch {
    //            print("Failed to load RTF: \(error)")
    //        }
    //    }
}
