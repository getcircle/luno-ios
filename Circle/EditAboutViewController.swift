//
//  EditAboutViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditAboutViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak private(set) var bioSectionLabel: UILabel!
    @IBOutlet weak private(set) var bioTextField: UITextField!
    @IBOutlet weak private(set) var otherSectionLabel: UILabel!
    @IBOutlet weak private(set) var nickNameLabel: UILabel!
    @IBOutlet weak private(set) var nickNameTextField: UITextField!
    
    private var allControls = [AnyObject]()
    
    var profile: ProfileService.Containers.Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set for this view controller")
        configureView()
        configureNavigationBar()
        configureSectionLabels()
        configureBioTextField()
        configureNickNameFields()
        populateData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bioTextField.becomeFirstResponder()
    }
    
    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureNavigationBar() {
        title = AppStrings.ProfileSectionAboutTitle
        addDoneButtonWithAction("done:")
        addCloseButtonWithAction("cancel:")
    }
    
    private func configureSectionLabels() {
        for label in [bioSectionLabel, otherSectionLabel] {
            label.textColor = UIColor.appAttributeTitleLabelColor()
            label.font = UIFont.appAttributeTitleLabelFont()
        }
        
        bioSectionLabel.text = AppStrings.ProfileSectionBioTitle.uppercaseStringWithLocale(NSLocale.currentLocale())
        otherSectionLabel.text = AppStrings.ProfileSectionOtherTitle.uppercaseStringWithLocale(NSLocale.currentLocale())
    }
    
    private func configureBioTextField() {
        allControls.append(bioTextField)
    }
    
    private func configureNickNameFields() {
        nickNameLabel.font = UIFont.appAttributeTitleLabelFont()
        nickNameLabel.textColor = UIColor.appAttributeTitleLabelColor()
        nickNameTextField.font = UIFont.appAttributeValueLabelFont()
        nickNameTextField.textColor = UIColor.appAttributeValueLabelColor()
        allControls.append(nickNameTextField)
    }
    
    private func populateData() {
        if profile.hasAbout {
            bioTextField.text = profile.about
        }

        //TODO: Replace with Nickname
        if profile.hasFirstName {
            nickNameTextField.text = profile.first_name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        updateProfile { () -> Void in
            self.dismissView()
        }
    }

    @IBAction func cancel(sender: AnyObject!) {
        dismissView()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == bioTextField {
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
        builder.about = bioTextField.text
        builder.first_name = nickNameTextField.text
        ProfileService.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            completion()
        }
    }
}
