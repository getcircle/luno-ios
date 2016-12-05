//
//  VerifyProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class VerifyProfileViewController:
    UIViewController,
    UITextFieldDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

    @IBOutlet weak private(set) var editImageButton: UIButton!
    @IBOutlet weak private(set) var nextButton: UIButton!
    @IBOutlet weak private(set) var profileImageView: CircleImageView!
    @IBOutlet weak private(set) var verifyTextLabel: UILabel!

    private var addImageActionSheet: UIAlertController?
    private var profile: Services.Profile.Containers.ProfileV1! {
        didSet {
            // only set the staticProfile once
            if staticProfile == nil {
                do {
                    let profileBuilder = try profile.toBuilder()
                    staticProfile = try profileBuilder.build()
                }
                catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    // create a static copy to the profile we can compare with the "profile" object to detect changes
    private var staticProfile: Services.Profile.Containers.ProfileV1?
    private var didUploadPhoto = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        populateData()
        checkDataAndEnableNext()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkDataAndEnableNext()
    }

    // MARK: - Configuration
    
    private func configureView() {
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = .Top
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.makeTransparent()
        view.backgroundColor = UIColor.appUIBackgroundColor()

        editImageButton.tintColor = UIColor.whiteColor()
        editImageButton.setImage(
            editImageButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )
    }

    // MARK: - Data Source
    
    private func populateData() {
        profile = AuthenticationViewController.getLoggedInUserProfile()
        profileImageView.imageProfileIdentifier = profile.id
        profileImageView.setLargerProfileImage(profile, successHandler: {(image) -> Void in
            self.profileImageView.image = image
            self.checkDataAndEnableNext()
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(sender: AnyObject!) {
        let activityIndicatorView = nextButton.addActivityIndicator(UIColor.appUIBackgroundColor())
        nextButton.setTitle("", forState: .Normal)
        do {
            try handleImageUpload { () -> Void in
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                self.verificationComplete()
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func editImageButtonTapped(sender: UIView!) {
        let actionSheet = UIAlertController(
            title: AppStrings.ActionSheetAddAPictureButtonTitle,
            message: nil,
            preferredStyle: .ActionSheet
        )
        actionSheet.view.tintColor = UIColor.appActionSheetControlsTintColor()

        let takeAPictureActionControl = UIAlertAction(
            title: AppStrings.ActionSheetTakeAPictureButtonTitle,
            style: .Default,
            handler: takeAPictureAction
        )
        actionSheet.addAction(takeAPictureActionControl)

        let pickAPhotoActionControl = UIAlertAction(
            title: AppStrings.ActionSheetPickAPhotoButtonTitle,
            style: .Default,
            handler: pickAPhotoAction
        )
        actionSheet.addAction(pickAPhotoActionControl)

        let cancelControl = UIAlertAction(
            title: AppStrings.GenericCancelButtonTitle,
            style: .Cancel,
            handler: { (action) -> Void in
                self.dismissAddImageActionSheet(true)
            }
        )
        actionSheet.addAction(cancelControl)
        addImageActionSheet = actionSheet
        if let popoverViewController = actionSheet.popoverPresentationController {
            popoverViewController.sourceRect = sender.bounds
            popoverViewController.sourceView = sender
        }
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func skipButtonTapped(sender: AnyObject) {
        verificationComplete()
    }
    
    func takeAPictureAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let pickerVC = UIImagePickerController()
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
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .PhotoLibrary
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func isProfileDirty() -> Bool {
        return staticProfile!.hashValue != profile.hashValue
    }
    
    private func updateProfile(completion: () -> Void) throws {
        let builder = try profile.toBuilder()
        builder.verified = true
        Services.Profile.Actions.updateProfile(try builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthenticationViewController.updateUserProfile(profile)
                self.profile = profile
            }
            completion()
        }
    }
    
    private func handleImageUpload(completion: () -> Void) throws {
        if didUploadPhoto {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Media.Actions.uploadImage(
                profileImageView.image!,
                forMediaType: .Profile,
                withKey: profile.id
            ) { (mediaURL, error) -> Void in
                if let mediaURL = mediaURL {
                    do {
                        let profileBuilder = try self.profile.toBuilder()
                        profileBuilder.imageUrl = mediaURL
                        self.profile = try profileBuilder.build()
                        try self.updateProfile(completion)
                    }
                    catch {
                        print("Error: \(error)")
                    }
                    hud.hide(true)
                }
            }
        } else {
            try updateProfile(completion)
        }
    }
    
    private func dismissAddImageActionSheet(animated: Bool) {
        if addImageActionSheet != nil {
            addImageActionSheet!.dismissViewControllerAnimated(animated, completion: {() -> Void in
                self.addImageActionSheet = nil
            })
        }
        
        checkDataAndEnableNext()
    }
    
    // MARK: - UIImagePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = pickedImage
            didUploadPhoto = true
        }
        else {
            // XXX when is this ever hit?
            profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        self.checkDataAndEnableNext()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Helpers
    
    private func checkDataAndEnableNext() {
        nextButton.enabled = profileImageView.image != nil
        nextButton.setTitle(AppStrings.GenericNextButtonTitle, forState: .Normal)
    }

    private func verificationComplete() {
        let notificationsVC = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        navigationController?.setViewControllers([notificationsVC], animated: true)
    }
}
