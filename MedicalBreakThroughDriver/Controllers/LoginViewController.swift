//
//  LoginViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 30/01/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailerrorLbl: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.customizeTextField(cornerRadius: 20.0,
                                   borderColor: .white,
                                     borderWidth: 1.0,
                                     placeholderColor: .lightGray,
                                     leftPadding: 10,
                                     rightPadding: 5)
        passwordTF.customizeTextField(cornerRadius: 20.0,
                                      borderColor: .white,
                                     borderWidth: 1.0,
                                     placeholderColor: .lightGray,
                                     leftPadding: 10,
                                     rightPadding: 5)
        emailTF.text = "mylesinstallation@medicalbreakthrough.com"
        passwordTF.text = "apple@123"
    }
    
    @IBAction func signInBtnAct(_ sender: UIButton) {
        self.view.endEditing(true)
        emailerrorLbl.text = "Please enter email"
        passwordErrorLbl.text = "Please enter password"
        self.emailerrorLbl?.isHidden = self.emailTF?.text != "" ? true : false
        self.passwordErrorLbl?.isHidden = self.passwordTF?.text != "" ? true : false
        if (self.emailTF?.text!.isValidEmail() == false) {
            self.emailerrorLbl?.isHidden = false
            self.emailerrorLbl?.text = "  Please enter valid email"
            return
        } else {
            if self.emailTF?.text != "" && self.passwordTF?.text != "" {
        if APIModel.isConnectedToNetwork() {
                    self.loginAPICall()
                } else {
                showToast(message: "Please check internet connection")
                }
            }
        }
    }
    
    @IBAction func forgotPasswordBtnAct(_ sender: UIButton) {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func loginAPICall(){
        let loginParams = LoginRequestModel(email: self.emailTF?.text ?? "", password: self.passwordTF?.text ?? "")
        debugPrint(loginParams,"loginParams")
        LoaderView.shared.showLoader(in: self.view)
        APIModel.postRequest(strURL: LOGIN_URL as NSString, postParams: loginParams, postHeaders: ["":""]) { result in
            let loginResponse = try? JSONDecoder().decode(LoginResponseModel.self, from: result as! Data)
            if loginResponse?.status == 200{
                UserDefaults.standard.setValue(loginResponse?.data?.accessToken ?? "", forKey: k_token)
                headers.updateValue("Bearer " + (loginResponse?.data?.accessToken ?? ""), forKey: "Authorization")
                debugPrint(headers,"headerss")
                PersistenceStorage.sharedInstance.loginResponseData = loginResponse?.data
                LoaderView.shared.hideLoader()
                self.navigateToSummary()
            }
             else {
                LoaderView.shared.hideLoader()
                 self.showToast(message: (loginResponse?.message ?? ""))
            }
        } failureHandler: { error in
            debugPrint(error)
            self.showToast(message:error)
            LoaderView.shared.hideLoader()
        }
    }
    func navigateToHome() {
        let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    func navigateToSummary() {
        let vc = MAIN.instantiateViewController(withIdentifier: "SummaryPageViewController") as! SummaryPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - LoginRequestModel
struct LoginRequestModel: Encodable {
    let email, password: String?
}
// MARK: - LoginResponseModel
struct LoginResponseModel: Codable {
    let message : String?
    let status : Int?
    let data : LoginResponseDataModel?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case status = "status"
        case data = "data"
    }
}
struct LoginResponseDataModel: Codable {
    let accessToken : String?
   
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
