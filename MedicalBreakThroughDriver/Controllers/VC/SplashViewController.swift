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
        let driverId = PersistenceStorage.sharedInstance.driverProfileData?.id ?? 0
        debugPrint(driverId,"driverId")
        if driverId != 0 {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.navigateToSummary()
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                let homeVC = MAIN.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
    func navigateToSummary() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let homeVC = storyboard.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
        let nav = UINavigationController(rootViewController: homeVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        }else{
            if #available(iOS 15.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    keyWindow.rootViewController = nav
                    keyWindow.makeKeyAndVisible()
                }
            } else {
                UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = nav
                UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.makeKeyAndVisible()
            }
        }
    }
}

