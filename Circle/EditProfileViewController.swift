//
//  EditProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol EditProfileDelegate {
    func didFinishEditingProfile()
}

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak private(set) var editImageButton: UIButton!
    @IBOutlet weak private(set) var profileImageView: CircleImageView!
    @IBOutlet weak private(set) var rootScrollView: UIScrollView!
    
    var editProfileDelegate: EditProfileDelegate?
    var profile: ProfileService.Containers.Profile!

    private var addImageActionSheet: UIAlertController?
    private var didUploadPhoto = false
    private var formBuilder = FormBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureNavigationButtons()
        configureFormFields()
        populateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - Form Builder
    
    private func configureFormFields() {
        // Short bio
        // Image
        // Name
        // Title
        var formSections = [
            FormBuilder.Section(
                title: NSLocalizedString("About:", comment: "Title of the section listing name, title, and short bio"),
                items: [
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("First Name", comment: "Placeholder for textfield that accepts user's first name"),
                    type: .TextField,
                    keyboardType: .NamePhonePad,
                    container: "profile",
                    containerKey: "first_name"
                ),
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Last Name", comment: "Placeholder for textfield that accepts user's last name"),
                    type: .TextField,
                    keyboardType: .NamePhonePad,
                    container: "profile",
                    containerKey: "last_name"
                ),
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Title", comment: "Placeholder for textfield that accepts job title"), 
                    type: .TextField,
                    keyboardType: .NamePhonePad,
                    container: "profile",
                    containerKey: "title"
                ),
//                FormBuilder.SectionItem(
//                    placeholder: NSLocalizedString("Write a short bio for youself. You can add things like your favorite song, your personalysis profile or meyers briggs personality type, etc.",
//                    comment: "Placeholder for textfield that accepts a short bio for a user"),
//                    andType: .TextField,
//                    andKeyboardType: .ASCIICapable,
//                    andContainer: "profile",
//                    andContainerKey: "title"
//                )
            ]),
            FormBuilder.Section(
                title: NSLocalizedString("Email:", comment: "Title of the section listing emails"),
                items: [
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Work Email", comment: "Placeholder for textfield that accepts a work email"),
                    type: .TextField,
                    keyboardType: .EmailAddress,
                    container: "profile",
                    containerKey: "email"
                ),
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Personal Email", comment: "Placeholder for textfield that accepts a personal email"), 
                    type: .TextField,
                    keyboardType: .EmailAddress,
                    container: "profile",
                    containerKey: "personal_email"
                )
            ]),
            FormBuilder.Section(
                title: NSLocalizedString("Phone:", comment: "Title of the section listing phone numbers"),
                items: [
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Work Phone", comment: "Placeholder for textfield that accepts a work phone"),
                    type: .TextField,
                    keyboardType: .PhonePad,
                    container: "profile",
                    containerKey: "work_phone"
                ),
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Cell Phone", comment: "Placeholder for textfield that accepts a cell phone"),
                    type: .TextField,
                    keyboardType: .PhonePad,
                    container: "profile",
                    containerKey: "cell_phone"
                ),
                FormBuilder.SectionItem(
                    placeholder: NSLocalizedString("Home Phone", comment: "Placeholder for textfield that acceots a home phone"),
                    type: .TextField,
                    keyboardType: .PhonePad,
                    container: "profile",
                    containerKey: "home_phone"
                )
            ]),
        ]
        
        for section in formSections {
            for item in section.items {
                if item.container == "profile" {
                    item.value = profile[item.containerKey]
                }
            }
        }
        
        formBuilder.sections.extend(formSections)
        formBuilder.build(rootScrollView, afterSubView: profileImageView)
    }

    // MARK - Configuration
    
    private func configureView() {
        title = NSLocalizedString("Edit Profile", comment: "Title of the edit profile view")
        view.backgroundColor = UIColor.viewBackgroundColor()
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        view.addGestureRecognizer(tapGestureRecognizer)
        editImageButton.tintColor = UIColor.whiteColor()
        editImageButton.setImage(
            editImageButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )
    }
    
    override func viewDidLayoutSubviews() {
        var maxY: CGFloat = 0.0
        var heightOfTheLastElement: CGFloat = 0.0
        for subview in rootScrollView.subviews {
            if subview.frameY >= maxY {
                maxY = subview.frameY
                heightOfTheLastElement = subview.frameHeight
            }
        }
        
        rootScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, maxY + heightOfTheLastElement + 100.0)
    }

    private func configureScrollView() {
    }
    
    private func configureNavigationButtons() {
        
        if isBeingPresentedModally() {
            let cancelButtonItem = UIBarButtonItem(
                image: UIImage(named: "Close"),
                style: .Plain,
                target: self,
                action: "cancelButtonTapped:"
            )
            
            navigationItem.leftBarButtonItem = cancelButtonItem
        }

        let doneButtonItem = UIBarButtonItem(
            image: UIImage(named: "CircleCheckFilled"),
            style: .Plain,
            target: self,
            action: "saveButtonTapped:"
        )
        
        navigationItem.rightBarButtonItem = doneButtonItem
    }

    // MARK: - Data
    
    private func populateData() {
        profileImageView.setImageWithProfile(profile)
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject!) {
        handleImageUpload { () -> Void in
            if let delegate = self.editProfileDelegate {
                delegate.didFinishEditingProfile()
            }
            
            if self.isBeingPresentedModally() {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    // MARK: - Notifications
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWasShown:",
            name: UIKeyboardDidShowNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let keyboardSizeValue: NSValue = userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSizeValue.CGRectValue().size.height, 0.0);
            rootScrollView.contentInset = contentInsets;
            rootScrollView.scrollIndicatorInsets = contentInsets;
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            if let activeField = formBuilder.activeField {
                var aRect = view.frame;
                aRect.size.height -= keyboardSizeValue.CGRectValue().size.height;
                if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
                    rootScrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }

    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero;
        rootScrollView.contentInset = contentInsets;
        rootScrollView.scrollIndicatorInsets = contentInsets;
    }
    
    // MARK: - Profile Image

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

    private func updateProfile(completion: () -> Void) {
        let builder = profile.toBuilder()
        builder.verified = true
        
        formBuilder.updateValues()
        for section in formBuilder.sections {
            for item in section.items {
                if let value = item.value {
                    switch item.container {
                        case "profile":
                            // TODO: - Remove after subscripting support
                            switch item.containerKey {
                            case "first_name":
                                builder.first_name = value as String
                                
                            case "last_name":
                                builder.last_name = value as String
                            
                            case "title":
                                builder.title = value as String
                            
                            case "email":
                                builder.email = value as String
                            
                            case "work_phone":
                                builder.work_phone = value as String
                                
                            case "cell_phone":
                                builder.cell_phone = value as String
                                
                            default:
                                break
                                
                            }
                        
                        default:
                            break
                    }
                }
                println("Key - \(item.containerKey) Value - \(item.value)")
            }
        }
        
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
    }

    private func dismissKeyboard() {
        if let activeField = formBuilder.activeField {
            activeField.resignFirstResponder()
        }
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

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
