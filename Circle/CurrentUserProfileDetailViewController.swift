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
    CardHeaderViewDelegate,
    EditProfileDelegate
{

    convenience init(
        profile withProfile: ProfileService.Containers.Profile,
        showSettingsButton: Bool = false
    ) {
            self.init()
            profile = withProfile
            dataSource = CurrentUserProfileDetailDataSource(profile: profile)
            dataSource.cardHeaderDelegate = self
            delegate = CardCollectionViewDelegate()
            
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
        registerFullLifecycleNotifications()
    }

    private func configureNavigationButtons() {
//        if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
//            let editButtonItem = UIBarButtonItem(
//                image: UIImage(named: "Pencil"),
//                style: .Plain,
//                target: self,
//                action: "editProfileButtonTapped:"
//            )
//            
//            var rightBarButtonItems = [UIBarButtonItem]()
//            if navigationItem.rightBarButtonItem != nil {
//                rightBarButtonItems.append(navigationItem.rightBarButtonItem!)
//            }
//            
//            rightBarButtonItems.append(editButtonItem)
//            navigationItem.rightBarButtonItems = rightBarButtonItems
//        }
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
    
    // MARK: - Notifications
    
    override func registerNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "socialConnectCTATapped:",
            name: SocialConnectCollectionViewCellNotifications.onCTATappedNotification,
            object: nil
        )
        
        super.registerNotifications()
    }
    
    private func registerFullLifecycleNotifications() {
        // Do not un-register this notification in viewDidDisappear
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onProfileUpdated:",
            name: ProfileServiceNotifications.onProfileUpdatedNotification,
            object: nil
        )
    }

    override func unregisterNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: SocialConnectCollectionViewCellNotifications.onCTATappedNotification,
            object: nil
        )
        
        super.unregisterNotifications()
    }
    
    
    // MARK: - Notification handlers
    
    func socialConnectCTATapped(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let typeOfCTA = userInfo["type"] as? Int {
                if let contentType = ContentType(rawValue: typeOfCTA) {
                    switch contentType {
                    case .LinkedInConnect:
                        let socialConnectVC = SocialConnectViewController(provider: .Linkedin)
                        navigationController?.presentViewController(socialConnectVC, animated: true, completion:nil)
                        
                    default:
                        break
                    }
                }
            }
        }
    }

    func onProfileUpdated(notification: NSNotification) {
        profile = AuthViewController.getLoggedInUserProfile()!
        reloadData()
    }
    
    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(card: Card!) {
        switch card.type {
        case .TextValue:
            let aboutViewController = EditAboutViewController(nibName: "EditAboutViewController", bundle: nil)
            aboutViewController.profile = profile
            let aboutViewNavController = UINavigationController(rootViewController: aboutViewController)
            navigationController?.presentViewController(aboutViewNavController, animated: true, completion: nil)
            break
            
        case .Skills:
            let skillSelectorViewController = SkillSelectorViewController(nibName: "SkillSelectorViewController", bundle: nil)
            if let skills = (dataSource as CurrentUserProfileDetailDataSource).skills {
                skillSelectorViewController.preSelectSkills = skills
            }
            let skillsNavController = UINavigationController(rootViewController: skillSelectorViewController)
            navigationController?.presentViewController(skillsNavController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
}
