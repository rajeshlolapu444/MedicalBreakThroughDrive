//
//  SummaryPageViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 05/02/25.
//

import UIKit

class SummaryPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
      //  let vc = DateSelectionViewController()
        let vc = ProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func routeBtnAct(_ sender: UIButton) {
        let vc = MAIN.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.isfromSummary = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func helpBtnAct(_ sender: UIButton) {
        let vc = MAIN.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    //    func navigationTo<T: UIViewController>(identifier: String, type: T.Type) {
    //        if let vc = MAIN.instantiateViewController(withIdentifier: identifier) as? T {
    //            navigationController?.pushViewController(vc, animated: true)
    //        } else {
    //            print("Failed to instantiate view controller with identifier: \(identifier)")
    //        }
    //    }
}
