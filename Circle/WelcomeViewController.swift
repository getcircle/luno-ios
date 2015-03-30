//
//  WelcomeViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/29/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak private(set) var welcomeTitleLabel: UILabel!
    @IBOutlet weak private(set) var welcomeTextLabel: UILabel!
    @IBOutlet weak private(set) var getStartedButton: UIButton!

    var goToPhoneVerification = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureWelcomeTextLabel()
        configureGetStartedButton()
    }
    
    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
        navigationController?.navigationBar.makeTransparent()
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureWelcomeTitleLabel() {
        welcomeTitleLabel.text = AppStrings.WelcomeTitleText
    }
    
    private func configureWelcomeTextLabel() {
        welcomeTextLabel.text = AppStrings.WelcomeInfoText
    }
    
    private func configureGetStartedButton() {
        getStartedButton.setCustomAttributedTitle(
            AppStrings.GenericGetStartedButtonTitle.localizedUppercaseString(),
            forState: .Normal, 
            withColor: UIColor.appTintColor()
        )

        getStartedButton.addRoundCorners(radius: 2.0)
        getStartedButton.backgroundColor = UIColor.whiteColor()
        getStartedButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
    }
    
    // MARK: - IBActions
    
    @IBAction func getStartedButtonTapped(sender: AnyObject!) {
        if goToPhoneVerification {
            let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
            navigationController?.pushViewController(verifyPhoneNumberVC, animated: true)
        }
        else {
            let verifyProfileVC = VerifyProfileViewController(nibName: "VerifyProfileViewController", bundle: nil)
            navigationController?.pushViewController(verifyProfileVC, animated: true)
        }
    }
}
