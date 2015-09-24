//
//  VerifyPhoneNumberViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry
import libPhoneNumber_iOS

class VerifyPhoneNumberViewController: UIViewController, UITextFieldDelegate {

    enum ActiveField {
        case PhoneNumber
        case Code
    }
    
    @IBOutlet weak private(set) var actionButton: UIButton!
    @IBOutlet weak var actionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak private(set) var phoneNumberField: CircleTextField!
    @IBOutlet weak var phoneNumberFieldVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberFieldWidth: NSLayoutConstraint!
    @IBOutlet weak private(set) var resendCodeButton: UIButton!
    @IBOutlet weak private(set) var verificationCodeField: CircleTextField!
    @IBOutlet weak var verificationCodeFieldVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var verificationCodeFieldWidth: NSLayoutConstraint!
    
    private var activeField = ActiveField.PhoneNumber
    private var activityIndicatorView: CircleActivityIndicatorView?
    private var bypassChecks = ServiceHttpRequest.environment != .Production
    private var codeDigits = 0
    private var phoneNumberFieldPreviousVerticalSpacing: CGFloat = 0.0
    private var phoneNumberFormatter: NBAsYouTypeFormatter!
    private var phoneNumberFieldShrinkFactor: CGFloat = 0.85
    private var toggleLoadingStateTextHolder: String?
    private var transitionedToConfirmation = false
    private var verificationCodeFieldBottomBorder: UIView?
    private var verificationCodeFieldPreviousVerticalSpacing: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        configureTargets()
        phoneNumberFormatter = NBAsYouTypeFormatter(regionCode: "US")
        populateExistingNumberIfExists()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumberField.becomeFirstResponder()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.makeTransparent()
        title = "Verify Phone"
        let rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: "skipTapped:")
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
        phoneNumberField.delegate = self
        phoneNumberField.tintColor = UIColor.whiteColor()
        phoneNumberField.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)

        verificationCodeField.delegate = self
        verificationCodeField.tintColor = UIColor.whiteColor()
        verificationCodeField.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        phoneNumberField.addBottomBorder()

        actionButton.setTitleColor(UIColor.appSearchTextFieldBackground(), forState: .Disabled)
        actionButton.enabled = false
        resendCodeButton.enabled = false
    }
    
    private func configureTargets() {
        actionButton.addTarget(self, action: "actionButtonTapped:", forControlEvents: .TouchUpInside)
        resendCodeButton.addTarget(self, action: "resendCodeButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    private func populateExistingNumberIfExists() {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile()
            where loggedInUserProfile.contactMethods.count > 0
        {
            var existingNumber: String?
            for contactMethod in loggedInUserProfile.contactMethods {
                if contactMethod.contactMethodType == .CellPhone {
                    existingNumber = contactMethod.value
                    break
                }
            }
            
            if let existingNumber = existingNumber {
                let onlyDigits = existingNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
                phoneNumberField.text = phoneNumberFormatter.inputStringAndRememberPosition(onlyDigits)
                validateNumberAndEnableActionButton()
            }
        }
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
            textField.text = phoneNumberFormatter.removeLastDigitAndRememberPosition()
        } else if Int(string) != nil {
            if phoneNumberFormatter.getRememberedPosition() < 14 {
                textField.text = phoneNumberFormatter.inputDigitAndRememberPosition(string)
            }
        }
        
        validateNumberAndEnableActionButton()
    }
    
    private func validateNumberAndEnableActionButton() {
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
                textField.text = textField.text?[0..<codeDigits]
            } else {
                textField.text = ""
            }
        } else if Int(string) != nil {
            if codeDigits < 6 {
                textField.text = (textField.text ?? "") + string
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
                print("error: \(error)")
                self.resendCodeButton.addShakeAnimation()
            }
        }
    }
    
    func handlePhoneNumberSubmit(sender: AnyObject!) {
        triggerSendingVerificationCode(actionButton) { (error) -> Void in
            if error == nil {
                self.switchToConfirmation()
            } else {
                print("error: \(error)")
                self.actionButton.addShakeAnimation()
            }
        }
    }
    
    func handleVerificationCodeSubmit(sender: AnyObject!) {
        self.toggleLoadingState(actionButton)
        if bypassChecks {
            if let user = AuthViewController.getLoggedInUser(), phoneNumber = phoneNumberField.text {
                let builder = try! user.toBuilder()
                builder.phoneNumber = phoneNumber
                builder.phoneNumberVerified = true
                Services.User.Actions.updateUser(try! builder.build()) { (user, error) -> Void in
                    if let user = user {
                        AuthViewController.updateUser(user)
                    }
                    self.toggleLoadingState(self.actionButton)
                    self.verificationComplete()
                }
            }
            return
        }
        
        if let user = AuthViewController.getLoggedInUser(), code = verificationCodeField.text {
            Services.User.Actions.verifyVerificationCode(code, user: user) { (verified, error) -> Void in
                self.toggleLoadingState(self.actionButton)
                if error == nil {
                    if verified! {
                        let userBuilder = try! user.toBuilder()
                        userBuilder.phoneNumberVerified = true
                        AuthViewController.updateUser(try! userBuilder.build())
                        self.verificationComplete()
                    } else {
                        print("user verification failed")
                        self.actionButton.addShakeAnimation()
                    }
                } else {
                    print("error verifying user")
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
        
        if let user = AuthViewController.getLoggedInUser(), phoneNumber = phoneNumberField.text {
            let userBuilder = try! user.toBuilder()
            userBuilder.phoneNumber = phoneNumber
            Services.User.Actions.updateUser(try! userBuilder.build()) { (user, error) -> Void in
                if error == nil {
                    Services.User.Actions.sendVerificationCode(user!) { (error) -> Void in
                        self.toggleLoadingState(button)
                        completionHandler(error)
                    }
                } else {
                    self.toggleLoadingState(button)
                    print("error updating user: \(error)")
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
            var tintColor: UIColor
            switch button {
            case resendCodeButton:
                tintColor = UIColor.whiteColor()
            default:
                tintColor = UIColor.appUIBackgroundColor()
            }
            activityIndicatorView = button.addActivityIndicator(tintColor)
            toggleLoadingStateTextHolder = button.titleLabel?.text
            button.setTitle("", forState: .Normal)
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
        if let phoneNumberFieldFont = phoneNumberField.font {
            phoneNumberField.font = phoneNumberFieldFont.fontWithSize(
                phoneNumberFieldFont.pointSize * phoneNumberFieldShrinkFactor
            )
        }
        phoneNumberFieldWidth.constant = phoneNumberFieldWidth.constant * phoneNumberFieldShrinkFactor
        phoneNumberField.setNeedsUpdateConstraints()
        phoneNumberField.resignFirstResponder()
        
        verificationCodeFieldPreviousVerticalSpacing = verificationCodeFieldVerticalSpacing.constant
        verificationCodeFieldVerticalSpacing.constant = 83
        verificationCodeField.setNeedsDisplay()
        verificationCodeFieldWidth.constant = 100
        verificationCodeField.font = UIFont.appVerificationCodeFieldFont()
        
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
        if let phoneNumberFieldFont = phoneNumberField.font {
            phoneNumberField.font = phoneNumberFieldFont.fontWithSize(
                phoneNumberFieldFont.pointSize / phoneNumberFieldShrinkFactor
            )
        }
        
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
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile()
            where (!loggedInUserProfile.hasImageUrl || loggedInUserProfile.imageUrl.trimWhitespace() == "")
        {
            let verifyProfileVC = VerifyProfileViewController(nibName: "VerifyProfileViewController", bundle: nil)
            navigationController?.setViewControllers([verifyProfileVC], animated: true)
        }
        else {
            let notificationsVC = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
            navigationController?.setViewControllers([notificationsVC], animated: true)
        }
    }
    
    func skipTapped(sender: AnyObject) {
        verificationComplete()
    }
}
