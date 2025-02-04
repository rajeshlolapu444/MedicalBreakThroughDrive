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
                PersistenceStorage.sharedInstance.driverProfileData = loginResponse?.data
                LoaderView.shared.hideLoader()
                self.navigateToHome()
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
    let driver: DriverProfileModel?
   
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case driver
    }
}

// MARK: - Driver
struct DriverProfileModel: Codable {
    let id: Int?
    let firstName, lastName, email, name: String?
    let rating, countryCode, phone, profileImage: String?
    let companyLogo, city, state, address: String?
    let country, postalCode, gender, dateOfBirth: String?
    let firebaseToken, nickName, storeName, storeUserName: String?
    let reviewsCount: Int?
    let totalLikes, accountType: String?
    let isVerified: Bool?
    let premiumType, buyerMembership, saunaMembership, memberSince: String?
    let isAdmin: Bool?
   // let store: JSONNull?
    let department: Department?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, name, rating
        case countryCode = "country_code"
        case phone
        case profileImage = "profile_image"
        case companyLogo = "company_logo"
        case city, state, address, country
        case postalCode = "postal_code"
        case gender
        case dateOfBirth = "date_of_birth"
        case firebaseToken = "firebase_token"
        case nickName = "nick_name"
        case storeName = "store_name"
        case storeUserName = "store_user_name"
        case reviewsCount = "reviews_count"
        case totalLikes = "total_likes"
        case accountType = "account_type"
        case isVerified = "is_verified"
        case premiumType = "premium_type"
        case buyerMembership = "buyer_membership"
        case saunaMembership = "sauna_membership"
        case memberSince = "member_since"
        case isAdmin = "is_admin"
        case department
    }
}

// MARK: - Department
struct Department: Codable {
    let id: Int?
    let name, aliasName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case aliasName = "alias_name"
    }
}
