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
        self.phoneNumberTF.text = data?.phone
        profileImgView.setImage(from: data?.profileImage ?? "")
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
