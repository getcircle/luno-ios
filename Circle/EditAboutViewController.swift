//
//  EditAboutViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditAboutViewController: UIViewController {

    @IBOutlet weak private(set) var bioTextView: UITextView!
    
    private var allControls = [AnyObject]()
    
    var profile: ProfileService.Containers.Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set for this view controller")
        configureView()
        configureNavigationBar()
        configureAboutTextView()
        populateData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bioTextView.becomeFirstResponder()
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
    
    private func configureAboutTextView() {
        bioTextView.addRoundCorners(radius: 3.0)
        bioTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bioTextView.layer.borderWidth = 1.0
        allControls.append(bioTextView)
    }
    
    private func populateData() {
        if profile.hasAbout {
            bioTextView.text = profile.about
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
        builder.about = bioTextView.text
        ProfileService.Actions.updateProfile(builder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            completion()
        }
    }
}
