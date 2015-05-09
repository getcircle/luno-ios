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
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    ProfileEditImageButtonDelegate,
    EditProfileDelegate
{

    private var addImageActionSheet: UIAlertController?
    private var didUploadPhoto = false
    private var imageToUpload: UIImage?
    private var socialConnectVC = SocialConnectViewController()
    
    convenience init(
        profile withProfile: Services.Profile.Containers.ProfileV1,
        showSettingsButton: Bool = false
    ) {
        self.init()
        profile = withProfile
        dataSource = CurrentUserProfileDetailDataSource(profile: profile)
        (dataSource as! CurrentUserProfileDetailDataSource).editImageButtonDelegate = self
        dataSource.cardHeaderDelegate = self
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
    
    private func reloadHeader() {
        if let dataSource = dataSource as? CurrentUserProfileDetailDataSource {
            if let headerView = dataSource.profileHeaderView {
                headerView.setProfile(profile)
            }
        }
    }
    
    private func addSettingsButton() {
        if navigationItem.leftBarButtonItem == nil {
            var settingsButton = UIButton.buttonWithType(.Custom) as! UIButton
            settingsButton.frame = CGRectMake(0.0, 0.0, 22.0, 22.0)
            settingsButton.setImage(UIImage(named: "Settings")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            settingsButton.tintColor = UIColor.appNavigationBarTintColor()
            settingsButton.addTarget(self, action: "settingsButtonTapped:", forControlEvents: .TouchUpInside)
            
            let settingsBarButton = UIBarButtonItem(customView: settingsButton)
            navigationItem.leftBarButtonItem = settingsBarButton
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: "profileLongPressHandler:")
            longPressGesture.minimumPressDuration = 5.0
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
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onSocialAccountConnected:",
            name: SocialConnectNotifications.onServiceConnectedNotification,
            object: socialConnectVC
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
                        socialConnectVC.provider = .Linkedin
                        let socialNavController = UINavigationController(rootViewController: socialConnectVC)
                        navigationController?.presentViewController(socialNavController, animated: true, completion:nil)
                        
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
    
    func onSocialAccountConnected(notification: NSNotification) {
        Services.User.Actions.getIdentities(profile.userId) { (identities, error) -> Void in
            if identities != nil {
                AuthViewController.updateIdentities(identities!)
                self.profile = AuthViewController.getLoggedInUserProfile()!
            }
        }
        profile = AuthViewController.getLoggedInUserProfile()!
        reloadData()
    }
    
    // MARK: - CardHeaderViewDelegate
    
    override func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        switch card.type {
        case .TextValue:
            let aboutViewController = EditAboutViewController(nibName: "EditAboutViewController", bundle: nil)
            aboutViewController.profile = profile
            let aboutViewNavController = UINavigationController(rootViewController: aboutViewController)
            navigationController?.presentViewController(aboutViewNavController, animated: true, completion: nil)
            break
            
        case .Tags:
            let interestSelectorViewController = TagScrollingSelectorViewController(nibName: "TagScrollingSelectorViewController", bundle: nil)
            if let interests = (dataSource as! CurrentUserProfileDetailDataSource).interests {
                interestSelectorViewController.preSelectTags = interests
            }
            let interestsNavController = UINavigationController(rootViewController: interestSelectorViewController)
            navigationController?.presentViewController(interestsNavController, animated: true, completion: nil)
            
        case .Skills:
            var existingSkills = Array<Services.Profile.Containers.TagV1>()
            if let skills = (dataSource as! CurrentUserProfileDetailDataSource).skills {
                existingSkills = skills
            }
            let tagInputViewController = TagInputViewController(existingTags: existingSkills)
            let tagInputNavController = UINavigationController(rootViewController: tagInputViewController)
            navigationController?.presentViewController(tagInputNavController, animated: true, completion: nil)
            
        default:
            super.cardHeaderTapped(sender, card: card)
        }
    }
    
    // MARK: - Image Upload
    
    func onEditImageButtonTapped(sender: AnyObject!) {

        var actionSheet = UIAlertController(
            title: AppStrings.ActionSheetAddAPictureButtonTitle,
            message: nil,
            preferredStyle: .ActionSheet
        )
        actionSheet.view.tintColor = UIColor.appActionSheetControlsTintColor()
        
        var takeAPictureActionControl = UIAlertAction(
            title: AppStrings.ActionSheetTakeAPictureButtonTitle,
            style: .Default,
            handler: takeAPictureAction
        )
        actionSheet.addAction(takeAPictureActionControl)
        
        var pickAPhotoActionControl = UIAlertAction(
            title: AppStrings.ActionSheetPickAPhotoButtonTitle,
            style: .Default,
            handler: pickAPhotoAction
        )
        actionSheet.addAction(pickAPhotoActionControl)
        
        var cancelControl = UIAlertAction(
            title: AppStrings.GenericCancelButtonTitle,
            style: .Cancel,
            handler: { (action) -> Void in
                self.dismissAddImageActionSheet(true)
            }
        )
        actionSheet.addAction(cancelControl)
        addImageActionSheet = actionSheet
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func takeAPictureAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            var pickerVC = UIImagePickerController()
            pickerVC.sourceType = .Camera
            pickerVC.cameraCaptureMode = .Photo
            if UIImagePickerController.isCameraDeviceAvailable(.Front) {
                pickerVC.cameraDevice = .Front
            }
            else {
                pickerVC.cameraDevice = .Rear
            }
            
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    func pickAPhotoAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            var pickerVC = UIImagePickerController()
            pickerVC.sourceType = .PhotoLibrary
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = pickedImage
        }
        else {
            // XXX when is this ever hit?
            imageToUpload = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        handleImageUpload { () -> Void in
            self.reloadHeader()
            self.imageToUpload = nil
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func handleImageUpload(completion: () -> Void) {
        if let newImage = imageToUpload {
            Services.Media.Actions.uploadProfileImage(profile.id, image: newImage) { (mediaURL, error) -> Void in
                if let mediaURL = mediaURL {
                    let profileBuilder = self.profile.toBuilder()
                    profileBuilder.imageUrl = mediaURL
                    Services.Profile.Actions.updateProfile(profileBuilder.build()) { (profile, error) -> Void in
                        if let profile = profile {
                            AuthViewController.updateUserProfile(profile)
                            self.profile = profile
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    private func dismissAddImageActionSheet(animated: Bool) {
        if addImageActionSheet != nil {
            addImageActionSheet!.dismissViewControllerAnimated(animated, completion: {() -> Void in
                self.addImageActionSheet = nil
            })
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .ContactPreferences:
            let editProfileVC = EditContactInfoViewController(nibName: "EditContactInfoViewController", bundle: nil)
            editProfileVC.profile = profile
            editProfileVC.editProfileDelegate = self
            let editProfileNavVC = UINavigationController(rootViewController: editProfileVC)
            navigationController?.presentViewController(editProfileNavVC, animated: true, completion: nil)
            
        default:
            super.handleKeyValueCardSelection(dataSource, indexPath: indexPath)
        }
    }
}
