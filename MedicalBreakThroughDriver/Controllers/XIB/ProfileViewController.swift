//
//  ProfileViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
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
