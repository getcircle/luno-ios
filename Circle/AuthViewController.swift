//
//  AuthViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    
    @IBOutlet weak var appNameYConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideFieldsAndControls(false)
        navigationController?.navigationBar.makeTransparent()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.3) {
            self.moveAppNameLabel()
        }
    }

    private func setup() {
        emailField.addRoundCorners()
        passwordField.addRoundCorners()
        logInButton.addRoundCorners()
        
        let emailFieldLeftView = UIView(frame: CGRectMake(0.0, 0.0, 10.0, 30.0))
        emailFieldLeftView.backgroundColor = UIColor.whiteColor()
        emailFieldLeftView.opaque = true
        emailField.leftView = emailFieldLeftView
        emailField.leftViewMode = .Always
        
        let passwordFieldLeftView = UIView(frame: CGRectMake(0.0, 0.0, 10.0, 30.0))
        passwordFieldLeftView.backgroundColor = UIColor.whiteColor()
        passwordFieldLeftView.opaque = true
        passwordField.leftView = passwordFieldLeftView
        passwordField.leftViewMode = .Always
    }
    
    private func moveAppNameLabel() {
        appNameYConstraint.constant = -60.0
        appNameLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.appNameLabel.layoutIfNeeded()
            self.tagLineLabel.layoutIfNeeded()
            self.emailField.layoutIfNeeded()
            self.passwordField.layoutIfNeeded()
            self.logInButton.layoutIfNeeded()
        }, { (completed: Bool) -> Void in
                self.showFieldsAndControls(true)
        })
    }
    
    private func hideFieldsAndControls(animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.emailField.alpha = 0.0
            self.passwordField.alpha = 0.0
            self.logInButton.alpha = 0.0
        })
    }
    
    private func showFieldsAndControls(animated: Bool) {
        let duration = animated ? 0.5 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.emailField.alpha = 1.0
            self.passwordField.alpha = 1.0
            self.logInButton.alpha = 1.0
        }, { (completed: Bool) -> Void in
            self.emailField.becomeFirstResponder()
            return
        })
    }
    
    @IBAction func logInButtonPressed(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleGesture(gestureRecognizer: UIGestureRecognizer) {
        if emailField.isFirstResponder() {
            emailField.resignFirstResponder()
        }
        
        if passwordField.isFirstResponder() {
            passwordField.resignFirstResponder()
        }
    }
}
