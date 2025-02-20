//
//  ForgotPasswordViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    var emailStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        emailTF.customizeTextField(cornerRadius: 20.0,
//                                   borderColor: .lightGray,
//                                   borderWidth: 1.0,
//                                   placeholderColor: .lightGray,
//                                   leftPadding: 10,
//                                   rightPadding: 5)
        self.emailTF.text = emailStr
        
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAct(_ sender: UIButton) {
        if emailTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter email")
            return
        } else {
            if !isValidEmail(emailTF.text ?? "") {
                self.showToast(message: "Please enter valid email")
                return
            } else {
                let param = ForgotPasswordRequestModel(email: emailTF.text ?? "")
                LoginViewModel.shared.forgotPasswordAPICall(params: param) { status, msg in
                    self.showToast(message: msg ?? "")
                    if status {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmedEmail)
    }
}
