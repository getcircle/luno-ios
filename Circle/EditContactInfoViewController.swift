//
//  EditContactInfoViewController.swift
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

class EditContactInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak private(set) var rootContentView: UIView!
    @IBOutlet weak private(set) var rootContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var rootScrollView: UIScrollView!
    
    var editProfileDelegate: EditProfileDelegate?
    var profile: Services.Profile.Containers.ProfileV1!

    private var existingContactMethodsByType = Dictionary<Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1, Services.Profile.Containers.ContactMethodV1>()
    private var formBuilder = FormBuilder()
    private var imageToUpload: UIImage?
    private var addImageActionSheet: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureScrollView()
        configureContentView()
        configureNavigationButtons()
        configureFormFields()
        formBuilder.build(rootContentView)
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

    // MARK - Configuration
    
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
                        placeholder: "Update Photo",
                        type: .Photo,
                        fieldType: .Photo
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
                title: "Start Date",
                items: [
                    FormBuilder.ProfileSectionItem(
                        type: .DatePicker,
                        fieldType: .HireDate
                    )
                ]),
            FormBuilder.Section(
                title: "Contact",
                items: [
                    FormBuilder.ContactSectionItem(
                        placeholder: "Phone",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        contactMethodType: .CellPhone
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
                        break
                        
                    case .Title:
                        item.value = profile.title
                        
                    case .HireDate:
                        item.value = profile.hireDate
                        
                    }
                }
            }
        }
        
        formBuilder.sections.appendContentsOf(formSections)
    }
    
    private func configureView() {
        title = AppStrings.ProfileSectionContactPreferencesTitle
        view.backgroundColor = UIColor.appViewBackgroundColor()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureNavigationButtons() {

        if isBeingPresentedModally() {
            addCloseButtonWithAction("cancelButtonTapped:")
        }

        addDoneButtonWithAction("saveButtonTapped:")
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject!) {
        updateProfile { () -> Void in
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
        }
    }

    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Helpers

    private func updateProfile(completion: () -> Void) {
        let builder = try! profile.toBuilder()
        builder.verified = true
        
        formBuilder.updateValues()
        var contactMethods = Array<Services.Profile.Containers.ContactMethodV1>()
        for section in formBuilder.sections {
            for item in section.items {
                if let value = item.value {
                    if let contactItem = item as? FormBuilder.ContactSectionItem {
                        if value.trimWhitespace() != "" && (contactItem.inputEnabled == nil || contactItem.inputEnabled == true) {
                            var contactMethod: Services.Profile.Containers.ContactMethodV1.Builder
                            if let existingContactMethod = existingContactMethodsByType[contactItem.contactMethodType] {
                                contactMethod = try! existingContactMethod.toBuilder()
                            }
                            else {
                                contactMethod = Services.Profile.Containers.ContactMethodV1.Builder()
                            }

                            contactMethod.label = contactItem.placeholder
                            contactMethod.value = value.trimWhitespace()
                            contactMethod.contactMethodType = contactItem.contactMethodType
                            contactMethods.append(try! contactMethod.build())
                        }
                    }
                    else if let profileItem = item as? FormBuilder.ProfileSectionItem {
                        if value.trimWhitespace() != "" && (profileItem.inputEnabled == nil || profileItem.inputEnabled == true) {
                            switch profileItem.fieldType {
                            case .Photo:
                                break
                                
                            case .Title:
                                builder.title = value.trimWhitespace()
                                
                            case .HireDate:
                                builder.hireDate = value
                                
                            }
                        }
                    }
                }
            }
        }
        builder.contactMethods = contactMethods
        Services.Profile.Actions.updateProfile(try! builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthenticationViewController.updateUserProfile(profile)
            }
            completion()
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
}
