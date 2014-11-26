//
//  MainTabViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addSelectedImages()
        self.tabBar.tintColor = UIColor.tabBarTintColor()
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
}
