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
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var newPasswordStackView: UIStackView!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordSubmitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTF.text = emailStr
        emailStackView.isHidden = false
        newPasswordStackView.isHidden = true
        self.newPasswordSubmitBtn.addTarget(self, action: #selector(self.newPasswordApiCall), for: .touchUpInside)
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAct(_ sender: UIButton) {
        if emailTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter registered email")
            return
        } else {
            let emailValid = LoginViewModel.shared.isValidEmail(emailTF.text ?? "")
            if !emailValid {
                self.showToast(message: "Please enter valid email")
                return
            } else {
                let param = ForgotPasswordRequestModel(email: emailTF.text ?? "")
                LoaderView.shared.showLoader(in: self.view)
                LoginViewModel.shared.forgotPasswordAPICall(params: param) { status, msg in
                    LoaderView.shared.hideLoader()
                    self.showToast(message: msg ?? "")
                    if status {
                        self.emailStackView.isHidden = true
                        self.newPasswordStackView.isHidden = false
                        
                    }
                }
            }
        }
    }
    @objc func verifiedPasswordApiCall() {
    }
    @objc func newPasswordApiCall() {
        let emailValid = LoginViewModel.shared.isValidEmail(emailTF.text ?? "")
 
        if newPasswordTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter new password.")
            return
        } else if confirmPasswordTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter confirm password.")
            return
        } else if newPasswordTF.text != confirmPasswordTF.text {
            self.showToast(message: "New password and confirm password does not match.")
            return
        } else {
            let newPassword = newPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let confirmPassword = confirmPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
            LoaderView.shared.showLoader(in: self.view)
            let params = NewPasswordRequestModel(password: newPassword, password_confirmation: confirmPassword)
            LoginViewModel.shared.newPasswordApiCall(params: params) { status, msg in
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
                if status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
