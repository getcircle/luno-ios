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
    @IBOutlet weak private(set) var rootContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var rootScrollView: UIScrollView!
    
    var editProfileDelegate: EditProfileDelegate?
    var profile: Services.Profile.Containers.ProfileV1!

    private var existingContactMethodsByType = Dictionary<Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1, Services.Profile.Containers.ContactMethodV1>()
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
            }
        }
        
        formBuilder.sections.extend(formSections)
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
        let builder = profile.toBuilder()
        builder.verified = true
        
        formBuilder.updateValues()
        var contactMethods = Array<Services.Profile.Containers.ContactMethodV1>()
        for section in formBuilder.sections {
            for item in section.items {
                if let value = item.value {
                    if let contactItem = item as? FormBuilder.ContactSectionItem {
                        if value.trimWhitespace() != "" && (contactItem.inputEnabled == nil || contactItem.inputEnabled == true) {
                            var contactMethod: Services.Profile.Containers.ContactMethodV1Builder
                            if let existingContactMethod = existingContactMethodsByType[contactItem.contactMethodType] {
                                contactMethod = existingContactMethod.toBuilder()
                            }
                            else {
                                contactMethod = Services.Profile.Containers.ContactMethodV1.builder()
                            }

                            contactMethod.label = contactItem.placeholder
                            contactMethod.value = value.trimWhitespace()
                            contactMethod.contactMethodType = contactItem.contactMethodType
                            contactMethods.append(contactMethod.build())
                        }
                    }
                }
            }
        }
        builder.contactMethods = contactMethods
        Services.Profile.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
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
