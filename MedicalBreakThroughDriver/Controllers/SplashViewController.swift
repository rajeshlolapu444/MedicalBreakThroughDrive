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
        let rs = UserDefaults.standard.string(forKey: "rajesh")
        debugPrint(rs ?? ",","rs")
        if rs == "rs" {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
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

