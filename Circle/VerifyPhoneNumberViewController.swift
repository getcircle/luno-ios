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
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak private(set) var phoneNumberField: UITextField!
    @IBOutlet weak private(set) var sendCodeButton: UIButton!
    @IBOutlet weak private(set) var verificationCodeField: UITextField!
    @IBOutlet weak private(set) var resendCodeButton: UIButton!
    @IBOutlet weak private(set) var verifyCodeButton: UIButton!
    @IBOutlet weak var phoneNumberFieldVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var verificationCodeFieldVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var verificationCodeFieldWidth: NSLayoutConstraint!
    
    private var activityIndicatorView: UIActivityIndicatorView?
    private var bypassChecks = !ServiceHttpRequest.isPointingToProduction()
    private var phoneNumberFormatter: NBAsYouTypeFormatter!
    private var codeDigits = 0
    private var transitionedToConfirmation = false
    private var phoneNumberFieldPreviousVerticalSpacing: CGFloat = 0.0
    private var verificationCodeFieldPreviousVerticalSpacing: CGFloat = 0.0
    private var phoneNumberFieldShrinkFactor: CGFloat = 0.85
    private var toggleLoadingStateTextHolder: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTargets()
        phoneNumberFormatter = NBAsYouTypeFormatter(regionCode: "US")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBarHidden(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumberField.becomeFirstResponder()
    }
    
    // MARK: - Configuration

    private func configureView() {
        navigationController?.navigationBar.makeTransparent()
        
        view.backgroundColor = UIColor.appTintColor()
        phoneNumberField.delegate = self
        phoneNumberField.tintColor = UIColor.whiteColor()
        verificationCodeField.delegate = self
        verificationCodeField.tintColor = UIColor.whiteColor()
        phoneNumberField.addBottomBorder()
        verificationCodeField.addBottomBorder()

        sendCodeButton.setTitleColor(UIColor.searchTextFieldBackground(), forState: .Disabled)
        sendCodeButton.enabled = false
        verifyCodeButton.enabled = false
        resendCodeButton.enabled = false
    }
    
    private func configureTargets() {
        sendCodeButton.addTarget(self, action: "sendCodeButtonTapped:", forControlEvents: .TouchUpInside)
        verifyCodeButton.addTarget(self, action: "verifyCodeButtonTapped:", forControlEvents: .TouchUpInside)
        resendCodeButton.addTarget(self, action: "resendCodeButtonTapped:", forControlEvents: .TouchUpInside)
    }

    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case phoneNumberField: handlePhoneNumberInput(textField, string: string, range: range)
        case verificationCodeField: handleVerificationCodeInput(textField, string: string, range: range)
        default: break
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case phoneNumberField:
            if transitionedToConfirmation {
                transitionToEditPhoneNumber()
            }
        default:
            break
        }
    }
    
    private func handlePhoneNumberInput(textField: UITextField, string: String, range: NSRange) {
        if range.length > 0 {
            textField.text = phoneNumberFormatter.removeLastDigit()
        } else if let numericValue = string.toInt() {
            if phoneNumberFormatter.getRememberedPosition() < 14 {
                textField.text = phoneNumberFormatter.inputDigitAndRememberPosition(string)
            }
        }
        
        if phoneNumberFormatter.getRememberedPosition() == 14 {
            sendCodeButton.enabled = true
        } else {
            sendCodeButton.enabled = false
        }
    }
    
    private func handleVerificationCodeInput(textField: UITextField, string: String, range: NSRange) {
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
            verifyCodeButton.enabled = true
        } else {
            verifyCodeButton.enabled = false
        }
    }

    // MARK: - Targets
    
    func sendCodeButtonTapped(sender: AnyObject!) {
        triggerSendingVerificationCode(sendCodeButton) { (error) -> Void in
            if error == nil {
                self.switchToConfirmation()
            } else {
                println("error: \(error)")
                self.sendCodeButton.addShakeAnimation()
            }
        }
    }
    
    func resendCodeButtonTapped(sender: AnyObject!) {
        triggerSendingVerificationCode(resendCodeButton) { (error) -> Void in
            if error != nil {
                println("error: \(error)")
                self.resendCodeButton.addShakeAnimation()
            }
        }
    }
    
    func verifyCodeButtonTapped(sender: AnyObject!) {
        self.toggleLoadingState(verifyCodeButton)
        if bypassChecks {
            toggleLoadingState(verifyCodeButton)
            completeVerification()
            return
        }
        
        let code = phoneNumberField.text
        if let user = AuthViewController.getLoggedInUser() {
            UserService.Actions.verifyVerificationCode(code, user: user) { (verified, error) -> Void in
                if error == nil {
                    self.toggleLoadingState(self.verifyCodeButton)
                    if verified! {
                        self.completeVerification()
                    } else {
                        println("user verification failed")
                        self.verifyCodeButton.addShakeAnimation()
                    }
                } else {
                    println("error verifying user")
                    self.verifyCodeButton.addShakeAnimation()
                }
            }
        }
    }
    
    func triggerSendingVerificationCode(button: UIButton, completionHandler: (NSError?) -> Void) {
        toggleLoadingState(button)
        
        if bypassChecks {
            toggleLoadingState(button)
            completionHandler(nil)
            return
        }
        
        let phoneNumber = phoneNumberField.text
        if let user = AuthViewController.getLoggedInUser() {
            let userBuilder = user.toBuilder()
            userBuilder.phone_number = phoneNumber
            UserService.Actions.updateUser(userBuilder.build()) { (user, error) -> Void in
                if error == nil {
                    UserService.Actions.sendVerificationCode(user!) { (error) -> Void in
                        self.toggleLoadingState(button)
                        completionHandler(error)
                    }
                } else {
                    self.toggleLoadingState(button)
                    println("error updating user: \(error)")
                    completionHandler(error)
                }
            }
        }
        
    }
    
    // MARK: - Helpers
    
    private func toggleLoadingState(button: UIButton) {
        if let activityIndicator = activityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            button.setTitle(toggleLoadingStateTextHolder, forState: .Normal)
            self.activityIndicatorView = nil
        } else {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicatorView?.color = UIColor.appTintColor()
            activityIndicatorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            toggleLoadingStateTextHolder = button.titleLabel?.text
            button.setTitle("", forState: .Normal)
            button.addSubview(activityIndicatorView!)
            activityIndicatorView!.autoCenterInSuperview()
            activityIndicatorView!.startAnimating()
        }
    }
    
    private func switchToConfirmation() {
        phoneNumberFieldPreviousVerticalSpacing = phoneNumberFieldVerticalSpacing.constant
        phoneNumberFieldVerticalSpacing.constant = 15
        phoneNumberField.font = phoneNumberField.font.fontWithSize(
            phoneNumberField.font.pointSize * phoneNumberFieldShrinkFactor
        )
        phoneNumberFieldWidth.constant = phoneNumberFieldWidth.constant * phoneNumberFieldShrinkFactor
        phoneNumberField.setNeedsUpdateConstraints()
        phoneNumberField.resignFirstResponder()
        
        verificationCodeFieldPreviousVerticalSpacing = verificationCodeFieldVerticalSpacing.constant
        verificationCodeFieldVerticalSpacing.constant = 83
        verificationCodeField.setNeedsDisplay()
        verificationCodeFieldWidth.constant = 100
        verificationCodeField.font = UIFont.lightFont(30.0)
        verificationCodeField.setNeedsUpdateConstraints()
        
        UIView.transitionWithView(instructionsLabel, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.instructionsLabel.text = "You should be getting a text shortly."
        }, completion: nil)
        
        UIView.animateWithDuration(
            0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.9,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.sendCodeButton.alpha = 0
                self.sendCodeButton.enabled = false
                self.resendCodeButton.alpha = 1
                self.resendCodeButton.enabled = true
                self.verifyCodeButton.alpha = 1
            }
        ) { (success) -> Void in
            self.verificationCodeField.becomeFirstResponder()
            self.transitionedToConfirmation = true
            return
        }
    }
    
    private func transitionToEditPhoneNumber() {
        phoneNumberFieldVerticalSpacing.constant = phoneNumberFieldPreviousVerticalSpacing
        phoneNumberField.setNeedsUpdateConstraints()
        
        phoneNumberField.font = phoneNumberField.font.fontWithSize(
            phoneNumberField.font.pointSize / phoneNumberFieldShrinkFactor
        )
        phoneNumberFieldWidth.constant = phoneNumberFieldWidth.constant / phoneNumberFieldShrinkFactor
        
        verificationCodeFieldWidth.constant = 0
        verificationCodeFieldVerticalSpacing.constant = verificationCodeFieldPreviousVerticalSpacing
        verificationCodeField.setNeedsUpdateConstraints()
        verificationCodeField.text = ""
        codeDigits = 0
        
        UIView.transitionWithView(instructionsLabel, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.instructionsLabel.text = "Verify your phone number for your team to contact you."
        }, completion: nil)
        
        UIView.animateWithDuration(
            0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.9, options: .CurveEaseInOut,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.sendCodeButton.alpha = 1
                self.sendCodeButton.enabled = true
                self.resendCodeButton.alpha = 0
                self.resendCodeButton.enabled = false
                self.verifyCodeButton.alpha = 0
            }
        ) { (success) -> Void in
            self.transitionedToConfirmation = false
        }
    }
    
    private func completeVerification() {
        let verifyProfileVC = VerifyProfileViewController(nibName: "VerifyProfileViewController", bundle: nil)
        self.navigationController?.setViewControllers([verifyProfileVC], animated: true)
    }

}
