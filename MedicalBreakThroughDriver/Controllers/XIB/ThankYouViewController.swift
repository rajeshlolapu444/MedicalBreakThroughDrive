//
//  ThankYouViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 17/02/25.
//

import UIKit

class ThankYouViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.imgView.layer.cornerRadius = 120
//        self.imgView.clipsToBounds = true
//        self.imgView.layer.borderWidth = 2
//        self.imgView.layer.borderColor = UIColor.darkGray.cgColor
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func homeBtn(_ sender: UIButton) {
        popOrPushToViewController(ofType: HomeViewController.self)
    }

}
