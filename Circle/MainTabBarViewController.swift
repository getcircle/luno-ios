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
        delegate = self
        var tabBarViewControllers = [UIViewController]()

        // Home Tab
        let searchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let homeTabImage = UIImage(named: "Home")
        let homeTabImageDefault = homeTabImage?
            .imageWithTintColor(UIColor.appTabBarDeselectedTintColor(), scale: UIScreen.mainScreen().scale)
            .imageWithRenderingMode(.AlwaysOriginal)
        let homeTabImageSelected = homeTabImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: homeTabImageDefault,
            selectedImage: homeTabImageSelected
        )
        searchNavigationController.tabBarItem.imageInsets = tabBarItemImageInset
        tabBarViewControllers.append(searchNavigationController)

        setViewControllers(tabBarViewControllers, animated: true)
        addTabsForAuthenticatedUser()
    }

    func addTabsForAuthenticatedUser() {
        var tabBarViewControllers = viewControllers ?? [UIViewController]()

        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            // Reloading tabs
            // Keep only the first one and re-add organization & profile tabs
            // This allows us to switch between organizations easily.
            tabBarViewControllers = [tabBarViewControllers[0]]

            // Organization Tab
            let orgVC = OrganizationDetailViewController()
            let navController = UINavigationController(rootViewController: orgVC)

            let orgTabImage = UIImage(named: "Briefcase")
            let orgTabImageDefault = orgTabImage?
                .imageWithTintColor(UIColor.appTabBarDeselectedTintColor(), scale: UIScreen.mainScreen().scale)
                .imageWithRenderingMode(.AlwaysOriginal)
            let orgTabImageSelected = orgTabImage?.imageWithRenderingMode(.AlwaysTemplate)
            let organization = AuthViewController.getLoggedInUserOrganization()!
            navController.tabBarItem = UITabBarItem(
                title: "",
                image: orgTabImageDefault,
                selectedImage: orgTabImageSelected
            )
            navController.tabBarItem.imageInsets = tabBarItemImageInset
            tabBarViewControllers.append(navController)

            // Profile Tab
            let profileViewController = CurrentUserProfileDetailViewController.forProfile(
                loggedInUserProfile,
                showSettingsButton: true
            )

            let profileNavController = UINavigationController(rootViewController: profileViewController)
            let profileTabImage = UIImage(named: "User")
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

    // MARK: - UITabBarControllerDelegate

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        trackTabSelected(viewController)
        
        // Refresh data for selected view controllers
        if let sourceViewController = getActiveViewController(viewController) {
            
            if sourceViewController.isViewLoaded() && sourceViewController.view.window == nil {
                if sourceViewController is SearchViewController {
                    (sourceViewController as! SearchViewController).loadData()
                } else if sourceViewController is CurrentUserProfileDetailViewController {
                    (sourceViewController as! CurrentUserProfileDetailViewController).loadData()
                } else if sourceViewController is OrganizationDetailViewController {
                    (sourceViewController as! OrganizationDetailViewController).loadData()
                }
                
                // Activate Search
                if selectedIndex == 0 && sourceViewController is SearchViewController {
                    let searchVC = sourceViewController as! SearchViewController
                    if searchVC.view.window != nil {
                        searchVC.activateSearch(false)
                    }
                }
            }
            
            if !(sourceViewController is BaseDetailViewController) {
                sourceViewController.navigationController?.navigationBar.makeOpaque()
            }
        }
        return true
    }

    // MARK: - Tracking

    private func trackTabSelected(viewController: UIViewController) {
        let sourceViewController = getActiveViewController(selectedViewController)
        let destinationViewController = getActiveViewController(viewController)

        if sourceViewController == nil || destinationViewController == nil {
            assert(false, "Invalid source \(sourceViewController) or destination \(destinationViewController) view controller.")
        }

        var source: Tracker.Source
        if sourceViewController! is SearchViewController {
            source = .Home
        } else if sourceViewController! is CurrentUserProfileDetailViewController {
            source = .UserProfile
        } else if sourceViewController! is OrganizationDetailViewController {
            source = .Organization
        } else {
            assert(false, "Unhandled TabBar Source View Controller")
            source = .Unknown
        }

        var destination: Tracker.Source
        if destinationViewController! is SearchViewController {
            destination = .Home
        } else if destinationViewController! is CurrentUserProfileDetailViewController {
            destination = .UserProfile
        } else if destinationViewController! is OrganizationDetailViewController {
            destination = .Organization
        } else {
            assert(false, "Unhandled TabBar Destination View Controller")
            destination = .Unknown
        }

        let properties = [
            TrackerProperty.withKey(.Source).withSource(source),
            TrackerProperty.withKey(.Destination).withSource(destination),
            TrackerProperty.withKey(.ActiveViewController).withString(sourceViewController!.description)
        ]
        Tracker.sharedInstance.track(.TabSelected, properties: properties)
    }

    private func getActiveViewController(viewController: UIViewController?) -> UIViewController? {
        var activeViewController: UIViewController?
        if let navigationController = viewController as? UINavigationController {
            activeViewController = navigationController.viewControllers.first as? UIViewController
        } else {
            activeViewController = selectedViewController
        }
        return activeViewController
    }
}
