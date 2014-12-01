//
//  MainTabViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        addSelectedImages()
        self.tabBar.tintColor = UIColor.tabBarTintColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAndPresentAuthViewController()
    }
    
    private func addSelectedImages() {
        let tabBarItemsCount = self.tabBar.items?.count
        for index in 0..<tabBarItemsCount! {
        
            let tabBarItem = self.tabBar.items?[index] as UITabBarItem
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
                profileVC.person = AuthViewController.getLoggedInPerson()
                profileVC.showLogOutButton = true
            }
        }
        
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        checkUserAndPresentAuthViewController()
    }
    
    // MARK - Authentication Check
    
    // Check if user is logged in. If not, present auth view controller
    private func checkUserAndPresentAuthViewController() {
        var currentUser = PFUser.currentUser()
        if currentUser == nil {
            AuthViewController.presentAuthViewController()
        }
    }
}
