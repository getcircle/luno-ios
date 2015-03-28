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

    @IBOutlet weak private(set) var bioLabel: UILabel!
    @IBOutlet weak private(set) var bioTextField: UITextField!
    
    private var allControls = [AnyObject]()
    
    var profile: ProfileService.Containers.Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set for this view controller")
        configureView()
        configureNavigationBar()
        configureBioLabel()
        configureBioTextField()
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
    
    private func configureBioLabel() {
        bioLabel.textColor = UIColor.appAttributeTitleLabelColor()
        bioLabel.font = UIFont.appAttributeTitleLabelFont()
        bioLabel.text = AppStrings.ProfileSectionBioTitle.uppercaseStringWithLocale(NSLocale.currentLocale())
    }
    
    private func configureBioTextField() {
        allControls.append(bioTextField)
    }
    
    private func populateData() {
        if profile.hasAbout {
            bioTextField.text = profile.about
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
        done(textField)
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
        ProfileService.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            completion()
        }
    }
}
