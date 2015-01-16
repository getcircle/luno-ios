//
//  VerifyProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class VerifyProfileViewController:
    UIViewController,
    UITextFieldDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

    @IBOutlet weak private(set) var editImageButton: UIButton!
    @IBOutlet weak private(set) var firstNameField: UITextField!
    @IBOutlet weak private(set) var lastNameField: UITextField!
    @IBOutlet weak private(set) var nextButton: UIButton!
    @IBOutlet weak private(set) var profileImageView: UIImageView!
    @IBOutlet weak private(set) var titleField: UITextField!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var verifyTextLabel: UILabel!

    private var addImageActionSheet: UIAlertController?
    private var profile: ProfileService.Containers.Profile! {
        didSet {
            // only set the staticProfile once
            if staticProfile == nil {
                let profileBuilder = profile.toBuilder()
                staticProfile = profileBuilder.build()
            }
        }
    }
    // create a static copy to the profile we can compare with the "profile" object to detect changes
    private var staticProfile: ProfileService.Containers.Profile?
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
        setStatusBarHidden(true)
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = .Top
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.makeTransparent()
        view.backgroundColor = UIColor.appTintColor()
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        view.addGestureRecognizer(tapGestureRecognizer)
        
        editImageButton.tintColor = UIColor.whiteColor()
        editImageButton.setImage(
            editImageButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )
        
        [firstNameField, lastNameField, titleField].enumerateObjectsUsingBlock({object, index, stop in
            (object as UITextField).addBottomBorder()
            (object as UITextField).tintColor = UIColor.whiteColor()
        })
    }

    // MARK: - Data Source
    
    private func populateData() {
        profile = AuthViewController.getLoggedInUserProfile()
    
        firstNameField.text = profile.first_name
        lastNameField.text = profile.last_name
        titleField.text = profile.title
        profileImageView.setImageWithProfileImageURL(profile.image_url)
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(sender: AnyObject!) {
        for textField in [titleField, firstNameField, lastNameField] {
            textField.resignFirstResponder()
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.color = UIColor.appTintColor()
        activityIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextButton.setTitle("", forState: .Normal)
        nextButton.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        activityIndicatorView.startAnimating()
        handleImageUpload { () -> Void in
            activityIndicatorView.stopAnimating()
            self.verificationComplete()
        }
    }
    
    @IBAction func editImageButtonTapped(sender: AnyObject!) {
        var actionSheet = UIAlertController(
            title: NSLocalizedString("Add a picture", comment: "Title of window which asks user to add a picture"),
            message: nil,
            preferredStyle: .ActionSheet
        )
        actionSheet.view.tintColor = UIColor.actionSheetControlsTintColor()

        var takeAPictureActionControl = UIAlertAction(
            title: NSLocalizedString("Take a picture", comment: "Button prompt to take a picture using the camera"),
            style: .Default,
            handler: takeAPictureAction
        )
        actionSheet.addAction(takeAPictureActionControl)

        var pickAPhotoActionControl = UIAlertAction(
            title: NSLocalizedString("Pick a photo", comment: "Button prompt to pick a photo from user's photos"),
            style: .Default,
            handler: pickAPhotoAction
        )
        actionSheet.addAction(pickAPhotoActionControl)

        var cancelControl = UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: { (action) -> Void in
                self.dismissAddImageActionSheet(true)
            }
        )
        actionSheet.addAction(cancelControl)
        addImageActionSheet = actionSheet
        presentViewController(actionSheet, animated: true, completion: nil)
        dismissKeyboard()
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
    
    // MARK: - Helpers
    
    private func isProfileDirty() -> Bool {
        return staticProfile!.hashValue != profile.hashValue
    }
    
    private func updateProfile(completion: () -> Void) {
        let builder = profile.toBuilder()
        builder.verified = true
        ProfileService.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            completion()
        }
    }
    
    private func handleImageUpload(completion: () -> Void) {
        if didUploadPhoto {
            MediaService.Actions.uploadProfileImage(profile.id, image: profileImageView.image!) { (mediaURL, error) -> Void in
                if let mediaURL = mediaURL {
                    let profileBuilder = self.profile.toBuilder()
                    profileBuilder.image_url = mediaURL
                    self.updateProfile(completion)
                }
            }
        } else {
            updateProfile(completion)
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
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
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let isTextFieldEmpty = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        switch textField {
        case firstNameField:
            if !isTextFieldEmpty {
                lastNameField.becomeFirstResponder()
            }
            
        case lastNameField:
            if !isTextFieldEmpty {
                titleField.becomeFirstResponder()
            }
            
        case titleField:
            if !isTextFieldEmpty {
                titleField.resignFirstResponder()
                checkDataAndEnableNext()
            }

        default:
            break
        }
        
        checkDataAndEnableNext()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // update the profile fields
        let text = textField.text
        let builder = profile.toBuilder()
        switch textField {
        case firstNameField:
            builder.first_name = text
        case lastNameField:
            builder.last_name = text
        case titleField:
            builder.title = text
        default:
            break
        }
        profile = builder.build()
        checkDataAndEnableNext()
    }
    
    // MARK: - Geature Recognizer
    
    func viewTapped(sender: AnyObject!) {
        dismissKeyboard()
    }
    
    // MARK: - Helpers
    
    private func checkDataAndEnableNext() {
        var allTextFieldsFilled = true
        allTextFields().enumerateObjectsUsingBlock({object, index, stop in
            if allTextFieldsFilled {
                allTextFieldsFilled = (object as UITextField).text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""
            }
        })
        
        nextButton.enabled = allTextFieldsFilled && profileImageView.image != nil
    }
    
    private func dismissKeyboard() {
        allTextFields().enumerateObjectsUsingBlock({object, index, stop -> Void in
            (object as UITextField).resignFirstResponder()
            return
        })
    }
    
    private func allTextFields() -> NSArray {
        return [firstNameField, lastNameField, titleField]
    }
    
    private func verificationComplete() {
        let tagSelectorVC = TagSelectorViewController(nibName: "TagSelectorViewController", bundle: nil)
        tagSelectorVC.theme = .Onboarding
        navigationController?.setViewControllers([tagSelectorVC], animated: true)
    }
}
