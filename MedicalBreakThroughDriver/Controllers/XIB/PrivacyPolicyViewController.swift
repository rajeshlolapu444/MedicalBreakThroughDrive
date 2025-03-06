//
//  PrivacyPolicyViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/03/25.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var textV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRTFFile()
        
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)

    }
    private func loadRTFFile() {
        guard let fileURL = Bundle.main.url(forResource: "Driver APP - Privacy Policy", withExtension: "html") else {
            print("File not found")
            return
        }
        
        do {
            let attributedString = try NSAttributedString(
                url: fileURL,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
            textV.attributedText = attributedString
        } catch {
            print("Failed to load RTF: \(error)")
        }
    }
}
