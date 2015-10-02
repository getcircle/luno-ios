//
//  EditTeamViewController.swift
//  Circle
//
//  Created by Ravi Rani on 6/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

protocol EditTeamViewControllerDelegate {
    func onTeamDetailsUpdated(team: Services.Organization.Containers.TeamV1)
}

class EditTeamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak private(set) var teamNameField: UITextField!
    @IBOutlet weak private(set) var teamNameFieldLabel: UILabel!
    @IBOutlet weak private(set) var teamDescriptionField: UITextView!
    @IBOutlet weak private(set) var teamDescriptionFieldLabel: UILabel!
    @IBOutlet weak private(set) var teamDescriptionFieldLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var teamDescriptionFieldLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var teamDescriptionFieldContainerView: UIView!
    @IBOutlet weak private(set) var teamDescriptionFieldContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var scrollView: UIScrollView!
    @IBOutlet weak private(set) var contentViewHeightConstraint: NSLayoutConstraint!

    private weak var saveButton: UIBarButtonItem?
    
    var editTeamViewControllerDelegate: EditTeamViewControllerDelegate?
    var team: Services.Organization.Containers.TeamV1!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
        configureView()
        configureTeamNameFieldLabel()
        configureTeamNameField()
        configureTeamDescriptionFieldLabel()
        configureTeamDescriptionField()
        configureNavBar()

        populateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        teamNameField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateLayoutToFitDescription()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureTeamNameFieldLabel() {
        teamNameFieldLabel.textColor = UIColor.appSecondaryTextColor()
        teamNameFieldLabel.attributedText = NSAttributedString.headerText(AppStrings.TeamNameFieldLabel.localizedUppercaseString())
    }
    
    private func configureTeamNameField() {
        teamNameField.font = UIFont.mainTextFont()
        teamNameField.textColor = UIColor.appPrimaryTextColor()
    }
    
    private func configureTeamDescriptionFieldLabel() {
        teamDescriptionFieldLabel.textColor = UIColor.appSecondaryTextColor()
        teamDescriptionFieldLabel.attributedText = NSAttributedString.headerText(AppStrings.GroupDescriptionSectionTitle.localizedUppercaseString())
    }
    
    private func configureTeamDescriptionField() {
        teamDescriptionField.font = UIFont.mainTextFont()
        teamDescriptionField.textColor = UIColor.appSecondaryTextColor()
        teamDescriptionField.text = AppStrings.TeamDescriptionFieldPlaceholder
    }
    
    private func configureNavBar() {
        addCancelTextButtonWithAction("close:")
        saveButton = addSaveTextButtonWithAction("done:")
        saveButton?.enabled = false
        title = AppStrings.TeamEditButtonTitle
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWasShown(notification: NSNotification) {
        if teamDescriptionField.isFirstResponder() {
            if let info = notification.userInfo, keyboardFrame = info[UIKeyboardFrameEndUserInfoKey], keyboardRect = keyboardFrame.CGRectValue {
                let keyboardSize = keyboardRect.size
                
                scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
                scrollView.scrollIndicatorInsets = scrollView.contentInset
    
                scrollView.scrollRectToVisible(teamDescriptionFieldContainerView.frame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = scrollView.contentInset;
    }
    
    // MARK: - Data
    
    private func populateData() {
        if team.hasName {
            teamNameField.text = team.name
        }
        
        if team.hasDescription && team.description_.value.characters.count > 0 {
            teamDescriptionField.text = team.description_.value
            teamDescriptionField.textColor = UIColor.appPrimaryTextColor()
        }
    }
    
    private func updateLayoutToFitDescription() {
        teamDescriptionFieldContainerViewHeightConstraint.constant = max(100, teamDescriptionField.intrinsicContentSize().height + teamDescriptionFieldLabelTopConstraint.constant + teamDescriptionFieldLabelBottomConstraint.constant)
        contentViewHeightConstraint.constant = teamDescriptionFieldContainerView.frameBottom
        scrollView.contentSize = CGSizeMake(view.bounds.size.width, contentViewHeightConstraint.constant)
    }
    
    // MARK: - UITextFieldDelegate

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let finalString = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            let nameMatches = (finalString == team.name)
            let descriptionMatches = (team.hasDescription && teamDescriptionField.text == team.description_.value) || (!team.hasDescription && teamDescriptionField.text.trimWhitespace().characters.count == 0)
            saveButton?.enabled = !(nameMatches && descriptionMatches)
        }

        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        let nameMatches = (teamNameField.text == team.name)
        let descriptionMatches = (team.hasDescription && teamDescriptionField.text == team.description_.value) || (!team.hasDescription && teamDescriptionField.text.trimWhitespace().characters.count == 0)
        saveButton?.enabled = !(nameMatches && descriptionMatches)

        updateLayoutToFitDescription()
        view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == AppStrings.TeamDescriptionFieldPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.appPrimaryTextColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = AppStrings.TeamDescriptionFieldPlaceholder
            textView.textColor = UIColor.appSecondaryTextColor()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {

        guard let teamName = teamNameField.text?.trimWhitespace() where teamName != "" else {
            showToast(AppStrings.TeamNameErrorCannotBeEmpty, title: AppStrings.GenericErrorDialogTitle)
            return
        }
        
        let teamBuilder = try! team.toBuilder()
        teamBuilder.name = teamName
        
        let teamDescription = teamDescriptionField.text.trimWhitespace()
        if teamDescription.characters.count == 0 {
            teamBuilder.clearDescription()
        }
        else {
            let descriptionBuilder: Services.Common.Containers.DescriptionV1.Builder
            if let description = teamBuilder.description_ {
                descriptionBuilder = try! description.toBuilder()
            } else {
                descriptionBuilder = Services.Common.Containers.DescriptionV1.Builder()
            }
            descriptionBuilder.value = teamDescription
            
            teamBuilder.description_ = try! descriptionBuilder.build()
        }
        
        let updatedTeam = try! teamBuilder.build()
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        Services.Organization.Actions.updateTeam(updatedTeam, completionHandler: { (team, error) -> Void in
            if let team = team {
                self.editTeamViewControllerDelegate?.onTeamDetailsUpdated(team)
            }
            hud.hide(true)
            self.close(sender)
        })
    }

    @IBAction func close(sender: AnyObject!) {
        teamNameField.resignFirstResponder()
        teamDescriptionField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
