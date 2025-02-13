//
//  Enum.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 04/02/25.
//

import Foundation
import UIKit

enum DeliveryStatus: String {
    //case accepted = "accepted"
    //case started = "started"
    case delivered = "delivered"
   // case finished = "finished"
    case rejected = "rejected"
    case none
}
enum MediaType {
    case image
    case video
} 

enum OrdersType {
    case Active
    case Past
}

extension UIViewController {
    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        guard let navigationController = self.navigationController else { return }
        
        for vc in navigationController.viewControllers {
            if vc is T {
                navigationController.popToViewController(vc, animated: animated)
                return
            }
        }
        print("\(T.self) is not in the navigation stack")
    }
    func popOrPushToXibViewController<T: UIViewController>(ofType type: T.Type, animated: Bool = true, createInstance: @escaping () -> T) {
        guard let navigationController = self.navigationController else {
            print("Navigation controller is nil")
            return
        }
        
        for vc in navigationController.viewControllers {
            if vc is T {
                navigationController.popToViewController(vc, animated: animated)
                return
            }
        }
        
        // If not found, push a new instance
        let newVC = createInstance()
        navigationController.pushViewController(newVC, animated: animated)
    }
    func popOrPushToViewController<T: UIViewController>(ofType type: T.Type, storyboardName: String = "Main", animated: Bool = true) {
        guard let navigationController = self.navigationController else {
            print("Navigation controller is nil")
            return
        }
        
        // Check if the view controller already exists in the navigation stack
        for vc in navigationController.viewControllers {
            if vc is T {
                navigationController.popToViewController(vc, animated: animated)
                return
            }
        }
        
        // If not found, load it from the storyboard and push it
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let newVC = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            navigationController.pushViewController(newVC, animated: animated)
        } else {
            print("Failed to instantiate \(T.self) from storyboard \(storyboardName)")
        }
    }
}
