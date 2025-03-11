//
//  SummaryPageViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/02/25.
//

import UIKit
import CoreLocation
import AppTrackingTransparency

class SummaryPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileDataApiCall()
        self.requestTrackingPermission()
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
    @IBAction func privacyPolicyBtnAct(_ sender: UIButton) {
        let vc = PrivacyPolicyViewController()
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
extension SummaryPageViewController {
    func showTrackingPermissionPopup() {
        let alert = UIAlertController(
            title: "Privacy Notice",
            message: "We use your data to improve your experience. Please allow tracking.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
            self.requestTrackingPermission()
        })

        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: nil))

        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true)
        }
    }
    func requestTrackingPermission() {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorized")
                case .denied, .restricted, .notDetermined:
                    print("Tracking denied")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.showTrackingDeniedAlert()
                    }
                @unknown default:
                    print("Unknown status")
                }
            }
        }
    func showTrackingDeniedAlert() {
        let alert = UIAlertController(
            title: "Tracking Permission Denied",
            message: "You have denied tracking permission. If you change your mind, you can enable it in Settings.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            self.openAppSettings()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true)
        }
    }
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
