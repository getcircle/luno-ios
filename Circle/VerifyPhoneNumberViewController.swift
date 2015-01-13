//
//  VerifyPhoneNumberViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class VerifyPhoneNumberViewController: UIViewController {
    
    @IBOutlet weak private(set) var textField: UITextField!
    
    private var actionButton: UIButton!
    private var resendButton: UIButton!
    private var changePhoneNumber: UIButton!
    private var activityIndicatorView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        textField.autoSetDimension(.Height, toSize: 50.0)
        textField.addBottomBorder()
        
        actionButton = UIButton.buttonWithType(.Custom) as UIButton
        actionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        actionButton.backgroundColor = UIColor.appTintColor()
        actionButton.setTitle("Send Code", forState: .Normal)
        actionButton.titleLabel?.font = UIFont(name: "Avenir Light", size: 17.0)
        actionButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        actionButton.addTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
        view.addSubview(actionButton)
        actionButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField, withOffset: 15)
        actionButton.autoMatchDimension(.Width, toDimension: .Width, ofView: textField)
        actionButton.autoAlignAxisToSuperviewAxis(.Vertical)
        
        resendButton = UIButton.buttonWithType(.Custom) as UIButton
        resendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    private func switchToConfirmation() {
        textField.removeConstraints(textField.constraints())
        textField.text = ""
        textField.autoSetDimension(.Height, toSize: 50.0)
        textField.placeholder = "Code"
        textField.autoCenterInSuperview()
        textField.autoSetDimension(.Width, toSize: 100.0)
        textField.setNeedsUpdateConstraints()
        
        actionButton.setTitle("Verify", forState: .Normal)
        actionButton.removeTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
        actionButton.addTarget(self, action: "verifyButtonTapped:", forControlEvents: .TouchUpInside)
        
        UIView.animateWithDuration(
            0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            }
        ) { (success) -> Void in
            self.textField.becomeFirstResponder()
            return
        }
    }
    
    func actionButtonTapped(sender: AnyObject!) {
        toggleLoadingState()
        let phoneNumber = textField.text
        if let user = AuthViewController.getLoggedInUser() {
            let userBuilder = user.toBuilder()
            userBuilder.phone_number = phoneNumber
            UserService.Actions.updateUser(userBuilder.build()) { (user, error) -> Void in
                if error == nil {
                    UserService.Actions.sendVerificationCode(user!) { (error) -> Void in
                        self.toggleLoadingState()
                        self.switchToConfirmation()
                        if error != nil {
                            println("error sending code to user: \(error)")
                        }
                    }
                } else {
                    println("error updating user: \(error)")
                }
            }
        }
    }
    
    func verifyButtonTapped(sender: AnyObject!) {
        self.toggleLoadingState()
        let code = textField.text
        if let user = AuthViewController.getLoggedInUser() {
            UserService.Actions.verifyVerificationCode(code, user: user) { (verified, error) -> Void in
                if error == nil {
                    self.toggleLoadingState()
                    if verified! {
                        self.textField.removeFromSuperview()
                        self.actionButton.removeConstraints(self.actionButton.constraints())
                        self.actionButton.autoCenterInSuperview()
                        self.actionButton.autoSetDimension(.Width, toSize: 100.0)
                        self.actionButton.autoSetDimension(.Height, toSize: 50.0)
                        self.actionButton.setNeedsUpdateConstraints()
                        self.actionButton.removeTarget(self, action: "verifyButtonTapped:", forControlEvents: .TouchUpInside)
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.actionButton.backgroundColor = UIColor.greenColor()
                            self.actionButton.setTitle("Verified!", forState: .Normal)
                            self.view.layoutIfNeeded()
                        })
                    } else {
                        println("user verification failed")
                    }
                } else {
                    println("error verifying user")
                }
            }
        }
    }
    
    private func toggleLoadingState() {
        if let activityIndicator = activityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.activityIndicatorView = nil
        } else {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
            activityIndicatorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            actionButton.setTitle("", forState: .Normal)
            actionButton.addSubview(activityIndicatorView!)
            activityIndicatorView!.autoCenterInSuperview()
            activityIndicatorView!.startAnimating()
        }
    }

}
