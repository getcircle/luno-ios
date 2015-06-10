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

class EditTeamViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak private(set) var teamNameField: UITextField!
    @IBOutlet weak private(set) var teamNameFieldLabel: UILabel!

    var editTeamViewControllerDelegate: EditTeamViewControllerDelegate?
    var team: Services.Organization.Containers.TeamV1!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureTeamNameFieldLabel()
        configureTeamNameField()
        configureNavBar()

        populateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        teamNameField.becomeFirstResponder()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureTeamNameFieldLabel() {
        teamNameFieldLabel.textColor = UIColor.appAttributeTitleLabelColor()
        teamNameFieldLabel.font = UIFont.appAttributeTitleLabelFont()
        teamNameFieldLabel.text = AppStrings.TeamNameFieldLabel.localizedUppercaseString()
    }
    
    private func configureTeamNameField() {
        teamNameField.font = UIFont.appAttributeValueLabelFont()
        teamNameField.textColor = UIColor.appAttributeValueLabelColor()
    }
    
    private func configureNavBar() {
        addCloseButtonWithAction("close:")
        addDoneButtonWithAction("done:")
        title = AppStrings.TeamEditButtonTitle
    }
    
    // MARK: - Data
    
    private func populateData() {
        if team.hasName {
            teamNameField.text = team.name
        }
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        
        if teamNameField.text.trimWhitespace() == "" {
            showToast(AppStrings.TeamNameErrorCannotBeEmpty, title: AppStrings.GenericErrorDialogTitle)
            return
        }
        
        let teamNameBuilder = team.toBuilder()
        teamNameBuilder.name = teamNameField.text.trimWhitespace()
        let updatedTeam = teamNameBuilder.build()
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        Services.Organization.Actions.updateTeam(updatedTeam, completionHandler: { (team, error) -> Void in
            self.editTeamViewControllerDelegate?.onTeamDetailsUpdated(self.team)
            hud.hide(true)
            self.close(sender)
        })
    }

    @IBAction func close(sender: AnyObject!) {
        teamNameField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
