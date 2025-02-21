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
    @IBOutlet weak var otpStackView: UIStackView!
    
    @IBOutlet weak var registerEmailTF: UITextField!
    
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var otpConfirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTF.text = emailStr
        self.registerEmailTF.text = emailStr
        emailStackView.isHidden = false
        otpStackView.isHidden = true
        self.otpConfirmBtn.addTarget(self, action: #selector(self.otpConfirmApiCall), for: .touchUpInside)
        otpTF.keyboardType = .numberPad
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
                        self.otpStackView.isHidden = false
                        
                    }
                }
            }
        }
    }
    @objc func otpConfirmApiCall() {
        let emailValid = LoginViewModel.shared.isValidEmail(emailTF.text ?? "")
        if registerEmailTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter registered email")
            return
        } else if !emailValid {
            self.showToast(message: "Please enter valid email")
            return
        } else if otpTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter OTP")
            return
        } else if otpTF.text?.count != 6 {
            self.showToast(message: "Please enter 6 digits OTP")
            return
        } else if newPasswordTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter new password.")
            return
        } else if confirmPasswordTF.text?.isEmpty ?? true {
            self.showToast(message: "Please enter confirm password.")
            return
        } else if newPasswordTF.text != confirmPasswordTF.text {
            self.showToast(message: "New password and confirm password does not match.")
            return
        } else {
            let emailStr = registerEmailTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let OtpStr = otpTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let newPassword = newPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let confirmPassword = confirmPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
            LoaderView.shared.showLoader(in: self.view)
            let params = OTPRequestModel(email: emailStr, otp: OtpStr, password: newPassword, password_confirmation: confirmPassword)
            LoginViewModel.shared.otpConfirmAPICall(params: params) { status, msg in
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
                if status {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
