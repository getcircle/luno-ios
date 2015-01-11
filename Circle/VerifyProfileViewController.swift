//
//  VerifyProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class VerifyProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak private(set) var profileImageView: UIImageView!
    @IBOutlet weak private(set) var editImageButton: UIButton!
    @IBOutlet weak private(set) var firstNameField: UITextField!
    @IBOutlet weak private(set) var lastNameField: UITextField!
    @IBOutlet weak private(set) var titleField: UITextField!
    
    private var nextButton: UIBarButtonItem!
    private var profile: ProfileService.Containers.Profile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureNavigationButtons()
        populateData()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        profileImageView.makeItCircular(false)
        editImageButton.layer.cornerRadiusWithMaskToBounds(profileImageView.frameWidth/2.0)
        
        editImageButton.tintColor = UIColor.whiteColor()
        editImageButton.setImage(
            editImageButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )
        
        firstNameField.addBottomBorder()
        lastNameField.addBottomBorder()
        titleField.addBottomBorder()
    }
    
    private func configureNavigationButtons() {
        title = "Welcome to Circle"
        nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextButtonTapped:")
        // nextButton.enabled = false
        navigationItem.rightBarButtonItem = nextButton
    }
    
    // MARK: - Data Source
    
    private func populateData() {
        profile = AuthViewController.getLoggedInUserProfile()
    
        firstNameField.text = profile.first_name
        lastNameField.text = profile.last_name
        titleField.text = profile.title
        profileImageView.setImageWithProfile(profile)
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(sender: AnyObject!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tagSelectorVC = storyboard.instantiateViewControllerWithIdentifier("TagSelectorViewController") as TagSelectorViewController
        navigationController?.pushViewController(tagSelectorVC, animated: true)
    }
    
    @IBAction func editImageButtonTapped(sender: AnyObject!) {
    
    }
}
