//
//  AuthViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import Locksmith
import ProtobufRegistry

// Swift doesn't support static variables yet.
// This is the way it is recommended on the docs.
// https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Properties.html
struct LoggedInPersonHolder {
    static var person: Person?
    static var user: UserService.Containers.User?
}

private let LocksmithService = "LocksmithAuthTokenService"
private let LocksmithAuthTokenKey = "LocksmithAuthToken"
private let DefaultsUserKey = "DefaultsUserKey"

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    
    @IBOutlet weak var appNameYConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
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

    // MARK: - Configuration
    
    private func configView() {
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
    
    // MARK: - Initial Animation
    
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
    
    // MARK: - IBActions

    @IBAction func logInButtonPressed(sender: AnyObject?) {
        dismissKeyboard()
        showLoadingState()
        login()
//        PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text) {
//            (pfuser, error: NSError!) -> Void in
//
//            self.hideLoadingState()
//            if error == nil {
//                // Fetch and cache current person before dismissing
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
//                    AuthViewController.getLoggedInPerson()
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    })
//                    return
//                })
//            }
//            else {
//                self.logInButton.addShakeAnimation()
//                self.emailField.becomeFirstResponder()
//            }
//        }
    }
    
    @IBAction func handleGesture(gestureRecognizer: UIGestureRecognizer) {
        dismissKeyboard()
    }
    
    // MARK: - Helpers

    private func dismissKeyboard() {
        if emailField.isFirstResponder() {
            emailField.resignFirstResponder()
        }
        
        if passwordField.isFirstResponder() {
            passwordField.resignFirstResponder()
        }
    }
    
    private class func loadCachedUser() -> UserService.Containers.User? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsUserKey) as? NSData {
            return UserService.Containers.User.parseFromNSData(data)
        }
        return nil
    }
    
    private func cacheUserData(user: UserService.Containers.User) {
        NSUserDefaults.standardUserDefaults().setObject(user.getNSData(), forKey: DefaultsUserKey)
    }
    
    private func cacheLoginData(token: String) {
        if let user = LoggedInPersonHolder.user {
            let error = Locksmith.updateData(
                [token: "\(NSDate())"],
                forKey: LocksmithAuthTokenKey,
                inService: LocksmithService,
                forUserAccount: user.id
            )
            if error != nil {
                // XXX what is the correct way to report errors?
                println("Error: \(error)")
            }
            cacheUserData(user)
        }
    }
    
    // MARK: - Loading State
    
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
    
    // MARK: - Log in
    
    private func login() {
        let request = UserService.Requests.AuthenticateUser(
            UserService.AuthenticateUser.Request.AuthBackend.Internal,
            emailField.text,
            passwordField.text
        )

        let client = ServiceClient(serviceName: "user", token: nil)
        client.callAction(request, completionHandler: {
            (httpRequest, httpResponse, serviceResponse, actionResponse, error) -> Void in
            
            self.hideLoadingState()
            if let actionResponse = actionResponse {
                let response = UserService.Responses.AuthenticateUser(actionResponse)
                if error != nil || !response.success {
                    self.logInButton.addShakeAnimation()
                    self.emailField.becomeFirstResponder()
                    return
                }
                
                let result = response.result as UserService.AuthenticateUser.Response
                LoggedInPersonHolder.user = result.user
                self.cacheLoginData(result.token)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                // TODO display an error message
                println("Error logging in user: \(error)")
            }
        })
    }
    
    // MARK: - Log out
    
    class func logOut() {
        LoggedInPersonHolder.user = nil
        AuthViewController.presentAuthViewController()
    }
    
    class func presentAuthViewController() {
        // Check if user is logged in. If not, present auth view controller
        let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: authViewController)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
    }
    
    // Synchronous call to fetch Person object for currently logged in user
    class func getLoggedInPerson() -> UserService.Containers.User? {
        if let user = LoggedInPersonHolder.user {
            return user
        } else {
            if let user = AuthViewController.loadCachedUser() {
                return user
            }
        }
        return nil
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField && passwordField.text == "" {
            passwordField.becomeFirstResponder()
        }
        else {
            logInButtonPressed(textField)
        }
        
        return true
    }
}
