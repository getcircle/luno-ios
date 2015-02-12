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
        registerNotifications()
    }
    
    deinit {
        unregisterNotifications()
    }

    private func configureTabBar() {
    
        var tabBarViewControllers = [UIViewController]()
        
        // Home Tab
        let searchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as SearchViewController
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let homeTabImage = UIImage(named: "Home")?.imageWithRenderingMode(.AlwaysTemplate)
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: homeTabImage,
            selectedImage: homeTabImage
        )
        tabBarViewControllers.append(searchNavigationController)


        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            
            // Organization Tab
            let orgVC = OrganizationDetailViewController()
            (orgVC.dataSource as OrganizationDetailDataSource).selectedOrgId = loggedInUserProfile.organization_id
            let navController = UINavigationController(rootViewController: orgVC)
            // Images for the organization tab
            let orgTabImage = UIImage(named: "Building")?.imageWithRenderingMode(.AlwaysTemplate)
            navController.tabBarItem = UITabBarItem(
                title: "",
                image: orgTabImage,
                selectedImage: orgTabImage
            )
            tabBarViewControllers.append(navController)
            
            
            // Profile Tab
            let profileViewController = ProfileDetailsViewController.forProfile(
                loggedInUserProfile,
                showLogOutButton: false,
                showCloseButton: false
            )
            
            let profileNavController = UINavigationController(rootViewController: profileViewController)
            let profileTabImage = UIImage(named: "Profile")?.imageWithRenderingMode(.AlwaysTemplate)
            profileNavController.tabBarItem = UITabBarItem(
                title: "",
                image: profileTabImage,
                selectedImage: profileTabImage
            )
            tabBarViewControllers.append(profileNavController)
        }
        
        setViewControllers(tabBarViewControllers, animated: true)
        addTabsForAuthenticatedUser()
    }
    
    func addTabsForAuthenticatedUser() {
        var tabBarViewControllers = viewControllers ?? [UIViewController]()
        
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            
            if tabBarViewControllers.count == 1 {
                // Organization Tab
                let orgVC = OrganizationDetailViewController()
                (orgVC.dataSource as OrganizationDetailDataSource).selectedOrgId = loggedInUserProfile.organization_id
                let navController = UINavigationController(rootViewController: orgVC)
                let orgTabImage = UIImage(named: "Building")?.imageWithRenderingMode(.AlwaysTemplate)
                navController.tabBarItem = UITabBarItem(
                    title: "",
                    image: orgTabImage,
                    selectedImage: orgTabImage
                )
                tabBarViewControllers.append(navController)
                
                // Profile Tab
                let profileViewController = ProfileDetailsViewController.forProfile(
                    loggedInUserProfile,
                    showLogOutButton: false,
                    showCloseButton: false
                )
                
                let profileNavController = UINavigationController(rootViewController: profileViewController)
                let profileTabImage = UIImage(named: "Profile")?.imageWithRenderingMode(.AlwaysTemplate)
                profileNavController.tabBarItem = UITabBarItem(
                    title: "",
                    image: profileTabImage,
                    selectedImage: profileTabImage
                )
                tabBarViewControllers.append(profileNavController)
                
                setViewControllers(tabBarViewControllers, animated: true)
            }
        }
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "addTabsForAuthenticatedUser", 
            name: AuthNotifications.onLoginNotification, 
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
