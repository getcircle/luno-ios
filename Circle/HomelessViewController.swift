//
//  HomelessViewController.swift
//  Circle
//
//  Created by Michael Hahn on 2/10/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class HomelessViewController: UIViewController {
    
    @IBOutlet weak private(set) var infoLabel: UILabel!
    @IBOutlet weak private(set) var confirmationLabel: UILabel!
    @IBOutlet weak private(set) var requestAccessButton: UIButton!
    @IBOutlet weak private(set) var tryAgainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.makeTransparent()
        configureView()
        configureInfoLabel()
        configureConfirmationLabel()
        configureRequestAccessButton()
        configureTryAgainButton()
        updateUIAsPerRequestStatus()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
    }

    private func configureInfoLabel() {
        infoLabel.textColor = UIColor.appDefaultLightTextColor()
        infoLabel.text = AppStrings.PrivateBetaInfoText
    }
    
    private func configureConfirmationLabel() {
        confirmationLabel.textColor = UIColor.appDefaultLightTextColor()
        confirmationLabel.text = AppStrings.RequestAccessConfirmationTest
        confirmationLabel.alpha = 0.0
    }
    
    private func configureRequestAccessButton() {
        requestAccessButton.addRoundCorners(radius: 2.0)
        requestAccessButton.setCustomAttributedTitle(
            AppStrings.RequestAccessButtonTitle.localizedUppercaseString(),
            forState: .Normal
        )
        requestAccessButton.backgroundColor = UIColor.appTintColor()
        requestAccessButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
    }
    
    private func configureTryAgainButton() {
        tryAgainButton.addRoundCorners(radius: 2.0)
        tryAgainButton.setCustomAttributedTitle(
            AppStrings.GenericTryAgainButtonTitle.localizedUppercaseString(),
            forState: .Normal,
            withColor: UIColor.appTintColor()
        )
        tryAgainButton.backgroundColor = UIColor.whiteColor()
        tryAgainButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
    }

    // MARK: - Status check
    
    private func updateUIAsPerRequestStatus() {
        if let loggedInUser = AuthViewController.getLoggedInUser() {
            if let alreadyRequestedAccessUserID = NSUserDefaults.standardUserDefaults().objectForKey("requested_access_to_app") as? String {
                if alreadyRequestedAccessUserID == loggedInUser.id {
                    requestAccessButton.alpha = 0.0
                    infoLabel.text = AppStrings.WaitlistInfoText
                    tryAgainButton.setCustomAttributedTitle(
                        AppStrings.SignOutButtonTitle.localizedUppercaseString(),
                        forState: .Normal,
                        withColor: UIColor.appTintColor()
                    )
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func requestAccessButtonTapped() {
        UserService.Actions.requestAccess { (access_request, error) -> Void in
            if access_request != nil {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.requestAccessButton.alpha = 0.0
                    self.confirmationLabel.alpha = 1.0
                })
                
                NSUserDefaults.standardUserDefaults().setObject(access_request!.user_id, forKey: "requested_access_to_app")
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                println("Error requesting access: \(error)")
            }
        }
    }
    
    @IBAction func tryAgainButtonTapped() {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            AuthViewController.logOut(shouldDisconnect: true)
        })
    }
}
