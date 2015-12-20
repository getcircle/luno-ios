//
//  MainTabBarViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    let tabBarItemImageInset = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0)

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
        tabBar.backgroundColor = UIColor.appViewBackgroundColor()
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).CGPath
        tabBar.layer.shadowRadius = 4.0
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.frame = tabBar.bounds
        tabBar.addSubview(blurView)
        
        delegate = self
        var tabBarViewControllers = [UIViewController]()

        // Search Tab
        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let searchTabImage = UIImage(named: "search_tab_bar")
        let searchTabImageDefault = searchTabImage?
            .imageWithTintColor(UIColor.appTabBarDeselectedTintColor(), scale: UIScreen.mainScreen().scale)
            .imageWithRenderingMode(.AlwaysOriginal)
        let searchTabImageSelected = searchTabImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: searchTabImageDefault,
            selectedImage: searchTabImageSelected
        )
        searchNavigationController.tabBarItem.imageInsets = tabBarItemImageInset
        tabBarViewControllers.append(searchNavigationController)

        setViewControllers(tabBarViewControllers, animated: true)
        addTabsForAuthenticatedUserAndSelectProfileTab(false)
    }

    private func addTabsForAuthenticatedUserAndSelectProfileTab(selectProfileTab: Bool) {
        var tabBarViewControllers = viewControllers ?? [UIViewController]()

        if let loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile() {
            // Reloading tabs
            // Keep only the first one and re-add organization & profile tabs
            // This allows us to switch between organizations easily.
            tabBarViewControllers = [tabBarViewControllers[0]]

            // Profile Tab
            let profileViewController = CurrentUserProfileDetailViewController.forProfile(
                loggedInUserProfile,
                showSettingsButton: true
            )

            let profileNavController = UINavigationController(rootViewController: profileViewController)
            let profileTabImage = UIImage(named: "profile_tab_bar")
            let profileTabImageDefault = profileTabImage?
                .imageWithTintColor(UIColor.appTabBarDeselectedTintColor(), scale: UIScreen.mainScreen().scale)
                .imageWithRenderingMode(.AlwaysOriginal)
            let profileTabImageSelected = profileTabImage?.imageWithRenderingMode(.AlwaysTemplate)
            profileNavController.tabBarItem = UITabBarItem(
                title: "",
                image: profileTabImageDefault,
                selectedImage: profileTabImageSelected
            )
            profileNavController.tabBarItem.imageInsets = tabBarItemImageInset
            tabBarViewControllers.append(profileNavController)
            setViewControllers(tabBarViewControllers, animated: true)
        }
    }

    @objc private func didLogin() {
        addTabsForAuthenticatedUserAndSelectProfileTab(true)
    }
    
    // MARK: - Notifications

    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didLogin",
            name: AuthenticationNotifications.onLoginNotification,
            object: nil
        )
    }

    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        // Refresh data for selected view controllers
        if let actualViewController = getActualViewController(viewController) {
            if actualViewController is CurrentUserProfileDetailViewController {
                (actualViewController as! CurrentUserProfileDetailViewController).loadData()
            }
            else if actualViewController is SearchViewController {
                // See explanation of why this is here and only for SearchViewController
                // in the Tracker class
                Tracker.sharedInstance.trackPageView(pageType: .Home)
            }
        }
        return true
    }

    private func getActualViewController(viewController: UIViewController?) -> UIViewController? {
        var activeViewController: UIViewController?
        if let navigationController = viewController as? UINavigationController {
            activeViewController = navigationController.viewControllers.first
        } else {
            activeViewController = selectedViewController
        }
        return activeViewController
    }
}
