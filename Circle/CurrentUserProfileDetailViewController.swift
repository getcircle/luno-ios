//
//  CurrentUserProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class CurrentUserProfileDetailViewController: ProfileDetailViewController,
    EditProfileDelegate
{
    
    convenience init(
        profile withProfile: Services.Profile.Containers.ProfileV1,
        showSettingsButton: Bool = false
    ) {
        self.init()
        profile = withProfile
        dataSource = CurrentUserProfileDetailDataSource(profile: profile)
        delegate = CardCollectionViewDelegate()
        
        if showSettingsButton {
            addSettingsButton()
        }
    }
    
    // MARK: - Class Methods
    
    static func forProfile(
        profile: Services.Profile.Containers.ProfileV1, 
        showSettingsButton: Bool = false
    ) -> CurrentUserProfileDetailViewController {
            return CurrentUserProfileDetailViewController(
                profile: profile,
                showSettingsButton: showSettingsButton
            )
    }

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerFullLifecycleNotifications()
    }

    // MARK: - Helpers
    
    internal override func reloadHeader() {
        if let dataSource = dataSource as? CurrentUserProfileDetailDataSource {
            if let headerView = dataSource.profileHeaderView {
                headerView.setProfile(profile, location: dataSource.location, team: dataSource.team)
            }
        }
    }
    
    private func addSettingsButton() {
        if navigationItem.leftBarButtonItem == nil {
            let settingsButton = UIButton(type: .Custom)
            settingsButton.frame = CGRectMake(0.0, 0.0, 22.0, 22.0)
            settingsButton.setImage(UIImage(named: "navbar_settings")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            settingsButton.imageEdgeInsets = UIEdgeInsetsMake(-15.0, -15.0, -15.0, -15.0)
            settingsButton.tintColor = UIColor.appNavigationBarTintColor()
            settingsButton.addTarget(self, action: "settingsButtonTapped:", forControlEvents: .TouchUpInside)
            
            let settingsBarButton = UIBarButtonItem(customView: settingsButton)
            navigationItem.leftBarButtonItem = settingsBarButton
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: "profileLongPressHandler:")
            longPressGesture.minimumPressDuration = 3.0
            settingsButton.addGestureRecognizer(longPressGesture)
        }
    }
    
    // MARK: - IBActions

    @IBAction func settingsButtonTapped(sender: AnyObject!) {
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        presentViewController(settingsNavController, animated: true, completion: nil)
    }
    
    @IBAction func profileLongPressHandler(sender: AnyObject!) {
        let welcomeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
        let onboardingNavigationController = UINavigationController(rootViewController: welcomeVC)
        navigationController?.presentViewController(onboardingNavigationController, animated: true, completion: nil)
    }
    
    override func editButtonTapped(sender: AnyObject) {
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        editProfileVC.profile = profile
        editProfileVC.manager = (dataSource as! ProfileDetailDataSource).manager
        editProfileVC.editProfileDelegate = self
        let editProfileNavVC = UINavigationController(rootViewController: editProfileVC)
        navigationController?.presentViewController(editProfileNavVC, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    
    private func registerFullLifecycleNotifications() {
        // Do not un-register this notification in viewDidDisappear
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onProfileUpdated:",
            name: ProfileServiceNotifications.onProfileUpdatedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onProfileUpdated:",
            name: AuthenticationNotifications.onProfileChangedNotification,
            object: nil
        )
    }
    
    // MARK: - Notification handlers

    func onProfileUpdated(notification: NSNotification) {
        profile = AuthenticationViewController.getLoggedInUserProfile()!
        reloadData()
    }
    
    // MARK: - EditProfileDelegate
    
    func didFinishEditingProfile() {
        if let loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile() {
            if profile.id == loggedInUserProfile.id {
                profile = loggedInUserProfile
                reloadData()
            }
        }
    }
}
