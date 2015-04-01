//
//  EditContactInfoViewController.swift
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

class EditContactInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak private(set) var rootContentView: UIView!
    @IBOutlet weak private(set) var rootScrollView: UIScrollView!
    
    var editProfileDelegate: EditProfileDelegate?
    var profile: ProfileService.Containers.Profile!

    private var existingContactMethodsByType = Dictionary<ProfileService.ContactMethodType, ProfileService.Containers.ContactMethod>()
    private var formBuilder = FormBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureScrollView()
        configureContentView()
        configureNavigationButtons()
        configureFormFields()
        formBuilder.build(rootContentView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        var maxY: CGFloat = 0.0
        var heightOfTheLastElement: CGFloat = 0.0
        for subview in rootContentView.subviews {
            if subview.frameY >= maxY {
                maxY = subview.frameY
                heightOfTheLastElement = subview.frameHeight
            }
        }

        rootScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, maxY + heightOfTheLastElement + 100.0)
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
        rootContentView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        rootContentView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)
    }
    
    private func configureFormFields() {
        var formSections = [
            FormBuilder.Section(
                title: AppStrings.QuickActionCallLabel,
                imageSource: "TitlePhone",
                items: [
                    FormBuilder.ContactSectionItem(
                        placeholder: AppStrings.ContactLabelCellPhone,
                        type: .TextField,
                        keyboardType: .PhonePad,
                        contactMethodType: .CellPhone
                    ),
                    FormBuilder.ContactSectionItem(
                        placeholder: AppStrings.ContactLabelWorkPhone,
                        type: .TextField,
                        keyboardType: .PhonePad,
                        contactMethodType: .Phone
                    )
            ]),
            FormBuilder.Section(
                title: AppStrings.QuickActionEmailLabel,
                imageSource: "TitleEmail",
                items: [
                FormBuilder.ContactSectionItem(
                    placeholder: AppStrings.ContactLabelWorkEmail,
                    type: .TextField,
                    keyboardType: .EmailAddress,
                    contactMethodType: .Email
                ),
                FormBuilder.ContactSectionItem(
                    placeholder: AppStrings.ContactLabelPersonalEmail,
                    type: .TextField,
                    keyboardType: .EmailAddress,
                    contactMethodType: .Email
                )
            ]),
            FormBuilder.Section(
                title: AppStrings.QuickActionMessageLabel,
                imageSource: "TitleChat",
                items: [
                    FormBuilder.ContactSectionItem(
                        placeholder: "Slack",
                        type: .TextField,
                        keyboardType: .ASCIICapable,
                        contactMethodType: .Slack
                    ),
                    FormBuilder.ContactSectionItem(
                        placeholder: "Hipchat",
                        type: .TextField,
                        keyboardType: .ASCIICapable,
                        contactMethodType: .Hipchat
                    ),
                    FormBuilder.ContactSectionItem(
                        placeholder: "Facebook",
                        type: .TextField,
                        keyboardType: .ASCIICapable,
                        contactMethodType: .Facebook
                    ),
                    FormBuilder.ContactSectionItem(
                        placeholder: "SMS",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        contactMethodType: .CellPhone
                    ),
                    FormBuilder.ContactSectionItem(
                        placeholder: "Twitter",
                        type: .TextField,
                        keyboardType: .Twitter,
                        contactMethodType: .Twitter
                    ),
            ]),
            FormBuilder.Section(
                title: AppStrings.QuickActionVideoLabel,
                imageSource: "TitleVideo",
                items: [
                    FormBuilder.ContactSectionItem(
                        placeholder: "Skype",
                        type: .TextField,
                        keyboardType: .ASCIICapable,
                        contactMethodType: .Skype
                    ),
                    FormBuilder.ContactSectionItem(
                        placeholder: "Hangouts",
                        type: .TextField,
                        keyboardType: .EmailAddress,
                        contactMethodType: .Skype
                    )
            ]),
        ]
        
        for contactMethod in profile.contact_methods {
            existingContactMethodsByType.updateValue(contactMethod, forKey: contactMethod.type)
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
            }
        }
        
        formBuilder.sections.extend(formSections)
    }
    
    private func configureView() {
        title = AppStrings.ProfileSectionContactPreferencesTitle
        view.backgroundColor = UIColor.appViewBackgroundColor()
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
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
        let contentInsets = UIEdgeInsetsZero
        rootScrollView.contentInset = contentInsets
        rootScrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - Helpers

    private func updateProfile(completion: () -> Void) {
        let builder = profile.toBuilder()
        builder.verified = true
        
        formBuilder.updateValues()
        var contactMethods = Array<ProfileService.Containers.ContactMethod>()
        for section in formBuilder.sections {
            for item in section.items {
                if let value = item.value {
                    if let contactItem = item as? FormBuilder.ContactSectionItem {
                        if value.trimWhitespace() != "" && (contactItem.inputEnabled == nil || contactItem.inputEnabled == true) {
                            var contactMethod: ProfileService.Containers.ContactMethodBuilder
                            if let existingContactMethod = existingContactMethodsByType[contactItem.contactMethodType] {
                                contactMethod = existingContactMethod.toBuilder()
                            }
                            else {
                                contactMethod = ProfileService.Containers.ContactMethod.builder()
                            }

                            contactMethod.label = contactItem.placeholder
                            contactMethod.value = value.trimWhitespace()
                            contactMethod.type = contactItem.contactMethodType
                            contactMethods.append(contactMethod.build())
                        }
                    }
                }
            }
        }
        builder.contact_methods = contactMethods
        ProfileService.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
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
