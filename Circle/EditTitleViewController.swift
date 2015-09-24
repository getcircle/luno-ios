//
//  EditTitleViewController.swift
//  Circle
//
//  Created by Ravi Rani on 8/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class EditTitleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak private(set) var titleNameField: UITextField!
    @IBOutlet weak private(set) var titleNameFieldLabel: UILabel!
    
    var editProfileDelegate: EditProfileDelegate?
    var profile: Services.Profile.Containers.ProfileV1!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        configureTitleNameFieldLabel()
        configureTitleNameField()
        configureNavBar()
        
        populateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleNameField.becomeFirstResponder()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureTitleNameFieldLabel() {
        titleNameFieldLabel.textColor = UIColor.appAttributeTitleLabelColor()
        titleNameFieldLabel.font = UIFont.appAttributeTitleLabelFont()
        titleNameFieldLabel.text = AppStrings.TitleFieldLabel.localizedUppercaseString()
    }
    
    private func configureTitleNameField() {
        titleNameField.font = UIFont.appAttributeValueLabelFont()
        titleNameField.textColor = UIColor.appAttributeValueLabelColor()
    }
    
    private func configureNavBar() {
        addCloseButtonWithAction("close:")
        addDoneButtonWithAction("done:")
        title = AppStrings.TitleEditButtonTitle
    }
    
    // MARK: - Data
    
    private func populateData() {
        if profile.hasTitle {
            titleNameField.text = profile.title
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        
        guard let title = titleNameField.text?.trimWhitespace() where title != "" else {
            showToast(AppStrings.TitleErrorCannotBeEmpty, title: AppStrings.GenericErrorDialogTitle)
            return
        }
        
        let profileBuilder = try! profile.toBuilder()
        profileBuilder.title = title
        let updatedProfile = try! profileBuilder.build()
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        Services.Profile.Actions.updateProfile(updatedProfile, completionHandler: { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
                self.editProfileDelegate?.didFinishEditingProfile()
            }
            hud.hide(true)
            self.close(sender)
        })
    }
    
    @IBAction func close(sender: AnyObject!) {
        titleNameField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
