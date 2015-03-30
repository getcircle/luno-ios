//
//  HomelessViewController.swift
//  Circle
//
//  Created by Michael Hahn on 2/10/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

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
            AppStrings.RequestAccessButtonTitle.uppercaseStringWithLocale(NSLocale.currentLocale()),
            forState: .Normal
        )
        requestAccessButton.backgroundColor = UIColor.appTintColor()
        requestAccessButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
    }
    
    private func configureTryAgainButton() {
        tryAgainButton.addRoundCorners(radius: 2.0)
        tryAgainButton.setCustomAttributedTitle(
            AppStrings.TryAgainButtonTitle.uppercaseStringWithLocale(NSLocale.currentLocale()),
            forState: .Normal,
            withColor: UIColor.appTintColor()
        )
        tryAgainButton.backgroundColor = UIColor.whiteColor()
        tryAgainButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
    }

    // MARK: - IBActions
    
    @IBAction func requestAccessButtonTapped() {
        // TODO: Make API Call here
    }
    
    @IBAction func tryAgainButtonTapped() {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            AuthViewController.logOut()
        })
    }
}
