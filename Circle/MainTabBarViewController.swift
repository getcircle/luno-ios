//
//  MainTabBarViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

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
        let searchViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as SearchViewController
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let homeTabImage = UIImage(named: "Home")?.imageWithRenderingMode(.AlwaysTemplate)
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "",
            image: homeTabImage,
            selectedImage: homeTabImage
        )
        tabBarViewControllers.append(searchNavigationController)

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
                    showCloseButton: false,
                    showSettingsButton: true
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

    // MARK: - UITabBarControllerDelegate

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        trackTabSelected(viewController)
        return true
    }

    // MARK: - Helpers

    private func trackTabSelected(viewController: UIViewController) {
        let sourceViewController = getActiveViewController(selectedViewController)
        let destinationViewController = getActiveViewController(viewController)

        if sourceViewController == nil || destinationViewController == nil {
            assert(false, "Invalid source \(sourceViewController) or destination \(destinationViewController) view controller.")
        }

        var source: Tracker.Source
        if sourceViewController! is SearchViewController {
            source = .Home
        } else if sourceViewController! is ProfileDetailsViewController {
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
        } else if destinationViewController! is ProfileDetailsViewController {
            destination = .UserProfile
        } else if destinationViewController! is OrganizationDetailViewController {
            destination = .Organization
        } else {
            assert(false, "Unhandled TabBar Destination View Controller")
            destination = .Unknown
        }

        let properties = [
            TrackerProperty.withKey(.SourceViewController).withSource(source),
            TrackerProperty.withKey(.DestinationViewController).withSource(destination)
        ]
        Tracker.sharedInstance.track(.TabSelected, properties: properties)
    }

    private func getActiveViewController(viewController: UIViewController?) -> UIViewController? {
        var activeViewController: UIViewController?
        if let navigationController = viewController as? UINavigationController {
            activeViewController = navigationController.topViewController
        } else {
            activeViewController = selectedViewController
        }
        return activeViewController
    }
}
