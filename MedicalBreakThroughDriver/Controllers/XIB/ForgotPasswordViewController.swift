//
//  ForgotPasswordViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 03/02/25.
//

import UIKit
import SROTPView

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var otpStackView: UIStackView!
    @IBOutlet weak var newPasswordStackView: UIStackView!
    @IBOutlet weak var lblOtpTitle: UILabel!
    @IBOutlet weak var resendSecLbl: UILabel!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var otpView: SROTPView?
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var newPasswordSubmitBtn: UIButton!
    // MARK: - Variables
    var counter = 60
    var timer = Timer()
    var emailStr: String?
    var otpvalue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViews(stackView: emailStackView)
        self.emailTF.text = emailStr
        self.btnNext.addTarget(self, action: #selector(self.verifiedOtpApiCall), for: .touchUpInside)
        self.resendOtpBtn.addTarget(self, action: #selector(self.otpResendSendtoEmailAPI), for: .touchUpInside)
        self.newPasswordSubmitBtn.addTarget(self, action: #selector(self.newPasswordApiCall), for: .touchUpInside)
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        if otpStackView.isHidden == false {
            setupStackViews(stackView: emailStackView)
        } else if emailStackView.isHidden == false {
            setupStackViews(stackView: emailStackView)
            self.navigationController?.popViewController(animated: true)
        } else {
            
        }
        
    }
    
    @IBAction func submitBtnAct(_ sender: UIButton) {
        self.otpSendtoEmailAPI()
    }
    func InitConfig() {
        self.resendSecLbl?.isHidden = false
        self.resendOtpBtn?.isHidden = true
        self.counter = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    @objc func timerAction() {
        counter -= 1
        resendSecLbl?.text = "Resend otp in \(counter) Seconds"
        if counter == 0 {
            self.resendSecLbl?.isHidden = true
            self.resendOtpBtn?.isHidden = false
            timer.invalidate()
        }
    }
    func setupOTPView() {
        lblOtpTitle?.text = "Enter the Code sent to \n\(emailTF.text ?? "")"
        otpView?.otpTextFieldsCount = 6
        otpView?.otpTextFieldActiveBorderColor = .black
        otpView?.otpTextFieldDefaultBorderColor = UIColor.lightGray
        otpView?.otpTextFieldFontColor = .black
        otpView?.textBackgroundFilledColor = .white
        otpView?.textBackgroundColor = UIColor.white
        otpView?.activeHeight = 2
        otpView?.inactiveHeight = 1
        otpView?.otpType = .Bordered //.Rounded for round
        otpView?.secureEntry = false
        otpView?.otpEnteredString = { pin in
            self.otpvalue = pin
        }
        otpView?.setUpOtpView()
    }
    func setupStackViews(stackView: UIStackView) {
        emailStackView.isHidden = true
        otpStackView.isHidden = true
        newPasswordStackView.isHidden = true
        stackView.isHidden = false
        if stackView == emailStackView || stackView == otpStackView {
            backImgView.isHidden = false
        } else {
            backImgView.isHidden = true
        }
        self.titleLbl.text = (stackView == emailStackView) ? "Forgot Password" :
                             (stackView == otpStackView) ? "Verify OTP" :
                             "New Password"
    }
}

// MARK: - Three steps methods

extension ForgotPasswordViewController {
    @objc func otpSendtoEmailAPI() {
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
                        self.setupOTPView()
                        self.setupStackViews(stackView: self.otpStackView)
                        self.InitConfig()
                    }
                }
            }
        }
    }
    @objc func otpResendSendtoEmailAPI() {
        let param = ForgotPasswordRequestModel(email: emailTF.text ?? "")
        LoaderView.shared.showLoader(in: self.view)
        LoginViewModel.shared.forgotPasswordAPICall(params: param) { status, msg in
            LoaderView.shared.hideLoader()
            self.showToast(message: msg ?? "")
            if status {
                self.setupStackViews(stackView: self.otpStackView)
                self.InitConfig()
            }
        }
    }
    @objc func verifiedOtpApiCall() {
        self.view.endEditing(true)
        if otpvalue == "" {
            showToast(message: "Please enter OTP")
            return
        } else if otpvalue.count != 6 {
            showToast(message: "Please enter 6 digits OTP")
            return
        } else {
            LoaderView.shared.showLoader(in: self.view)
            let params = VerifyOtpRequestModel(email: emailTF.text ?? "", otp: otpvalue)
            debugPrint(params,"params")
            LoginViewModel.shared.verifiedOtpApiCall(params: params) { status, msg in
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
                if status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.setupStackViews(stackView: self.newPasswordStackView)
                    }
                }
            }
        }
    }
    @objc func newPasswordApiCall() {
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
            let params = NewPasswordRequestModel(email: emailTF.text ?? "", password: newPassword, password_confirmation: confirmPassword)
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
