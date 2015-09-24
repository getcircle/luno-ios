//
//  SplashViewController.swift
//  Circle
//
//  Created by Ravi Rani on 5/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appNameYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var getStartedButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // TODO: Possibly try silent authentication
        configureAppNameLabel()
        configureGoogleAuthentication()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.makeTransparent()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delay(0.3) {
            self.moveAppNameLabel()
        }
    }

    // MARK: - Configuration
    
    private func configureAppNameLabel() {
        appNameLabel.text = NSBundle.appName()
    }

    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
    }
    
    private func configureGoogleAuthentication() {
        getStartedButton.alpha = 0.0
        getStartedButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
        getStartedButton.addRoundCorners(radius: 2.0)
        getStartedButton.backgroundColor = UIColor.appTintColor()
        getStartedButton.setCustomAttributedTitle(
            AppStrings.StartUsingAppCTA.localizedUppercaseString(),
            forState: .Normal
        )
        getStartedButton.addTarget(self, action: "getStartedButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Initial Animation
    
    private func moveAppNameLabel() {
        getStartedButtonBottomConstraint.constant = 20.0
        // appNameYConstraint.constant = 95.0
        appNameLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.appLogoImageView.layoutIfNeeded()
            self.appNameLabel.layoutIfNeeded()
            self.getStartedButton.layoutIfNeeded()
            self.tagLineLabel.layoutIfNeeded()
            self.getStartedButton.alpha = 1.0
            }, completion: { (completed: Bool) -> Void in
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func getStartedButtonTapped(sender: AnyObject) {
        let authenticationViewController = AuthenticationViewController(nibName: "AuthenticationViewController", bundle: nil)
        navigationController?.pushViewController(authenticationViewController, animated: true)
    }
}
