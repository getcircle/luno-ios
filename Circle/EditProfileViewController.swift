//
//  EditProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry
import MBProgressHUD

protocol EditProfileDelegate {
    func didFinishEditingProfile()
}

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ProfileSelectorDelegate, FormBuilderPhotoFieldHandler, FormBuilderProfileFieldHandler, FormBuilderDelegate {
    
    @IBOutlet weak private(set) var rootContentView: UIView!
    @IBOutlet weak private(set) var rootContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var rootScrollView: UIScrollView!
    
    var editProfileDelegate: EditProfileDelegate?
    var manager: Services.Profile.Containers.ProfileV1?
    var profile: Services.Profile.Containers.ProfileV1!

    private var addImageActionSheet: UIAlertController?
    private var existingContactMethodsByType = Dictionary<Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1, Services.Profile.Containers.ContactMethodV1>()
    private var formBuilder = FormBuilder()
    private var imageToUpload: UIImage?
    private var messageView: MessageView?
    private var saveButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
        Tracker.sharedInstance.trackPageView(pageType: .EditProfile, pageId: profile.id)
        
        initializeMessageView()
        
        configureView()
        configureScrollView()
        configureContentView()
        configureNavigationButtons()
        configureFormFields()
        formBuilder.build(rootContentView)
        formBuilder.delegate = self
        registerNotifications()
    }
    
    deinit {
        unregisterNotifications()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var maxY: CGFloat = 0.0
        var heightOfTheLastElement: CGFloat = 0.0
        for subview in rootContentView.subviews {
            if subview.frame.origin.y >= maxY {
                maxY = subview.frame.origin.y
                heightOfTheLastElement = subview.frame.height
            }
        }

        let contentHeight: CGFloat = maxY + heightOfTheLastElement + 100.0
        rootScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, contentHeight)
        rootContentViewHeightConstraint.constant = contentHeight
        rootContentView.setNeedsUpdateConstraints()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        formBuilder.activeField?.resignFirstResponder()
    }

    // MARK: - Initialization
    
    func initializeMessageView() {
        if manager != nil {
            messageView = addMessageView(AppStrings.EditProfileFormWarning, messageType: .Warning)
            messageView?.hide(animated: false)
            view.bringSubviewToFront(messageView!)
        }
    }
    
    // MARK: - Configuration
    
    private func configureScrollView() {
        rootScrollView.backgroundColor = UIColor.appViewBackgroundColor()
        rootScrollView.opaque = true
        rootScrollView.bounces = true
        rootScrollView.alwaysBounceVertical = true
    }
    
    private func configureContentView() {
        rootContentView.backgroundColor = UIColor.appViewBackgroundColor()
        rootContentView.opaque = true
    }
    
    private func configureFormFields() {
        let formSections = [
            FormBuilder.Section(
                title: "Photo",
                items: [
                    FormBuilder.ProfileSectionItem(
                        type: .Photo,
                        fieldType: .Photo,
                        photoFieldHandler: self,
                        imageSource: "edit_profile_camera",
                        name: AppStrings.ProfileEditUpdatePhoto
                    )
                ]),
            FormBuilder.Section(
                title: "Title",
                items: [
                    FormBuilder.ProfileSectionItem(
                        type: .TextField,
                        fieldType: .Title
                    )
                ]),
            FormBuilder.Section(
                title: "Contact",
                items: [
                    FormBuilder.ContactSectionItem(
                        placeholder: AppStrings.ContactPlaceholderAddNumber,
                        placeholderColor: UIColor.appMissingFieldValueColor(),
                        type: .TextField,
                        keyboardType: .PhonePad,
                        contactMethodType: .CellPhone,
                        imageSource: "detail_phone",
                        name: "Phone"
                    ),
                ]),
            FormBuilder.Section(
                title: "Reports to",
                items: [
                    FormBuilder.ProfileSectionItem(
                        placeholder: AppStrings.EditProfileManagerPlaceholder,
                        placeholderColor: UIColor.appMissingFieldValueColor(),
                        type: .Profile,
                        fieldType: .Profile,
                        profileFieldHandler: self
                    ),
            ]),
        ]
        
        for contactMethod in profile.contactMethods {
            existingContactMethodsByType.updateValue(contactMethod, forKey: contactMethod.contactMethodType)
        }
        
        for section in formSections {
            for item in section.items {
                if let contactItem = item as? FormBuilder.ContactSectionItem {
                    if let value = existingContactMethodsByType[contactItem.contactMethodType]?.value {
                        item.value = value
                    }
                    
                    if contactItem.contactMethodType == .Email &&
                        (contactItem.placeholder == AppStrings.ContactLabelWorkEmail || contactItem.placeholder == "Hangouts") {
                        item.value = profile.email
                        item.inputEnabled = false
                    }
                    
                    if contactItem.contactMethodType == .CellPhone && contactItem.placeholder == "SMS" {
                        item.inputEnabled = false
                    }
                }
                else if let profileItem = item as? FormBuilder.ProfileSectionItem {
                    
                    switch profileItem.fieldType {
                    case .Photo:
                        item.value = profile.imageUrl
                        
                    case .Title:
                        item.value = profile.title
                        item.autocapitalizationType = .Words
                        item.autocorrectionType = .Yes
                        item.spellCheckingType = .Yes
                        
                    case .HireDate:
                        item.value = profile.hireDate
                        
                    case .Profile:
                        item.name = manager?.fullName
                        item.value = manager?.id
                        
                    }
                }
            }
        }
        
        formBuilder.sections.appendContentsOf(formSections)
    }
    
    private func configureView() {
        title = AppStrings.ProfileEditTitle
        view.backgroundColor = UIColor.appViewBackgroundColor()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureNavigationButtons() {

        if isBeingPresentedModally() {
            addCancelTextButtonWithAction("cancelButtonTapped:")
        }
        
        saveButton = addSaveTextButtonWithAction("saveButtonTapped:")
        saveButton?.enabled = false
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject!) {
        handleImageUpload { (imageUrl: String?) -> Void in
            self.imageToUpload = nil
            do {
                try self.updateProfile(newImageUrl: imageUrl, completion: { () -> Void in
                    if let delegate = self.editProfileDelegate {
                        delegate.didFinishEditingProfile()
                    }
                    
                    if self.isBeingPresentedModally() {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            }
            catch {
                print("Error: \(error)")
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
        }
    }

    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Helpers

    private func updateProfile(newImageUrl newImageUrl: String?, completion: () -> Void) throws {
        // NOTE: The field names are named to keep things consistent with the web.
        var trackUpdatedFields = [String]()
        let builder = try profile.toBuilder()
        builder.verified = true
        formBuilder.updateValues()
        var contactMethods = Array<Services.Profile.Containers.ContactMethodV1>()
        var managerChanged = false
        for section in formBuilder.sections {
            for item in section.items {
                if let value = item.value {
                    if let contactItem = item as? FormBuilder.ContactSectionItem {
                        if (contactItem.inputEnabled == nil || contactItem.inputEnabled == true) {
                            var contactMethod: Services.Profile.Containers.ContactMethodV1.Builder
                            if let existingContactMethod = existingContactMethodsByType[contactItem.contactMethodType] {
                                contactMethod = try existingContactMethod.toBuilder()
                            }
                            else {
                                contactMethod = Services.Profile.Containers.ContactMethodV1.Builder()
                            }

                            if let contactItemName = contactItem.name {
                                contactMethod.label = contactItemName
                            }
                            contactMethod.value = value.trimWhitespace()
                            contactMethod.contactMethodType = contactItem.contactMethodType
                            contactMethods.append(try contactMethod.build())
                            
                            // TODO: Think of some generic way to handle this
                            if contactItem.contactMethodType == .CellPhone {
                                trackUpdatedFields.append("cell_number")
                            }
                        }
                    }
                    else if let profileItem = item as? FormBuilder.ProfileSectionItem {
                        if value.trimWhitespace() != "" && (profileItem.inputEnabled == nil || profileItem.inputEnabled == true) {
                            switch profileItem.fieldType {
                            case .Photo:
                                break
                                
                            case .Title:
                                builder.title = value.trimWhitespace()
                                trackUpdatedFields.append("title")
                                
                            case .HireDate:
                                builder.hireDate = value
                                
                            case .Profile:
                                managerChanged = (item.value != item.originalValue)
                                
                            }
                        }
                    }
                }
            }
        }
        builder.contactMethods = contactMethods
        if let uploadedImageUrl = newImageUrl {
            builder.imageUrl = uploadedImageUrl
            trackUpdatedFields.append("image_url")
        }
        
        let updateProfile = {
            Services.Profile.Actions.updateProfile(try builder.build()) { (profile, error) -> Void in
                if let profile = profile {
                    AuthenticationViewController.updateUserProfile(profile)
                    if trackUpdatedFields.count > 0 {
                        Tracker.sharedInstance.trackProfileUpdate(profile.id, fields: trackUpdatedFields)
                    }
                }
                completion()
            }
        }
        
        if let newManager = manager where managerChanged {
            Services.Organization.Actions.setManager(profile.id, managerProfileId: newManager.id, completionHandler: { (setManagerError) -> Void in
                if setManagerError != nil {
                    print("Error: \(setManagerError)")
                }
                
                do {
                    try updateProfile()
                }
                catch {
                    print("Error: \(error)")
                    completion()
                }
            })
        }
        else {
            try updateProfile()
        }
    }
    
    private func dismissKeyboard() {
        if let activeField = formBuilder.activeField {
            activeField.resignFirstResponder()
        }
    }

    // MARK: - Gesture Recognizer
    
    func viewTapped(sender: AnyObject!) {
        dismissKeyboard() 
    }
    
    // MARK: - FormBuilderDelegate
    
    func formValuesDidChange(newValues: Bool) {
        saveButton?.enabled = newValues
        
        if let messageView = messageView where manager != nil {
            if newValues || imageToUpload != nil {
                messageView.show(animated: true)
            }
            else {
                messageView.hide(animated: true)
            }
        }
    }
    
    // MARK: - FormBuilderPhotoFieldHandler
    
    func didTapOnPhotoField(sender: UIView) {
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
    
    func selectedImageForPhotoFieldItem(item: FormBuilder.ProfileSectionItem) -> UIImage? {
        return imageToUpload
    }
    
    // MARK: - Image Upload
    
    private func takeAPictureAction(action: UIAlertAction!) {
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
    
    private func pickAPhotoAction(action: UIAlertAction!) {
        dismissAddImageActionSheet(false)
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .PhotoLibrary
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            presentViewController(pickerVC, animated: true, completion: nil)
        }
    }
    
    private func dismissAddImageActionSheet(animated: Bool) {
        if addImageActionSheet != nil {
            addImageActionSheet!.dismissViewControllerAnimated(animated, completion: {() -> Void in
                self.addImageActionSheet = nil
            })
        }
    }
    
    private func handleImageUpload(completion: (imageUrl: String?) -> Void) {
        if let newImage = imageToUpload {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Media.Actions.uploadImage(
                newImage,
                forMediaType: .Profile,
                withKey: profile.id
                ) { (mediaURL, error) -> Void in
                    hud.hide(true)
                    completion(imageUrl: mediaURL)
            }
        }
        else {
            completion(imageUrl: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = pickedImage
        }
        else {
            imageToUpload = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        formBuilder.updateValues()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ProfileSelectorDelegate
    
    func onSelectedProfiles(profiles: Array<Services.Profile.Containers.ProfileV1>) -> Bool {
        manager = profiles.first
        formBuilder.updateValues()
        
        navigationController?.popViewControllerAnimated(true)
        
        return false
    }
    
    // MARK: - FormBuilderProfileFieldHandler
    
    func didTapOnProfileField(sender: UIView) {
        let profilesSelectorViewController = ProfilesSelectorViewController(allowsMultipleSelection: false, searchPlaceholderText: "Search Manager", searchPlaceholderComment: "Placeholder for text field used to search for manager")
        profilesSelectorViewController.title = AppStrings.ChangeManagerTitle
        profilesSelectorViewController.pageType = .ProfileSelector
        profilesSelectorViewController.profileSelectorDelegate = self
        navigationController?.pushViewController(profilesSelectorViewController, animated: true)
    }
    
    func selectedProfileForProfileFieldItem(item: FormBuilder.ProfileSectionItem) -> Services.Profile.Containers.ProfileV1? {
        return manager
    }
}
