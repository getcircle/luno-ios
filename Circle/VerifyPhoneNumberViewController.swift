//
//  VerifyPhoneNumberViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class VerifyPhoneNumberViewController: UIViewController, UITextFieldDelegate, CircleAlertViewDelegate {
    
    enum ActiveField {
        case PhoneNumber
        case Code
    }
    
    @IBOutlet weak private(set) var actionButton: UIButton!
    @IBOutlet weak var actionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak private(set) var phoneNumberField: UITextField!
    @IBOutlet weak var phoneNumberFieldVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberFieldWidth: NSLayoutConstraint!
    @IBOutlet weak private(set) var resendCodeButton: UIButton!
    @IBOutlet weak private(set) var verificationCodeField: UITextField!
    @IBOutlet weak var verificationCodeFieldVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var verificationCodeFieldWidth: NSLayoutConstraint!
    
    private var activeField = ActiveField.PhoneNumber
    private var activityIndicatorView: UIActivityIndicatorView?
//    private var bypassChecks = !ServiceHttpRequest.isPointingToProduction()
    private var bypassChecks = true
    private var codeDigits = 0
    private var phoneNumberFieldPreviousVerticalSpacing: CGFloat = 0.0
    private var phoneNumberFormatter: NBAsYouTypeFormatter!
    private var phoneNumberFieldShrinkFactor: CGFloat = 0.85
    private var toggleLoadingStateTextHolder: String?
    private var transitionedToConfirmation = false
    private var verificationCodeFieldBottomBorder: UIView?
    private var verificationCodeFieldPreviousVerticalSpacing: CGFloat = 0.0
    private var welcomeAlertPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTargets()
        phoneNumberFormatter = NBAsYouTypeFormatter(regionCode: "US")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !welcomeAlertPresented {
            presentWelcomeAlert()
        }
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

        actionButton.setTitleColor(UIColor.searchTextFieldBackground(), forState: .Disabled)
        actionButton.enabled = false
        resendCodeButton.enabled = false
    }
    
    private func configureTargets() {
        actionButton.addTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
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
            actionButton.enabled = true
        } else {
            actionButton.enabled = false
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
            actionButton.enabled = true
        } else {
            actionButton.enabled = false
        }
    }

    // MARK: - Targets
    
    func actionButtonTapped(sender: AnyObject!) {
        switch activeField {
        case .PhoneNumber: handlePhoneNumberSubmit(sender)
        case .Code: handleVerificationCodeSubmit(sender)
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
    
    func handlePhoneNumberSubmit(sender: AnyObject!) {
        triggerSendingVerificationCode(actionButton) { (error) -> Void in
            if error == nil {
                self.switchToConfirmation()
            } else {
                println("error: \(error)")
                self.actionButton.addShakeAnimation()
            }
        }
    }
    
    func handleVerificationCodeSubmit(sender: AnyObject!) {
        self.toggleLoadingState(actionButton)
        if bypassChecks {
            if let user = AuthViewController.getLoggedInUser() {
                let builder = user.toBuilder()
                builder.phone_number = phoneNumberField.text
                builder.phone_number_verified = true
                UserService.Actions.updateUser(builder.build()) { (user, error) -> Void in
                    if let user = user {
                        AuthViewController.updateUser(user)
                    }
                    self.toggleLoadingState(self.actionButton)
                    self.verificationComplete()
                }
            }
            return
        }
        
        let code = verificationCodeField.text
        if let user = AuthViewController.getLoggedInUser() {
            UserService.Actions.verifyVerificationCode(code, user: user) { (verified, error) -> Void in
                if error == nil {
                    self.toggleLoadingState(self.actionButton)
                    if verified! {
                        self.verificationComplete()
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
    
    func triggerSendingVerificationCode(button: UIButton, completionHandler: (NSError?) -> Void) {
        toggleLoadingState(button)
        
        if bypassChecks {
            delay(0.3) { () -> () in
                self.toggleLoadingState(button)
                completionHandler(nil)
            }
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
            var tintColor: UIColor
            switch button {
            case resendCodeButton:
                tintColor = UIColor.whiteColor()
            default:
                tintColor = UIColor.appTintColor()
            }
            activityIndicatorView?.color = tintColor
            activityIndicatorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            toggleLoadingStateTextHolder = button.titleLabel?.text
            button.setTitle("", forState: .Normal)
            button.addSubview(activityIndicatorView!)
            activityIndicatorView!.autoCenterInSuperview()
            activityIndicatorView!.startAnimating()
        }
    }
    
    private func switchToConfirmation() {
        activeField = .Code
        
        UIView.animateWithDuration(0, animations: { () -> Void in
            // add the border here since we remove it if we transition back to editing
            self.verificationCodeFieldBottomBorder = self.verificationCodeField.addBottomBorder()
        }) { (_) -> Void in
            self.mainSwitchToConfirmationAnimation()
        }
    }
    
    private func mainSwitchToConfirmationAnimation() {
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
        
        actionButtonWidth.constant = verificationCodeFieldWidth.constant
        actionButton.setTitle("Verify", forState: .Normal)
        actionButton.setNeedsUpdateConstraints()
        
        UIView.transitionWithView(instructionsLabel, duration: 0.1, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.instructionsLabel.text = "You should be getting a text shortly."
            }, completion: nil)
        
        UIView.animateWithDuration(
            0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.actionButton.enabled = false
                self.resendCodeButton.alpha = 1
                self.resendCodeButton.enabled = true
            }
            ) { (_) -> Void in
                self.verificationCodeField.becomeFirstResponder()
                self.transitionedToConfirmation = true
                return
        }
    }
    
    private func transitionToEditPhoneNumber() {
        activeField = .PhoneNumber
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
        
        actionButtonWidth.constant = phoneNumberFieldWidth.constant
        actionButton.setTitle("Send Code", forState: .Normal)
        actionButton.setNeedsUpdateConstraints()
        
        UIView.transitionWithView(instructionsLabel, duration: 0.1, options: .TransitionCrossDissolve, animations: { () -> Void in
            self.instructionsLabel.text = "Verify your phone number for your team to contact you."
        }, completion: nil)
        
        UIView.animateWithDuration(
            0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.verificationCodeFieldBottomBorder?.removeFromSuperview()
                self.view.layoutIfNeeded()
                self.actionButton.enabled = true
                self.resendCodeButton.alpha = 0
                self.resendCodeButton.enabled = false
            }
        ) { (_) -> Void in
            self.transitionedToConfirmation = false
        }
    }
    
    private func verificationComplete() {
        let verifyProfileVC = VerifyProfileViewController(nibName: "VerifyProfileViewController", bundle: nil)
        navigationController?.setViewControllers([verifyProfileVC], animated: true)
    }
    
    // MARK: - Welcome Alert
    
    private func presentWelcomeAlert() {
        let alertViewController = CircleAlertViewController(nibName: "CircleAlertViewController", bundle: nil)
        alertViewController.modalPresentationStyle = .Custom
        alertViewController.transitioningDelegate = alertViewController
        alertViewController.circleAlertViewDelegate = self
        presentViewController(alertViewController, animated: true, completion: nil)
        welcomeAlertPresented = true
    }

    // MARK: - CircleAlertViewDelegate
    
    func alertActionButtonPressed(sender: AnyObject!) {
        phoneNumberField.becomeFirstResponder()
    }
    
    
}
