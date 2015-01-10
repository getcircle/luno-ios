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
struct LoggedInUserHolder {
    static var user: UserService.Containers.User?
    static var profile: ProfileService.Containers.Profile?
    static var token: String?
}

private let LocksmithService = "LocksmithAuthTokenService"
private let LocksmithAuthTokenKey = "LocksmithAuthToken"
private let DefaultsUserKey = "DefaultsUserKey"
private let DefaultsProfileKey = "DefaultsProfileKey"

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
        configureView()
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
    
    private func configureView() {
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
    
    private class func loadCachedProfile() -> ProfileService.Containers.Profile? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsProfileKey) as? NSData {
            return ProfileService.Containers.Profile.parseFromNSData(data)
        }
        return nil
    }
    
    private func cacheUserData(user: UserService.Containers.User) {
        NSUserDefaults.standardUserDefaults().setObject(user.getNSData(), forKey: DefaultsUserKey)
    }
    
    private func cacheProfileData(profile: ProfileService.Containers.Profile) {
        NSUserDefaults.standardUserDefaults().setObject(profile.getNSData(), forKey: DefaultsProfileKey)
    }
    
    private func cacheLoginData(token: String, user: UserService.Containers.User) {
        // Cache locally
        LoggedInUserHolder.token = token
        LoggedInUserHolder.user = user
        
        // Cache token to keychain
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
        
        // Cache user data in user defaults
        cacheUserData(user)
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
        UserService.Actions.authenticateUser(
            UserService.AuthenticateUser.Request.AuthBackend.Internal,
            email: emailField.text,
            password: passwordField.text
        ) { (user, token, error) -> Void in
            self.hideLoadingState()
            if error != nil || user == nil {
                self.logInButton.addShakeAnimation()
                self.emailField.becomeFirstResponder()
                return
            }
            
            self.cacheLoginData(token!, user: user!)
            self.fetchAndCacheUserProfile(user!.id)
        }
    }
    
    private func fetchAndCacheUserProfile(userId: String) {
        ProfileService.Actions.getProfile(userId: userId) { (profile, error) -> Void in
            if error == nil {
                SearchCache.sharedInstance.repopulate()
                LoggedInUserHolder.profile = profile!
                self.cacheProfileData(profile!)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - Log out
    
    class func logOut() {
        LoggedInUserHolder.user = nil
        AuthViewController.presentAuthViewController()
    }
    
    class func presentAuthViewController() {
        // Check if user is logged in. If not, present auth view controller
        let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        let navController = UINavigationController(rootViewController: authViewController)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
    }
    
    // MARK: - Logged In User Helpers
    
    class func getLoggedInUser() -> UserService.Containers.User? {
        if let user = LoggedInUserHolder.user {
            return user
        } else {
            if let user = self.loadCachedUser() {
                return user
            }
        }
        return nil
    }
    
    class func getLoggedInUserProfile() -> ProfileService.Containers.Profile? {
        if let profile = LoggedInUserHolder.profile {
            return profile
        } else {
            if let profile = self.loadCachedProfile() {
                return profile
            }
        }
        return nil
    }
    
    class func getLoggedInUserToken() -> String? {
        if let token = LoggedInUserHolder.token {
            return token
        } else {
            if let user = self.getLoggedInUser() {
                let (data, error) = Locksmith.loadData(forKey: LocksmithAuthTokenKey, inService: LocksmithService, forUserAccount: user.id)
                return data?.allKeys[0] as? String
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
