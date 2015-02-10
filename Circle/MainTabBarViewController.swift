//
//  MainTabBarViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTabBar() {
    
        var tabBarViewControllers = viewControllers ?? [UIViewController]()
        
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            let orgVC = OrganizationDetailViewController()
            (orgVC.dataSource as OrganizationDetailDataSource).selectedOrgId = loggedInUserProfile.organization_id
            let navController = UINavigationController(rootViewController: orgVC)
            // Images for the organization tab
            let orgTabImage = UIImage(named: "Building")?.imageWithRenderingMode(.AlwaysTemplate)
            let orgTabImageSelected = UIImage(named: "BuildingFilled")?.imageWithRenderingMode(.AlwaysTemplate)
            navController.tabBarItem = UITabBarItem(title: "Eventbrite", image: orgTabImage, selectedImage: orgTabImageSelected)
            tabBarViewControllers.append(navController)
            
            let profileViewController = ProfileDetailsViewController.forProfile(
                loggedInUserProfile,
                showLogOutButton: false,
                showCloseButton: false
            )
            
            let profileNavController = UINavigationController(rootViewController: profileViewController)
            let profileTabImage = UIImage(named: "Profile")?.imageWithRenderingMode(.AlwaysTemplate)
            let profileTabImageSelected = UIImage(named: "ProfileFilled")?.imageWithRenderingMode(.AlwaysTemplate)
            profileNavController.tabBarItem = UITabBarItem(
                title: "You",
                image: profileTabImage,
                selectedImage: profileTabImageSelected
            )
            tabBarViewControllers.append(profileNavController)
        }
        
        setViewControllers(tabBarViewControllers, animated: true)
        (tabBar.items!.first! as UITabBarItem).image = UIImage(named: "Home")?.imageWithRenderingMode(.AlwaysTemplate)
        (tabBar.items!.first! as UITabBarItem).selectedImage = UIImage(named: "HomeFilled")?.imageWithRenderingMode(.AlwaysTemplate)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
