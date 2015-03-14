//
//  CurrentUserProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class CurrentUserProfileDetailViewController: ProfileDetailViewController,
    EditProfileDelegate
{

    convenience init(
        profile withProfile: ProfileService.Containers.Profile,
        showSettingsButton: Bool = false
    ) {
            self.init()
            profile = withProfile
            dataSource = ProfileDetailDataSource(profile: profile)
            delegate = StickyHeaderCollectionViewDelegate()
            
            if showSettingsButton {
                addSettingsButton()
            }
    }
    
    // MARK: - Class Methods
    
    class func forProfile(
        profile: ProfileService.Containers.Profile, 
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
        configureNavigationButtons()
    }

    private func configureNavigationButtons() {
        if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
            let editButtonItem = UIBarButtonItem(
                image: UIImage(named: "Pencil"),
                style: .Plain,
                target: self,
                action: "editProfileButtonTapped:"
            )
            
            var rightBarButtonItems = [UIBarButtonItem]()
            if navigationItem.rightBarButtonItem != nil {
                rightBarButtonItems.append(navigationItem.rightBarButtonItem!)
            }
            
            rightBarButtonItems.append(editButtonItem)
            navigationItem.rightBarButtonItems = rightBarButtonItems
        }
    }

    // MARK: - Helpers
    
    private func addSettingsButton() {
        if navigationItem.leftBarButtonItem == nil {
            var settingsButton = UIButton.buttonWithType(.Custom) as UIButton
            settingsButton.frame = CGRectMake(0.0, 0.0, 22.0, 22.0)
            settingsButton.setImage(UIImage(named: "Cog")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            settingsButton.tintColor = UIColor.appNavigationBarTintColor()
            settingsButton.addTarget(self, action: "settingsButtonTapped:", forControlEvents: .TouchUpInside)
            
            let settingsBarButton = UIBarButtonItem(customView: settingsButton)
            navigationItem.leftBarButtonItem = settingsBarButton
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: "profileLongPressHandler:")
            settingsButton.addGestureRecognizer(longPressGesture)
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func editProfileButtonTapped(sender: AnyObject!) {
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        editProfileVC.profile = profile
        editProfileVC.editProfileDelegate = self
        editProfileVC.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func settingsButtonTapped(sender: AnyObject!) {
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        presentViewController(settingsNavController, animated: true, completion: nil)
    }
    
    @IBAction func profileLongPressHandler(sender: AnyObject!) {
        let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
        let onboardingNavigationController = UINavigationController(rootViewController: verifyPhoneNumberVC)
        navigationController?.presentViewController(onboardingNavigationController, animated: true, completion: nil)
    }
}
