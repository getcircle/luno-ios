//
//  VerifyPhoneNumberViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class VerifyPhoneNumberViewController: UIViewController, UITextFieldDelegate {
    
    enum CurrentInputType {
        case PhoneNumber
        case Code
    }
    
    @IBOutlet weak private(set) var textField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    private var activityIndicatorView: UIActivityIndicatorView?
    private var bypassChecks = !ServiceHttpRequest.isPointingToProduction()
    private var phoneNumberFormatter: NBAsYouTypeFormatter!
    private var currentInputType: CurrentInputType!
    private var codeDigits = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        currentInputType = .PhoneNumber
        phoneNumberFormatter = NBAsYouTypeFormatter(regionCode: "US")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBarHidden(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Configuration

    private func configureView() {
        navigationController?.navigationBar.makeTransparent()
        
        view.backgroundColor = UIColor.appTintColor()
        textField.delegate = self
        textField.tintColor = UIColor.whiteColor()
        textField.autoSetDimension(.Height, toSize: 50.0)
        textField.addBottomBorder()
        
        actionButton.setTitleColor(UIColor.searchTextFieldBackground(), forState: .Disabled)
        actionButton.addTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
        actionButton.enabled = false
    }

    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch currentInputType! {
        case .PhoneNumber: handlePhoneNumberInput(string, range: range)
        case .Code: handleVerificationCodeInput(string, range: range)
        }
        return false
    }
    
    private func handlePhoneNumberInput(string: String, range: NSRange) {
        if range.length > 0 {
            textField.text = phoneNumberFormatter.removeLastDigit()
        } else if let numericValue = string.toInt() {
            if phoneNumberFormatter.getRememberedPosition() < 14 {
                textField.text = phoneNumberFormatter.inputDigitAndRememberPosition(string)
            }
        }
        
        if phoneNumberFormatter.getRememberedPosition() == 14 {
            actionButton.enabled = true
        } else {
            actionButton.enabled = false
        }
    }
    
    private func handleVerificationCodeInput(string: String, range: NSRange) {
        if range.length > 0 {
            if codeDigits > 0 {
                codeDigits -= range.length
                textField.text = textField.text[0..<codeDigits]
            } else {
                textField.text = ""
            }
        } else if let numericValue = string.toInt() {
            if codeDigits < 6 {
                textField.text = textField.text + string
                codeDigits += 1
            }
        } else {
            textField.text = ""
        }
        
        if codeDigits == 6 {
            actionButton.enabled = true
        } else {
            actionButton.enabled = false
        }
    }

    // MARK: - Targets
    
    func actionButtonTapped(sender: AnyObject!) {
        toggleLoadingState()
        
        if bypassChecks {
            toggleLoadingState()
            switchToConfirmation()
            return
        }

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
                            self.actionButton.addShakeAnimation()
                        }
                    }
                } else {
                    println("error updating user: \(error)")
                    self.actionButton.addShakeAnimation()
                }
            }
        }
    }
    
    func verifyButtonTapped(sender: AnyObject!) {
        self.toggleLoadingState()
        if bypassChecks {
            toggleLoadingState()
            completeVerification()
            return
        }
        
        let code = textField.text
        if let user = AuthViewController.getLoggedInUser() {
            UserService.Actions.verifyVerificationCode(code, user: user) { (verified, error) -> Void in
                if error == nil {
                    self.toggleLoadingState()
                    if verified! {
                        self.completeVerification()
                    } else {
                        println("user verification failed")
                        self.actionButton.addShakeAnimation()
                    }
                } else {
                    println("error verifying user")
                    self.actionButton.addShakeAnimation()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func toggleLoadingState() {
        if let activityIndicator = activityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.activityIndicatorView = nil
        } else {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicatorView?.color = UIColor.appTintColor()
            activityIndicatorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            actionButton.setTitle("", forState: .Normal)
            actionButton.addSubview(activityIndicatorView!)
            activityIndicatorView!.autoCenterInSuperview()
            activityIndicatorView!.startAnimating()
        }
    }
    
    private func switchToConfirmation() {
        currentInputType = .Code
        textField.removeConstraints(textField.constraints())
        textField.text = ""
        textField.autoSetDimension(.Height, toSize: 50.0)
        textField.placeholder = "Code"
        textField.autoSetDimension(.Width, toSize: 100.0)
        textField.setNeedsUpdateConstraints()
        
        actionButton.enabled = false
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
                self.textField.keyboardType = .NumberPad
                self.textField.becomeFirstResponder()
                return
        }
    }
    
    private func completeVerification() {
        let verifyProfileVC = VerifyProfileViewController(nibName: "VerifyProfileViewController", bundle: nil)
        self.navigationController?.setViewControllers([verifyProfileVC], animated: true)
    }

}
