//
//  SignupViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/03/25.
//

import UIKit
import SROTPView

class SignupViewController: UIViewController {
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var otpView: SROTPView?
    @IBOutlet weak var oneStack: UIStackView!
    @IBOutlet weak var twoStack: UIStackView!
    @IBOutlet weak var lblOtpTitle: UILabel!
    @IBOutlet weak var resendSecLbl: UILabel!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    // MARK: - Variables
    var counter = 60
    var timer = Timer()
    var otpvalue = ""
    var emailModel: SignupEmailRequestModel?
    var verifyOtpRequestModel : SignupVerifyOtpRequestModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStackViews(stackView: oneStack)
        self.submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        self.resendOtpBtn.addTarget(self, action: #selector(self.otpResendSendtoEmailAPI), for: .touchUpInside)
        self.doneBtn.addTarget(self, action: #selector(self.verifiedOtpApiCall), for: .touchUpInside)
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func setupStackViews(stackView: UIStackView) {
        oneStack.isHidden = true
        twoStack.isHidden = true
        stackView.isHidden = false
        self.titleLbl.text =
        (stackView == twoStack) ? "Verify OTP" :
                             "Sign Up"
    }
    func fieldsValidation() -> Bool {
        let firstName = firstNameTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let lastName = lastNameTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let phoneNumber = phoneNumberTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let email = emailTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let password = passwordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let confirmPassword = confirmPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        if firstName.isEmpty {
            self.showToast(message: "Please enter first name")
            return false
        }
        if email.isEmpty {
            self.showToast(message: "Please enter email")
            return false
        }
        let emailValid = LoginViewModel.shared.isValidEmail(email)
        if !emailValid {
            self.showToast(message: "Please enter valid email")
            return false
        }
        if password.isEmpty {
            self.showToast(message: "Please enter password.")
            return false
        }
        if confirmPassword.isEmpty {
            self.showToast(message: "Please enter confirm password.")
            return false
        }
        if password != confirmPassword {
            self.showToast(message: "Password and confirm password does not match.")
            return false
        }
        emailModel = SignupEmailRequestModel(email: email)
        verifyOtpRequestModel = SignupVerifyOtpRequestModel(first_name: firstName, last_name: lastName, email: email, mobile_number: Int(phoneNumber), password: password, otp: 0)
        return true
    }
    @objc func submit() {
        debugPrint(fieldsValidation(), "fieldsValidation")
        let params = SignupEmailRequestModel(email: emailModel?.email)
        if fieldsValidation() {
            LoaderView.shared.showLoader(in: self.view)
            SignupViewModel.shared.signupEmailAPICall(params: params) { status, msg in
                LoaderView.shared.hideLoader()
                self.showToast(message: msg ?? "")
                if status {
                    self.setupOTPView()
                    self.setupStackViews(stackView: self.twoStack)
                    self.InitConfig()
                }
            }
        }
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
    @objc func otpResendSendtoEmailAPI() {
        let params = SignupEmailRequestModel(email: emailModel?.email)
        LoaderView.shared.showLoader(in: self.view)
        SignupViewModel.shared.signupEmailAPICall(params: params) { status, msg in
            LoaderView.shared.hideLoader()
            self.showToast(message: msg ?? "")
            if status {
                self.setupStackViews(stackView: self.twoStack)
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
            let params = SignupVerifyOtpRequestModel(first_name: verifyOtpRequestModel?.first_name,
                                                     last_name: verifyOtpRequestModel?.last_name, email: verifyOtpRequestModel?.email, mobile_number: verifyOtpRequestModel?.mobile_number, password: verifyOtpRequestModel?.password, otp: Int(otpvalue))
            debugPrint(params,"params")
            SignupViewModel.shared.signupVerifyOtpAPICall(params: params) { status, msg in
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
