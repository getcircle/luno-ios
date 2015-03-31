//
//  NotificationsViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak private(set) var notificationTextLabel: UILabel!
    @IBOutlet weak private(set) var yesButton: UIButton!
    @IBOutlet weak private(set) var noButton: UIButton!
    
    var goToPhoneVerification = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        configureNotificationTextLabel()
        configureButtons()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
        navigationController?.navigationBar.makeTransparent()
        extendedLayoutIncludesOpaqueBars = true
        title = AppStrings.NotificationsTitle
    }
    
    private func configureNotificationTextLabel() {
        notificationTextLabel.text = AppStrings.NotificationInfoText
    }

    private func configureButtons() {
        yesButton.setTitle(AppStrings.GenericYesButtonTitle, forState: .Normal)
        yesButton.setTitleColor(UIColor.appDefaultLightTextColor(), forState: .Normal)
        yesButton.backgroundColor = UIColor.appTintColor()
        yesButton.addRoundCorners(radius: 2.0)

        noButton.setTitle(AppStrings.GenericNoThanksButtonTitle, forState: .Normal)
        noButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        noButton.backgroundColor = UIColor.appUIBackgroundColor()
        noButton.addRoundCorners(radius: 2.0)
    }
    
    private func configureNavButtons() {
        addDoneButtonWithAction("doneButtonTapped:")
    }
    
    // MARK: - IBActions

    @IBAction func yesButtonTapped(sender: AnyObject!) {
        dismissView { () -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.registerForRemoteNotifications()
        }
    }

    @IBAction func noButtonTapped(sender: AnyObject!) {
        dismissView(nil)
    }

    @IBAction func doneButtonTapped(sender: AnyObject!) {
        dismissView(nil)
    }
    
    private func dismissView(completionHandler: (() -> Void)?) {
        dismissViewControllerAnimated(true, completion: completionHandler)
    }
}
