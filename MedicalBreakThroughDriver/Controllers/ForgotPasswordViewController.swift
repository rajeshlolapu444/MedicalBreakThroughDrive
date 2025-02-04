//
//  ForgotPasswordViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var newPassWordTF: UITextField!
    @IBOutlet weak var confirmPassWordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        newPassWordTF.customizeTextField(cornerRadius: 20.0,
                                   borderColor: .lightGray,
                                     borderWidth: 1.0,
                                     placeholderColor: .lightGray,
                                     leftPadding: 10,
                                     rightPadding: 5)
        confirmPassWordTF.customizeTextField(cornerRadius: 20.0,
                                      borderColor: .lightGray,
                                     borderWidth: 1.0,
                                     placeholderColor: .lightGray,
                                     leftPadding: 10,
                                     rightPadding: 5)

    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        let vc = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
