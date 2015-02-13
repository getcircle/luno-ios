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

struct AuthNotifications {
    static let onLoginNotification = "com.ravcode.notification:onLoginNotification"
    static let onLogoutNotification = "com.ravcode.notification:onLogoutNotification"
    static let onProfileChangedNotification = "com.ravcode.notification:onProfileChangedNotification"
    static let onUserChangedNotification = "com.ravcode.notifcation:onUserChangedNotification"
}

private let LocksmithService = "LocksmithAuthTokenService"
private let LocksmithAuthTokenKey = "LocksmithAuthToken"
private let DefaultsUserKey = "DefaultsUserKey"
private let DefaultsProfileKey = "DefaultsProfileKey"
private let DefaultsLastLoggedInUserEmail = "DefaultsLastLoggedInUserEmail"

private let GoogleClientID = "1077014421904-pes3pbf96obmp75kb00qouoiqf18u78h.apps.googleusercontent.com"
private let GoogleServerClientID = "1077014421904-1a697ks3qvtt6975qfqhmed8529en8s2.apps.googleusercontent.com"

class AuthViewController: UIViewController, GPPSignInDelegate {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appNameYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var googleSignInButton: GPPSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureAppNameLabel()
        configureView()
        configureGoogleAuthentication()
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

    private func configureAppNameLabel() {
        appNameLabel.text = NSBundle.appName()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.appTintColor()
    }
    
    private func configureGoogleAuthentication() {
        let googleSignIn = GPPSignIn.sharedInstance()
        googleSignIn.shouldFetchGoogleUserID = true
        googleSignIn.shouldFetchGoogleUserEmail = true
        googleSignIn.clientID = GoogleClientID
        googleSignIn.homeServerClientID = GoogleServerClientID
        googleSignIn.scopes = [kGTLAuthScopePlusLogin, kGTLAuthScopePlusUserinfoEmail, kGTLAuthScopePlusUserinfoProfile]
        googleSignIn.delegate = self
        
        googleSignInButton.colorScheme = kGPPSignInButtonColorSchemeLight
        googleSignInButton.style = kGPPSignInButtonStyleWide
        
        googleSignInButton.addTarget(self, action: "startingGoogleAuthentication:", forControlEvents: .TouchUpInside)
    }
    
    // MARK: - GPPSignInDelegate
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            let credentials = UserService.AuthenticateUser.Request.Credentials.builder()
            if let code = GPPSignIn.sharedInstance().homeServerAuthorizationCode? {
                credentials.key = code
            }
            credentials.secret = GPPSignIn.sharedInstance().idToken
            login(.Google, credentials: credentials.build())
        }
    }
    
    // MARK: - Initial Animation
    
    private func moveAppNameLabel() {
        appNameYConstraint.constant = 200.0
        appNameLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.appNameLabel.layoutIfNeeded()
            self.googleSignInButton.alpha = 0.0
            self.googleSignInButton.layoutIfNeeded()
            self.tagLineLabel.layoutIfNeeded()
        }, { (completed: Bool) -> Void in
            self.showFieldsAndControls(true)
        })
    }
    
    private func hideFieldsAndControls(animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.googleSignInButton.alpha = 0.0
        })
    }
    
    private func showFieldsAndControls(animated: Bool) {
        let duration = animated ? 0.5 : 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.googleSignInButton.alpha = 1.0
        })
    }
    
    // MARK: - Targets
    
    func startingGoogleAuthentication(sender: AnyObject!) {
        showLoadingState()
    }
    
    // MARK: - Helpers
    
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
    
    private class func cacheUserData(user: UserService.Containers.User) {
        NSUserDefaults.standardUserDefaults().setObject(user.getNSData(), forKey: DefaultsUserKey)
    }
    
    private class func cacheProfileData(profile: ProfileService.Containers.Profile) {
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
        self.dynamicType.cacheUserData(user)
        
        // Cache email used
        NSUserDefaults.standardUserDefaults().setObject(user.primary_email, forKey: DefaultsLastLoggedInUserEmail)
    }
    
    // MARK: - Loading State
    
    private func showLoadingState() {
        googleSignInButton.enabled = false
    }
    
    private func hideLoadingState() {
        googleSignInButton.enabled = true
    }
    
    // MARK: - Log in
    
    private func login(
        backend: UserService.AuthenticateUser.Request.AuthBackend,
        credentials: UserService.AuthenticateUser.Request.Credentials
    ) {
        UserService.Actions.authenticateUser(backend, credentials: credentials) { (user, token, newUser, error) -> Void in
            self.hideLoadingState()
            if error != nil {
                self.googleSignInButton.addShakeAnimation()
                return
            }

            Mixpanel.identifyUser(user!, newUser: newUser!)
            Mixpanel.registerSuperPropertiesForUser(user!)
            self.trackSignupLogin(backend, newUser: newUser!)
            self.cacheLoginData(token!, user: user!)
            self.fetchAndCacheUserProfile(user!.id) { (error) in
                if error != nil {
                    let homelessVC = HomelessViewController(nibName: "HomelessViewController", bundle: nil)
                    self.navigationController?.setViewControllers([homelessVC], animated: true)
                    return
                }
                
                ObjectStore.sharedInstance.repopulate()
                NSNotificationCenter.defaultCenter().postNotificationName(
                    AuthNotifications.onLoginNotification,
                    object: nil
                )
                if self.dynamicType.checkUser(unverifiedPhoneHandler: { () -> Void in
                    let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
                    self.navigationController?.setViewControllers([verifyPhoneNumberVC], animated: true)
                }, unverifiedProfileHandler: nil) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    private func trackSignupLogin(backend: UserService.AuthenticateUser.Request.AuthBackend, newUser: Bool) {
        let properties = ["backend": String(backend.rawValue)]
        if newUser {
            Tracker.sharedInstance.track(.UserSignup, properties: properties)
        } else {
            Tracker.sharedInstance.track(.UserLogin, properties: properties)
        }
    }
    
    private func fetchAndCacheUserProfile(userId: String, completion: (error: NSError?) -> Void) {
        // XXX handle profile doesn't exist
        ProfileService.Actions.getProfile(userId: userId) { (profile, error) -> Void in
            if let profile = profile {
                self.dynamicType.updateUserProfile(profile)
            }
            completion(error: error)
        }
    }
    
    // MARK: - Log out
    
    class func logOut() {
        // Clear keychain
        if let user = LoggedInUserHolder.user {
            Locksmith.deleteData(
                forKey: LocksmithAuthTokenKey,
                inService: LocksmithService,
                forUserAccount: user.id
            )
        }
        GPPSignIn.sharedInstance().signOut()
        
        // Remove local cached date
        LoggedInUserHolder.profile = nil
        LoggedInUserHolder.user = nil
        LoggedInUserHolder.token = nil
        ObjectStore.sharedInstance.reset(self)
        
        // Remove persistent cached data
        NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsUserKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsProfileKey)
        
        // Notify everyone
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthNotifications.onLogoutNotification,
            object: nil
        )
        
        // Present auth view
        presentAuthViewController()
    }
    
    private class func presentViewControllerWithNavigationController(vc: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
    }
    
    class func presentAuthViewController() {
        // Check if user is logged in. If not, present auth view controller
        let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(authViewController)
    }
    
    class func presentPhoneVerification() {
        let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(verifyPhoneNumberVC)
    }
    
    class func presentProfileVerification() {
        let verifyProfileVC = VerifyProfileViewController(nibName: "VerifyProfileViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(verifyProfileVC)
    }
    
    class func presentHomelessViewController() {
        let homelessVC = HomelessViewController(nibName: "HomelessViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(homelessVC)
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
    
    
    class func updateUserProfile(profile: ProfileService.Containers.Profile) {
        LoggedInUserHolder.profile = profile
        self.cacheProfileData(profile)
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthNotifications.onProfileChangedNotification,
            object: profile
        )
    }
    
    class func updateUser(user: UserService.Containers.User) {
        LoggedInUserHolder.user = user
        self.cacheUserData(user)
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthNotifications.onUserChangedNotification,
            object: user
        )
    }
    
    // MARK: - Authentication Helpers
    
    class func checkUser(#unverifiedPhoneHandler: (() -> Void)?, unverifiedProfileHandler: (() -> Void)?) -> Bool {
        if let user = getLoggedInUser() {
            if getLoggedInUserProfile() == nil {
                self.presentHomelessViewController()
                return false
            }
            
            if !user.phone_number_verified {
                if let handler = unverifiedPhoneHandler {
                    handler()
                } else {
                    presentPhoneVerification()
                }
                return false
            }
            
            if let profile = getLoggedInUserProfile() {
                if !profile.verified {
                    if let handler = unverifiedPhoneHandler {
                        handler()
                    } else {
                        presentProfileVerification()
                    }
                }
            }
        } else {
            presentAuthViewController()
            return false
        }
        return true
    }

}
