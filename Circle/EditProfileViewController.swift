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
    
    @IBOutlet weak private(set) var rootContentView: UIView!
    @IBOutlet weak private(set) var rootScrollView: UIScrollView!
    
    var editProfileDelegate: EditProfileDelegate?
    var profile: ProfileService.Containers.Profile!
    private var formBuilder = FormBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureScrollView()
        configureContentView()
        configureNavigationButtons()
        configureFormFields()
        populateData()
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
                    FormBuilder.SectionItem(
                        placeholder: NSLocalizedString("Cell Phone", comment: "Placeholder for textfield that accepts a cell phone"),
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "cell_phone"
                    ),
                    FormBuilder.SectionItem(
                        placeholder: NSLocalizedString("Work Phone", comment: "Placeholder for textfield that accepts a work phone"),
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "work_phone"
                    )
            ]),
            FormBuilder.Section(
                title: AppStrings.QuickActionEmailLabel,
                imageSource: "TitleEmail",
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
                title: AppStrings.QuickActionMessageLabel,
                imageSource: "TitleChat",
                items: [
                    FormBuilder.SectionItem(
                        placeholder: "Slack",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "slack"
                    ),
                    FormBuilder.SectionItem(
                        placeholder: "HipChat",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "hip_chat"
                    ),
                    FormBuilder.SectionItem(
                        placeholder: "Facebook Messenger",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "messenger"
                    ),
                    FormBuilder.SectionItem(
                        placeholder: "Sms",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "cell_phone"
                    ),
                    FormBuilder.SectionItem(
                        placeholder: "Twitter",
                        type: .TextField,
                        keyboardType: .PhonePad,
                        container: "profile",
                        containerKey: "twitter"
                    ),
            ]),
            FormBuilder.Section(
                title: AppStrings.QuickActionVideoLabel,
                imageSource: "TitleVideo",
                items: [
                    FormBuilder.SectionItem(
                        placeholder: "Skype",
                        type: .TextField,
                        keyboardType: .EmailAddress,
                        container: "profile",
                        containerKey: "skype"
                    ),
                    FormBuilder.SectionItem(
                        placeholder: "Hangouts",
                        type: .TextField,
                        keyboardType: .EmailAddress,
                        container: "profile",
                        containerKey: "hangouts"
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

    // MARK: - Data
    
    private func populateData() {

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
        let contentInsets = UIEdgeInsetsZero;
        rootScrollView.contentInset = contentInsets;
        rootScrollView.scrollIndicatorInsets = contentInsets;
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
