//
//  ProfileViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var changePasswordStackView: UIStackView!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    var isProfile = false
    
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        if isProfile {
            profileStackView.isHidden = false
            changePasswordStackView.isHidden = true
            self.titleLbl.text = "Profile"
        } else {
            profileStackView.isHidden = true
            changePasswordStackView.isHidden = false
            self.titleLbl.text = "Change Password"
        }
    }
    func setupData() {
        let data = PersistenceStorage.sharedInstance.driverProfileData
        self.firstNameTF.text = data?.firstName
        self.lastNameTF.text = data?.lastName
        self.emailTF.text = data?.email
        if data?.phone == "" || data?.phone == nil {
            self.phoneNumberTF.text = "N/A"
        } else {
            let usFormate = formatPhoneNumberUSA(data?.phone ?? "")
            self.phoneNumberTF.text = usFormate
        }
        profileImgView.setImage(from: data?.profileImage ?? "")
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changePasswordBtnAct(_ sender: UIButton) {
        self.changePasswordAPiCall()
    }
}

extension ProfileViewController {
    func changePasswordAPiCall() {
        if oldPasswordTF.text == "" {
            self.showToast(message: "Please enter old password.")
            return
        } else if newPasswordTF.text == "" {
            self.showToast(message: "Please enter new password.")
            return
        } else if confirmPasswordTF.text == ""{
            self.showToast(message: "Please enter confirm password.")
            return
        } else {
            if newPasswordTF.text != confirmPasswordTF.text {
                self.showToast(message: "New password and confirm password does not match.")
                return
            }
        }
        let oldPassword = oldPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let newPassword = newPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let confirmPassword = confirmPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        LoaderView.shared.showLoader(in: self.view)
        let params = ChangePasswordRequestModel(old_password: oldPassword, new_password: newPassword, new_password_confirmation: confirmPassword)
        ProfileViewModel.shared.changePasswordAPICall(params: params) { status, msg in
            LoaderView.shared.hideLoader()
            self.showToast(message: msg ?? "")
            if status {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.popOrPushToViewController(ofType: LoginViewController.self)
                }
            }
        }
    }
}
