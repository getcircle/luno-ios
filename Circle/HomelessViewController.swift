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
    
    @IBOutlet weak private(set) var requestAccessButton: UIButton!
    @IBOutlet weak private(set) var tryAgainButton: UIButton!
    @IBOutlet weak private(set) var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.makeTransparent()
        configureView()
        configureInfoLabel()
        configureRequestAccessButton()
        configureTryAgainButton()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
    }

    private func configureInfoLabel() {
        infoLabel.textColor = UIColor.appDefaultLightTextColor()
        infoLabel.text = AppStrings.PrivateBetaInfoText
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

    // MARK: - IBActions
    
    @IBAction func requestAccessButtonTapped() {
        UserService.Actions.requestAccess { (access_request, error) -> Void in
            // TODO: Store API token so we don't re-enable the request button
            if access_request != nil {
                self.requestAccessButton.enabled = false
            } else {
                println("Error requesting access: \(error)")
            }
        }
    }
    
    @IBAction func tryAgainButtonTapped() {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            AuthViewController.logOut()
        })
    }
}
