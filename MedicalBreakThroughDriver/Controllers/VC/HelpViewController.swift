//
//  HelpViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var helpTextLbl: UILabel!
    
    let firstText = "If you need help please call us at"
    let secondText = " 818-263-9698"
    let thirdText = ", we are here to help. \nThank you."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Combine all text into a single string
        let fullText = firstText + secondText + thirdText
        let attributedString = NSMutableAttributedString(string: fullText)
        // Define attributes for `secondText`
        let secondTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),  // Change font
            .foregroundColor: UIColor.red             // Change text color
        ]
        
        // Find the range of `secondText` in `fullText`
        if let range = fullText.range(of: secondText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes(secondTextAttributes, range: nsRange)
        }
        
        helpTextLbl.attributedText = attributedString
        
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

