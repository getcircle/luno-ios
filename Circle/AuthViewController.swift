//
//  AuthViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import Crashlytics
import Locksmith
import Mixpanel
import ProtobufRegistry
import VENTouchLock

// Swift doesn't support static variables yet.
// This is the way it is recommended on the docs.
// https://developer.apple.com/library/ios/documentation/swift/conceptual/Swift_Programming_Language/Properties.html
struct LoggedInUserHolder {
    static var user: Services.User.Containers.UserV1?
    static var profile: Services.Profile.Containers.ProfileV1?
    static var organization: Services.Organization.Containers.OrganizationV1?
    static var identities: Array<Services.User.Containers.IdentityV1>?
    static var token: String?
}

struct AuthNotifications {
    static let onLoginNotification = "com.rhlabs.notification:onLoginNotification"
    static let onLogoutNotification = "com.rhlabs.notification:onLogoutNotification"
    static let onProfileChangedNotification = "com.rhlabs.notification:onProfileChangedNotification"
    static let onUserChangedNotification = "com.rhlabs.notifcation:onUserChangedNotification"
}

private let AuthPasscode = "AuthPasscode"
private let LocksmithService = "LocksmithAuthTokenService"
private let DefaultsUserKey = "DefaultsUserKey"
private let DefaultsProfileKey = "DefaultsProfileKey"
private let DefaultsLastLoggedInUserEmail = "DefaultsLastLoggedInUserEmail"
private let DefaultsOrganizationKey = "DefaultsOrganizationKey"
private let DefaultsIdentitiesKey = "DefaultsIdentitiesKey"

private let GoogleClientID = "1077014421904-pes3pbf96obmp75kb00qouoiqf18u78h.apps.googleusercontent.com"
private let GoogleServerClientID = "1077014421904-1a697ks3qvtt6975qfqhmed8529en8s2.apps.googleusercontent.com"

class AuthViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appNameYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var googleSignInButtonBottomConstraint: NSLayoutConstraint!
    private var activityIndicator: CircleActivityIndicatorView?
    private var googleSignInButtonText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureAppNameLabel()
        configureView()
        configureGoogleAuthentication()
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // hideFieldsAndControls(false)
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
        view.backgroundColor = UIColor.appUIBackgroundColor()
    }
    
    private func configureGoogleAuthentication() {
        let googleSignIn = GIDSignIn.sharedInstance()
        googleSignIn.clientID = GoogleClientID
        googleSignIn.serverClientID = GoogleServerClientID
        googleSignIn.scopes = ["https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/plus.profile.emails.read"]
        googleSignIn.delegate = self
//        googleSignInButton.colorScheme = kGPPSignInButtonColorSchemeLight
//        googleSignInButton.style = kGPPSignInButtonStyleWide
        googleSignInButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
        googleSignInButton.addRoundCorners(radius: 2.0)
        googleSignInButton.backgroundColor = UIColor.appTintColor()
        googleSignInButton.setCustomAttributedTitle(
            AppStrings.SocialConnectGooglePlusCTA.localizedUppercaseString(),
            forState: .Normal
        )
        googleSignInButton.addTarget(self, action: "googlePlusSignInButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    // MARK: - GIDSignInDelegate
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error != nil {
            hideLoadingState()
            googleSignInButton.addShakeAnimation()
        } else {
            let credentials = Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1.builder()
            credentials.key = user.serverAuthCode
            credentials.secret = user.authentication.idToken
            login(.Google, credentials: credentials.build())
        }
    }
    
    // MARK: - Initial Animation
    
    private func moveAppNameLabel() {
        googleSignInButtonBottomConstraint.constant = 20.0
        // appNameYConstraint.constant = 200.0
        appNameLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            self.appNameLabel.layoutIfNeeded()
//            self.googleSignInButton.alpha = 0.0
            self.googleSignInButton.layoutIfNeeded()
            self.tagLineLabel.layoutIfNeeded()
        }, completion: { (completed: Bool) -> Void in
            // self.showFieldsAndControls(true)
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
    
    private static func loadCachedUser() -> Services.User.Containers.UserV1? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsUserKey) as? NSData {
            return Services.User.Containers.UserV1.parseFromData(data)
        }
        return nil
    }
    
    private static func loadCachedProfile() -> Services.Profile.Containers.ProfileV1? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsProfileKey) as? NSData {
            return Services.Profile.Containers.ProfileV1.parseFromData(data)
        }
        return nil
    }
    
    private static func loadCachedOrganization() -> Services.Organization.Containers.OrganizationV1? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsOrganizationKey) as? NSData {
            return Services.Organization.Containers.OrganizationV1.parseFromData(data)
        }
        return nil
    }
    
    private static func loadCachedIdentities() -> Array<Services.User.Containers.IdentityV1>? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsIdentitiesKey) as? [NSData] {
            var identities = Array<Services.User.Containers.IdentityV1>()
            for object in data {
                identities.append(Services.User.Containers.IdentityV1.parseFromData(object))
            }
            return identities
        }
        return nil
    }
    
    private static func cacheUserData(user: Services.User.Containers.UserV1) {
        NSUserDefaults.standardUserDefaults().setObject(user.data(), forKey: DefaultsUserKey)
    }
    
    private static func cacheProfileData(profile: Services.Profile.Containers.ProfileV1) {
        NSUserDefaults.standardUserDefaults().setObject(profile.data(), forKey: DefaultsProfileKey)
    }
    
    private static func cacheOrganizationData(organization: Services.Organization.Containers.OrganizationV1) {
        NSUserDefaults.standardUserDefaults().setObject(organization.data(), forKey: DefaultsOrganizationKey)
    }
    
    private static func cacheUserIdentities(identities: Array<Services.User.Containers.IdentityV1>) {
        var cleanIdentities = [NSData]()
        for identity in identities {
            let builder = identity.toBuilder()
            builder.clearAccessToken()
            builder.clearRefreshToken()
            cleanIdentities.append(builder.build().data())
        }
        NSUserDefaults.standardUserDefaults().setObject(cleanIdentities, forKey: DefaultsIdentitiesKey)
    }
    
    private func cacheLoginData(token: String, user: Services.User.Containers.UserV1) {
        // Cache locally
        self.dynamicType.cacheTokenAndUserInMemory(token, user: user)

        // Cache token to keychain
        let error = Locksmith.updateData(
            [token: "\(NSDate())"],
            forUserAccount: user.id,
            inService: LocksmithService
        )
        if error != nil {
            // XXX what is the correct way to report errors?
            println("Error: \(error)")
        }
        
        // Cache user data in user defaults
        self.dynamicType.cacheUserData(user)
        
        // Cache email used
        NSUserDefaults.standardUserDefaults().setObject(user.primaryEmail, forKey: DefaultsLastLoggedInUserEmail)
    }
    
    internal static func cacheTokenAndUserInMemory(token: String, user: Services.User.Containers.UserV1) {
        LoggedInUserHolder.token = token
        LoggedInUserHolder.user = user
    }
    
    // MARK: - Loading State
    
    private func showLoadingState() {
        googleSignInButtonText = googleSignInButton.titleLabel?.text
        googleSignInButton.setCustomAttributedTitle("", forState: .Normal)
        if activityIndicator == nil {
            // TODO this should be white
            activityIndicator = googleSignInButton.addActivityIndicator(color: UIColor.whiteColor(), start: false)
        }
        activityIndicator?.startAnimating()
        googleSignInButton.enabled = false
    }
    
    private func hideLoadingState() {
        activityIndicator?.stopAnimating()
        if googleSignInButtonText != nil {
            googleSignInButton.setCustomAttributedTitle(googleSignInButtonText!, forState: .Normal)
        }
        googleSignInButton.backgroundColor = UIColor.appTintColor()
        googleSignInButton.enabled = true
    }
    
    // MARK: - Log in
    
    private func login(
        backend: Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1,
        credentials: Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1
    ) {
        Services.User.Actions.authenticateUser(backend, credentials: credentials) { (user, token, newUser, error) -> Void in
            if error != nil {
                self.hideLoadingState()
                self.googleSignInButton.addShakeAnimation()
                return
            }

            Mixpanel.identifyUser(user!, newUser: newUser!)
            Mixpanel.registerSuperPropertiesForUser(user!)
            // Record user's device
            Services.User.Actions.recordDevice(nil, completionHandler: nil)
            
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
                
                let allInfoVerified = self.dynamicType.checkUser(unverifiedPhoneHandler: { () -> Void in
                    let welcomeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
                    self.navigationController?.setViewControllers([welcomeVC], animated: true)
                }, unverifiedProfileHandler: {
                    let welcomeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
                    welcomeVC.goToPhoneVerification = false
                    self.navigationController?.setViewControllers([welcomeVC], animated: true)
                })
                
                if allInfoVerified {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    private func fetchAndCacheUserProfile(userId: String, completion: (error: NSError?) -> Void) {
        // XXX handle profile doesn't exist
        Services.Profile.Actions.getProfile(userId: userId) { (profile, error) -> Void in
            if let profile = profile {
                self.dynamicType.updateUserProfile(profile)
                self.fetchAndCacheUserOrganization(profile.organizationId, userId: profile.userId, completion: completion)
            } else {
                completion(error: error)
            }
        }
    }
    
    private func fetchAndCacheUserOrganization(organizationId: String, userId: String, completion: (error: NSError?) -> Void) {
        Services.Organization.Actions.getOrganization(organizationId) { (organization, error) -> Void in
            if let organization = organization {
                self.dynamicType.updateOrganization(organization)
                self.fetchAndCacheUserIdentities(userId, completion: completion)
            } else {
                completion(error: error)
            }
        }
    }
    
    private func fetchAndCacheUserIdentities(userId: String, completion: (error: NSError?) -> Void) {
        Services.User.Actions.getIdentities(userId) { (identities, error) -> Void in
            if let identities = identities {
                self.dynamicType.updateIdentities(identities)
            }
            completion(error: error)
        }

    }
    
    // MARK: - Log out
    
    static func logOut(shouldDisconnect: Bool? = false) {
        // Clear keychain
        if let user = LoggedInUserHolder.user {
            Locksmith.deleteDataForUserAccount(user.id, inService: LocksmithService)
        }
        if let disconnect = shouldDisconnect {
            if disconnect {
                GIDSignIn.sharedInstance().disconnect()
            }
        }
        GIDSignIn.sharedInstance().signOut()
        
        // Remove local cached date
        LoggedInUserHolder.profile = nil
        LoggedInUserHolder.user = nil
        LoggedInUserHolder.token = nil
        LoggedInUserHolder.organization = nil
        ObjectStore.sharedInstance.reset(self)
        
        // Remove persistent cached data
        NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsUserKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsProfileKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsOrganizationKey)
        
        // Notify everyone
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthNotifications.onLogoutNotification,
            object: nil
        )
        
        // Present auth view
        presentAuthViewController()
    }
    
    private static func presentViewControllerWithNavigationController(vc: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
    }
    
    static func presentAuthViewController() {
        // Check if user is logged in. If not, present auth view controller
        let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(authViewController)
    }

    static func presentWelcomeView(goToPhoneVerification: Bool) {
        let welcomeVC = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
        welcomeVC.goToPhoneVerification = goToPhoneVerification
        self.presentViewControllerWithNavigationController(welcomeVC)
    }
    
    static func presentHomelessViewController() {
        let homelessVC = HomelessViewController(nibName: "HomelessViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(homelessVC)
    }
    
    // MARK: - Logged In User Helpers
    
    static func getLoggedInUser() -> Services.User.Containers.UserV1? {
        if let user = LoggedInUserHolder.user {
            return user
        } else {
            if let user = self.loadCachedUser() {
                return user
            }
        }
        return nil
    }
    
    static func getLoggedInUserProfile() -> Services.Profile.Containers.ProfileV1? {
        if let profile = LoggedInUserHolder.profile {
            return profile
        } else {
            if let profile = self.loadCachedProfile() {
                return profile
            }
        }
        return nil
    }
    
    static func getLoggedInUserOrganization() -> Services.Organization.Containers.OrganizationV1? {
        if let organization = LoggedInUserHolder.organization {
            return organization
        } else {
            if let organization = self.loadCachedOrganization() {
                return organization
            }
        }
        return nil
    }
    
    static func getLoggedInUserToken() -> String? {
        if let token = LoggedInUserHolder.token {
            return token
        } else {
            if let user = self.getLoggedInUser() {
                let (data, error) = Locksmith.loadDataForUserAccount(user.id, inService: LocksmithService)
                if let token = data?.allKeys[0] as? String {
                    cacheTokenAndUserInMemory(token, user: user)
                    return token
                }
            }
        }
        return nil
    }
    
    static func getLoggedInUserIdentities() -> Array<Services.User.Containers.IdentityV1>? {
        if let identities = LoggedInUserHolder.identities {
            return identities
        } else {
            if let identities = self.loadCachedIdentities() {
                return identities
            }
        }
        return nil
    }
    
    static func updateUserProfile(profile: Services.Profile.Containers.ProfileV1) {
        LoggedInUserHolder.profile = profile
        cacheProfileData(profile)
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthNotifications.onProfileChangedNotification,
            object: profile
        )
    }
    
    static func updateUser(user: Services.User.Containers.UserV1) {
        LoggedInUserHolder.user = user
        cacheUserData(user)
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthNotifications.onUserChangedNotification,
            object: user
        )
    }
    
    static func updateOrganization(organization: Services.Organization.Containers.OrganizationV1) {
        LoggedInUserHolder.organization = organization
        cacheOrganizationData(organization)
    }
    
    static func updateIdentities(identities: Array<Services.User.Containers.IdentityV1>)  {
        LoggedInUserHolder.identities = identities
        cacheUserIdentities(identities)
    }
    
    // MARK: - Authentication Helpers
    
    static func checkUser(#unverifiedPhoneHandler: (() -> Void)?, unverifiedProfileHandler: (() -> Void)?) -> Bool {
        if let user = getLoggedInUser() {
            Crashlytics.sharedInstance().setUserIdentifier(user.id)

            if getLoggedInUserProfile() == nil {
                self.presentHomelessViewController()
                return false
            }
            
            if !user.phoneNumberVerified {
                if let handler = unverifiedPhoneHandler {
                    handler()
                } else {
                    presentWelcomeView(true)
                }
                return false
            }
            
            if let profile = getLoggedInUserProfile() {
                if !profile.verified {
                    if let handler = unverifiedProfileHandler {
                        handler()
                    } else {
                        presentWelcomeView(false)
                    }
                }
            }
        } else {
            presentAuthViewController()
            return false
        }
        return true
    }
    
    // MARK: - Tracking
    
    private func trackSignupLogin(backend: Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1, newUser: Bool) {
        let properties = [TrackerProperty.withKeyString("auth_backend").withValue(Int(backend.rawValue))]
        if newUser {
            Tracker.sharedInstance.track(.UserSignup, properties: properties)
        } else {
            Tracker.sharedInstance.track(.UserLogin, properties: properties)
        }
    }
    
    // MARK: - Passcode & Touch ID
    
    static func initializeSplashViewWithPasscodeAndTouchID() {
        VENTouchLock.sharedInstance().setKeychainService(
            LocksmithService, 
            keychainAccount: AuthPasscode, 
            touchIDReason: NSLocalizedString("Touch to unlock circle", comment: "Help text for touch ID alert"),
            passcodeAttemptLimit: 10, 
            splashViewControllerClass: SplashViewController.self
        )
    }

    // MARK: - IBActions
    
    @IBAction func googlePlusSignInButtonTapped(sender: AnyObject!) {
        startingGoogleAuthentication(sender)
        GIDSignIn.sharedInstance().signIn()
    }
}
