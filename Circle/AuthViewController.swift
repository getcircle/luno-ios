//
//  AuthViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit
import Parse

// Swift doesn't support static variables yet.
// This is the way it is recommended on the docs.
// https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Properties.html
struct LoggedInPersonHolder {
    static var person: Person?
}

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

    // MARK: Setup
    
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
    
    // MARK: Initial Animation
    
    private func moveAppNameLabel() {
        appNameYConstraint.constant = -80.0
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
    
    // MARK: IBActions

    @IBAction func logInButtonPressed(sender: AnyObject?) {
        dismissKeyboard()
        showLoadingState()
        PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text) {
            (pfuser, error: NSError!) -> Void in

            self.hideLoadingState()
            if error == nil {
                // Fetch and cache current person before dismissing
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                    AuthViewController.getLoggedInPerson()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    return
                })
            }
            else {
                self.logInButton.addShakeAnimation()
                self.emailField.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func handleGesture(gestureRecognizer: UIGestureRecognizer) {
        dismissKeyboard()
    }
    
    // MARK: Helpers

    private func dismissKeyboard() {
        if emailField.isFirstResponder() {
            emailField.resignFirstResponder()
        }
        
        if passwordField.isFirstResponder() {
            passwordField.resignFirstResponder()
        }
    }
    
    // MARK: Loading State
    
    private func showLoadingState() {
        emailField.enabled = false
        passwordField.enabled = false
        logInButton.enabled = false
    }
    
    private func hideLoadingState() {
        emailField.enabled = true
        passwordField.enabled = true
        logInButton.enabled = true
    }
    
    // MARK: Log out
    
    class func logOut() {
        LoggedInPersonHolder.person = nil
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            PFUser.logOut()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AuthViewController.presentAuthViewController()
            })
            return
        })
    }
    
    class func presentAuthViewController() {
        // Check if user is logged in. If not, present auth view controller
        let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: authViewController)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
    }
    
    // Synchronous call to fetch Person object for currently logged in user
    class func getLoggedInPerson() -> Person? {
        if let pfUser = PFUser.currentUser() {
            
            // This additional caching is needed to prevent the
            // "main thread long running operation" warning.
            if let person = LoggedInPersonHolder.person {
                return person
            }
            
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.whereKey("user", equalTo:pfUser)
            let people = parseQuery.findObjects() as [Person]
            if people.count > 0 {
                LoggedInPersonHolder.person = people[0]
                return people[0]
            }
        }
        
        return nil
    }
}
