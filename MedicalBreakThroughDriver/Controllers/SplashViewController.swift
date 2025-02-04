//
//  ViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let driverId = PersistenceStorage.sharedInstance.driverProfileData?.driver?.id ?? 0
        debugPrint(driverId,"driverId")
        if driverId != 0 {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                let homeVC = MAIN.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
}

