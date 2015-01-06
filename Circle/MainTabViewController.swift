//
//  MainTabViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        addSelectedImages()
        tabBar.tintColor = UIColor.tabBarTintColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAndPresentAuthViewController()
    }
    
    private func addSelectedImages() {
        let tabBarItemsCount = tabBar.items?.count
        for index in 0..<tabBarItemsCount! {
        
            let tabBarItem = tabBar.items?[index] as UITabBarItem
            switch index {
            case 0:
                tabBarItem.selectedImage = UIImage(named: "PeopleSelected")
            case 1:
                tabBarItem.selectedImage = UIImage(named: "MessagesSelected")
            case 2:
                tabBarItem.selectedImage = UIImage(named: "ProfileSelected")
            default:
                break
            }
        }
    }
    
    // MARK - Tab bar controller delegate
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController is UINavigationController {
            if (viewController as UINavigationController).topViewController is ProfileViewController {
                var profileVC = (viewController as UINavigationController).topViewController as ProfileViewController
//                profileVC.person = AuthViewController.getLoggedInUser()
                profileVC.showLogOutButton = true
            }
        }
        
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        checkUserAndPresentAuthViewController()
    }

}
