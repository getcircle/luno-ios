//
//  MainTabViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit
import Parse

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // MARK - Tab bar delegate
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        checkUserAndPresentAuthViewController()
    }
    
    private func checkUserAndPresentAuthViewController() {
        var currentUser = PFUser.currentUser()
        println("User = \(currentUser)")
        if currentUser == nil {
            // Check if user is logged in. If not, present auth view controller
            let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
            let navController = UINavigationController(rootViewController: authViewController)
            self.presentViewController(navController, animated: false, completion: nil)
        }
    }
}
