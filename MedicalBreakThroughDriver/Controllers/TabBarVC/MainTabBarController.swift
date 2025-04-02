//
//  MainTabBarController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 02/04/25.
//

import UIKit

class MainTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    var isFrom = ""
    var selectedTabb = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.delegate = self
        
        
        // Ensure viewControllers array exists
        var currentViewControllers = self.viewControllers ?? []
        
        // Check if the ProfileViewController is already added
        let isProfileVCAdded = currentViewControllers.contains { $0 is ProfileViewController }
        if !isProfileVCAdded {
            let thirdVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            thirdVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile_un"), tag: 3)
            currentViewControllers.append(thirdVC)
            self.viewControllers = currentViewControllers
        }
        
        // Set text color for tab bar items
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                item.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            }
        }
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        self.selectedIndex = selectedTabb
        
        // Update tab bar icons
        if let tabItems = tabBar.items, tabItems.count > 3 {
            setupTabBarItem(tabItems[0], imageName: "home_un", selectedImageName: "home_select", title: "Home")
            setupTabBarItem(tabItems[1], imageName: "active_un", selectedImageName: "active_select", title: "Active Orders")
            setupTabBarItem(tabItems[2], imageName: "history_un", selectedImageName: "history_Select", title: "Past Orders")
            setupTabBarItem(tabItems[3], imageName: "profile_un", selectedImageName: "profile_select", title: "Profile")
        }
    }

    // Helper function to resize and set tab bar icons
    private func setupTabBarItem(_ item: UITabBarItem, imageName: String, selectedImageName: String, title: String) {
        item.image = resizeImage(named: imageName, width: 25, height: 25)?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = resizeImage(named: selectedImageName, width: 25, height: 25)?.withRenderingMode(.alwaysOriginal)
        item.title = title
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
//        if index == 0 {
//            if let homeVC = viewController as? SummaryPageViewController {
//            }
//        }
//        if index == 1 {
//            if let homeVC = viewController as? HomeViewController {
//            }
//        }
        
        if let tabItems = tabBarController.tabBar.items {
            
            setupTabBarItem(tabItems[0], imageName: "home_un", selectedImageName: "home_select", title: "Home")
            setupTabBarItem(tabItems[1], imageName: "active_un", selectedImageName: "active_select", title: "Active Orders")
            setupTabBarItem(tabItems[2], imageName: "history_un", selectedImageName: "history_Select", title: "Past Orders")
            setupTabBarItem(tabItems[3], imageName: "profile_un", selectedImageName: "profile_select", title: "Profile")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item),
           let selectedViewController = viewControllers?[index] {
//            if index == 0 {
//                if let homeVC = selectedViewController as? SummaryPageViewController {
//                }
//            }
            if index == 1 {
                if let activeVC = selectedViewController as? HomeViewController {
                    activeVC.topTitle = "Active Orders"
                    activeVC.ordersType = .Active
                }
            }
            if index == 2 {
                if let historyVC = selectedViewController as? HomeViewController {
                    historyVC.topTitle = "History"
                    historyVC.ordersType = .Past
                }
            }
            if index == 3 {
                if let profileVC = selectedViewController as? ProfileViewController {
                    profileVC.isProfile = true
                }
            }
        }
    }
    func resizeImage(named: String, width: CGFloat, height: CGFloat) -> UIImage? {
        guard let image = UIImage(named: named) else { return nil }
        let newSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

