//
//  EditAboutViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditAboutViewController: UIViewController, UITextViewDelegate {

    enum Themes {
        case Onboarding
        case Regular
    }
    
    @IBOutlet weak private(set) var aboutTitleTextLabel: UILabel!
    @IBOutlet weak private(set) var bioSectionLabel: UILabel!
    @IBOutlet weak private(set) var bioTextView: UITextView!
    @IBOutlet weak private(set) var otherSectionLabel: UILabel!
    @IBOutlet weak private(set) var nickNameLabel: UILabel!
    @IBOutlet weak private(set) var nickNameTextField: UITextField!
    
    private var allControls = [AnyObject]()

    var addNextButton: Bool = false
    var profile: Services.Profile.Containers.ProfileV1!
    var theme: Themes = .Regular

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set for this view controller")
        configureView()
        configureNavigationBar()
        configureSectionLabels()
        configureTextFields()
        populateData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bioTextView.becomeFirstResponder()
    }
    
    // MARK: - Configuration

    private func configureView() {
        switch theme {
        case .Regular:
            view.backgroundColor = UIColor.appViewBackgroundColor()
            aboutTitleTextLabel.textColor = UIColor.appDefaultDarkTextColor()

        case .Onboarding:
            view.backgroundColor = UIColor.appUIBackgroundColor()
            aboutTitleTextLabel.textColor = UIColor.appDefaultLightTextColor()
        }
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureNavigationBar() {
        title = AppStrings.ProfileSectionAboutTitle
        if addNextButton {
            addNextButtonWithAction("done:")
        }
        else {
            addDoneButtonWithAction("done:")
        }
        
        if isBeingPresentedModally() {
            addCloseButtonWithAction("cancel:")
        }
    }
    
    private func configureSectionLabels() {
        for label in [bioSectionLabel, otherSectionLabel] {
            label.textColor = UIColor.appAttributeTitleLabelColor()
            label.font = UIFont.appAttributeTitleLabelFont()
        }
        
        bioSectionLabel.text = AppStrings.ProfileSectionBioTitle.localizedUppercaseString()
        otherSectionLabel.text = AppStrings.ProfileSectionOtherTitle.localizedUppercaseString()
    }

    private func configureTextFields() {
        allControls.append(bioTextView)

        nickNameLabel.font = UIFont.appAttributeTitleLabelFont()
        nickNameLabel.textColor = UIColor.appAttributeTitleLabelColor()
        nickNameTextField.font = UIFont.appAttributeValueLabelFont()
        nickNameTextField.textColor = UIColor.appAttributeValueLabelColor()
        allControls.append(nickNameTextField)
        
        switch theme {
        case .Regular:
            bioTextView.keyboardAppearance = .Light
            nickNameTextField.keyboardAppearance = .Light
            
        case .Onboarding:
            bioTextView.keyboardAppearance = .Dark
            nickNameTextField.keyboardAppearance = .Dark
        }
    }
    
    private func populateData() {
        if profile.hasAbout {
            bioTextView.text = profile.about
        }

        if profile.hasNickname {
            nickNameTextField.text = profile.nickname
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        updateProfile { () -> Void in
            if self.addNextButton {
                self.goToNextVC()
            }
            else {
                self.dismissView()
            }
        }
    }

    @IBAction func cancel(sender: AnyObject!) {
        dismissView()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == bioTextView {
            nickNameTextField.becomeFirstResponder()
        }
        else {
            done(textField)
        }
        return true
    }
    
    // MARK: - Helpers
    
    private func dismissView() {
        dismissKeyboard()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func dismissKeyboard() {
        for control in allControls {
            if control.isFirstResponder() {
                control.resignFirstResponder()
                break
            }
        }
    }
    
    private func updateProfile(completion: () -> Void) {
        let builder = profile.toBuilder()
        if bioTextView.text.trimWhitespace() != "" {
            builder.about = bioTextView.text
        }
        
        builder.nickname = nickNameTextField.text
        Services.Profile.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            completion()
        }
    }
    
    // MARK: - IBActions
    
    private func goToNextVC() {
        // TODO: Check for hire date and go to projects
        // If hire date is under two weeks, show skills or interests
//        if ABTestUtils.shouldShowInterests() {
            let interestSelectorVC = TagScrollingSelectorViewController(nibName: "TagScrollingSelectorViewController", bundle: nil)
            interestSelectorVC.theme = .Onboarding
            interestSelectorVC.addNextButton = true
            navigationController?.pushViewController(interestSelectorVC, animated: true)
//        }
//        else {
//            let tagInputViewController = TagInputViewController(theme: .Onboarding)
//            tagInputViewController.addNextButton = true
//            navigationController?.pushViewController(tagInputViewController, animated: true)
//        }
    }
}
