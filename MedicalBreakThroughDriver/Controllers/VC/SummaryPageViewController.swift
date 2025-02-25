//
//  SummaryPageViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/02/25.
//

import UIKit
import CoreLocation

class SummaryPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileDataApiCall()
    }
    @IBAction func activeOrdersBtnAct(_ sender: UIButton) {
        let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.topTitle = "Active Orders"
        homeViewController.ordersType = .Active
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func pastOrdersBtnAct(_ sender: UIButton) {
        let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.topTitle = "History"
        homeViewController.ordersType = .Past
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    func navigateToHome() {
        let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func profileBtnAct(_ sender: UIButton) {
        let vc = ProfileViewController()
        vc.isProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
//        popOrPushToXibViewController(ofType: ProfileViewController.self) {
//            return ProfileViewController()
//        }
    }
    @IBAction func routeBtnAct(_ sender: UIButton) {
//        let vc = MAIN.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        vc.isfromSummary = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func helpBtnAct(_ sender: UIButton) {
        let vc = MAIN.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func changePasswordBtnAct(_ sender: UIButton) {
        let vc = ProfileViewController()
        vc.isProfile = false
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func logoutBtnAct(_ sender: UIButton) {
        let coordinates = PersistenceStorage.sharedInstance.currentLocationCoordinates ?? CLLocationCoordinate2D()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        PersistenceStorage.sharedInstance.currentLocationCoordinates = coordinates
        popOrPushToViewController(ofType: LoginViewController.self)
    }
    func profileDataApiCall() {
        ProfileViewModel.shared.getDriverProfileAPI { status, msg in
            if status {
                if let data = PersistenceStorage.sharedInstance.driverProfileData {
                    debugPrint(data, "driverProfileData")
                    LoaderView.shared.hideLoader()
                }
            } else {
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
            }
        }
    }

}
