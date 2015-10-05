//
//  AuthenticationViewController.swift
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

struct AuthenticationNotifications {
    static let onLoginNotification = "com.rhlabs.notification:onLoginNotification"
    static let onLogoutNotification = "com.rhlabs.notification:onLogoutNotification"
    static let onProfileChangedNotification = "com.rhlabs.notification:onProfileChangedNotification"
    static let onUserChangedNotification = "com.rhlabs.notifcation:onUserChangedNotification"
}

private let AuthenticationPasscode = "AuthenticationPasscode"
private let LocksmithMainUserAccount = "LocksmithMainUserAccount"
private let LocksmithAuthenticationTokenService = "LocksmithAuthenticationTokenService"
private let DefaultsUserKey = "DefaultsUserKey"
private let DefaultsProfileKey = "DefaultsProfileKey"
private let DefaultsLastLoggedInUserEmail = "DefaultsLastLoggedInUserEmail"
private let DefaultsOrganizationKey = "DefaultsOrganizationKey"
private let DefaultsIdentitiesKey = "DefaultsIdentitiesKey"

private let GoogleClientID = "1077014421904-pes3pbf96obmp75kb00qouoiqf18u78h.apps.googleusercontent.com"
private let GoogleServerClientID = "1077014421904-1a697ks3qvtt6975qfqhmed8529en8s2.apps.googleusercontent.com"

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var workEmailTextField: UITextField!

    private var activityIndicator: CircleActivityIndicatorView?
    private var signInButtonText: String?
    private var passwordFieldBottomBorder: UIView!
    private var authorizationVC = AuthorizationViewController()
    private var isNewAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureGoogleAuthentication()
        configurePasswordField()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        registerNotifications()
        workEmailTextField.becomeFirstResponder()
    }

    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
        titleLabel.text = AppStrings.SignInCTA
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapView:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureGoogleAuthentication() {
        workEmailTextField.attributedPlaceholder = NSAttributedString(
            string: AppStrings.SignInPlaceHolderText,
            attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]
        )
        workEmailTextField.tintColor = UIColor.whiteColor()
        workEmailTextField.addBottomBorder(color: UIColor.whiteColor())
        signInButton.titleLabel!.font = UIFont.appSocialCTATitleFont()
        signInButton.addRoundCorners(radius: 2.0)
        signInButton.backgroundColor = UIColor.appTintColor()
        signInButton.setCustomAttributedTitle(
            AppStrings.SignInCTA.localizedUppercaseString(),
            forState: .Normal
        )
    }
    
    private func configurePasswordField() {
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: AppStrings.PasswordTextFieldPlaceholder,
            attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]
        )
        passwordTextField.tintColor = UIColor.whiteColor()
        passwordFieldBottomBorder = passwordTextField.addBottomBorder(color: UIColor.whiteColor())
        passwordTextField.alpha = 0.0
        passwordFieldBottomBorder.alpha = 0.0
    }
    
    private func registerNotifications() {
        // Do not unregister this notification in viewDidDisappear
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "onServiceAuthorized:",
            name: AuthorizationNotifications.onServiceAuthorizedNotification,
            object: authorizationVC
        )
    }

    // MARK: - Targets
    
    func didTapView(sender: AnyObject!) {
        workEmailTextField.resignFirstResponder()
    }

    func onServiceAuthorized(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let authDetails = userInfo["oauth_sdk_details"] as? Services.User.Containers.OAuthSDKDetailsV1 {
                googleLogin(authDetails)

            } else if let samlDetails = userInfo["saml_details"] as? Services.User.Containers.SAMLDetailsV1 {
                oktaLogin(samlDetails)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func googleLogin(authDetails: Services.User.Containers.OAuthSDKDetailsV1) {
        let credentials = Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1.Builder()
        credentials.key = authDetails.code
        credentials.secret = authDetails.idToken
        login(.Google, credentials: try! credentials.build())
    }
    
    private func oktaLogin(samlDetails: Services.User.Containers.SAMLDetailsV1) {
        let credentials = Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1.Builder()
        credentials.secret = samlDetails.authState
        login(.Okta, credentials: try! credentials.build())
    }
    
    private static func loadCachedUser() -> Services.User.Containers.UserV1? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsUserKey) as? NSData {
            return try! Services.User.Containers.UserV1.parseFromData(data)
        }
        return nil
    }
    
    private static func loadCachedProfile() -> Services.Profile.Containers.ProfileV1? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsProfileKey) as? NSData {
            return try! Services.Profile.Containers.ProfileV1.parseFromData(data)
        }
        return nil
    }
    
    private static func loadCachedOrganization() -> Services.Organization.Containers.OrganizationV1? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsOrganizationKey) as? NSData {
            return try! Services.Organization.Containers.OrganizationV1.parseFromData(data)
        }
        return nil
    }
    
    private static func loadCachedIdentities() -> Array<Services.User.Containers.IdentityV1>? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultsIdentitiesKey) as? [NSData] {
            var identities = Array<Services.User.Containers.IdentityV1>()
            for object in data {
                identities.append(try! Services.User.Containers.IdentityV1.parseFromData(object))
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
        CircleCache.updateCachedDataInRecordedSearchResultsForProfile(profile)
    }
    
    private static func cacheOrganizationData(organization: Services.Organization.Containers.OrganizationV1) {
        NSUserDefaults.standardUserDefaults().setObject(organization.data(), forKey: DefaultsOrganizationKey)
    }
    
    private static func cacheUserIdentities(identities: Array<Services.User.Containers.IdentityV1>) {
        var cleanIdentities = [NSData]()
        for identity in identities {
            let builder = try! identity.toBuilder()
            builder.clearAccessToken()
            builder.clearRefreshToken()
            cleanIdentities.append(try! builder.build().data())
        }
        NSUserDefaults.standardUserDefaults().setObject(cleanIdentities, forKey: DefaultsIdentitiesKey)
    }
    
    private func cacheLoginData(token: String, user: Services.User.Containers.UserV1) {
        // Cache locally
        self.dynamicType.cacheTokenAndUserInMemory(token, user: user)

        // Cache token to keychain
        do {
            try Locksmith.updateData(
                [token: "\(NSDate())"],
                forUserAccount: user.id,
                inService: LocksmithAuthenticationTokenService)
        }
        catch {
            // XXX what is the correct way to report errors?
            print("Error: \(error)")
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
        signInButtonText = signInButton.titleLabel?.text
        signInButton.setCustomAttributedTitle("", forState: .Normal)
        if activityIndicator == nil {
            activityIndicator = signInButton.addActivityIndicator(UIColor.whiteColor(), start: false)
        }
        activityIndicator?.startAnimating()
        signInButton.enabled = false
        workEmailTextField.enabled = false
    }
    
    private func hideLoadingState() {
        activityIndicator?.stopAnimating()
        if signInButtonText != nil {
            signInButton.setCustomAttributedTitle(signInButtonText!, forState: .Normal)
        }
        signInButton.backgroundColor = UIColor.appTintColor()
        signInButton.enabled = true
        workEmailTextField.enabled = true
    }
    
    // MARK: - Log in
    
    private func login(
        backend: Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1,
        credentials: Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1,
        silent: Bool = false
    ) {
        if !silent {
            showLoadingState()
        }
        Services.User.Actions.authenticateUser(backend, credentials: credentials) { (user, token, newUser, error) -> Void in
            // TODO we should be explicitly checking the authenticated bool here or existence of a token
            if error != nil {
                if !silent {
                    self.hideLoadingState()
                    self.signInButton.addShakeAnimation()
                }
                return
            }

            Mixpanel.identifyUser(user!, newUser: newUser!)
            Mixpanel.registerSuperPropertiesForUser(user!)
            
            self.trackSignupLogin(backend, newUser: newUser!)
            self.cacheLoginData(token!, user: user!)
            self.fetchAndCacheUserProfile(user!.id) { (error) in
                // Record user's device
                Services.User.Actions.recordDevice(nil, completionHandler: nil)
                
                if error != nil {
                    let homelessVC = HomelessViewController(nibName: "HomelessViewController", bundle: nil)
                    self.navigationController?.setViewControllers([homelessVC], animated: true)
                    return
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(
                    AuthenticationNotifications.onLoginNotification,
                    object: nil
                )
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    private func fetchAndCacheUserProfile(userId: String, completion: (error: NSError?) -> Void) {
        // XXX handle profile doesn't exist
        Services.Profile.Actions.getProfile { (profile, error) -> Void in
            if let profile = profile {
                self.dynamicType.updateUserProfile(profile)
                self.dynamicType.fetchAndCacheUserOrganization(profile.userId, completion: completion)
            } else {
                completion(error: error)
            }
        }
    }
    
    static func fetchAndCacheUserOrganization(userId: String, completion: ((error: NSError?) -> Void)?) {
        Services.Organization.Actions.getOrganization() { (organization, error) -> Void in
            if let organization = organization {
                self.updateOrganization(organization)
                self.fetchAndCacheUserIdentities(userId, completion: completion)
            } else {
                completion?(error: error)
            }
        }
    }
    
    static func fetchAndCacheUserIdentities(userId: String, completion: ((error: NSError?) -> Void)?) {
        Services.User.Actions.getIdentities(userId) { (identities, error) -> Void in
            if let identities = identities {
                self.updateIdentities(identities)
            }
            completion?(error: error)
        }

    }
    
    // MARK: - Log out
    
    static func logOut() {
        Services.User.Actions.logout { (error) in
            if error != nil {
                print("error logging user out from server: \(error)")
            }
            
            // Clear all objects in CircleCache
            CircleCache.sharedInstance.clearCache()

            // Clear keychain
            do {
                if let user = LoggedInUserHolder.user {
                    try Locksmith.deleteDataForUserAccount(user.id, inService: LocksmithAuthenticationTokenService)
                }
            }
            catch {
                print("Error: \(error)")
            }
            
            // Remove local cached date
            LoggedInUserHolder.profile = nil
            LoggedInUserHolder.user = nil
            LoggedInUserHolder.token = nil
            LoggedInUserHolder.organization = nil
            
            // Remove persistent cached data
            NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsUserKey)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsProfileKey)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultsOrganizationKey)
            
            // Notify everyone
            NSNotificationCenter.defaultCenter().postNotificationName(
                AuthenticationNotifications.onLogoutNotification,
                object: nil
            )
            
            // Switch to default theme on logout
            AppTheme.switchToDefaultTheme()
            
            // Present Authentication view
            self.presentSplashViewController()
        }
    }
    
    private static func presentViewControllerWithNavigationController(vc: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(navController, animated: false, completion: nil)
    }

    private static func presentViewControllerWithoutNavigationController(vc: UIViewController) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.rootViewController!.presentViewController(vc, animated: false, completion: nil)
    }

    static func presentSplashViewController() {
        // Check if user is logged in. If not, present authentication view controller
        let splashViewController = SplashViewController(nibName: "SplashViewController", bundle: nil)
        self.presentViewControllerWithNavigationController(splashViewController)
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
                let dict = Locksmith.loadDataForUserAccount(user.id, inService: LocksmithAuthenticationTokenService)
                if let token = dict?.keys.first {
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
            AuthenticationNotifications.onProfileChangedNotification,
            object: profile
        )
    }
    
    static func updateUser(user: Services.User.Containers.UserV1) {
        LoggedInUserHolder.user = user
        cacheUserData(user)
        NSNotificationCenter.defaultCenter().postNotificationName(
            AuthenticationNotifications.onUserChangedNotification,
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
    
    static func checkUser(unverifiedPhoneHandler unverifiedPhoneHandler: (() -> Void)?, unverifiedProfileHandler: (() -> Void)?) -> Bool {
        if let user = getLoggedInUser() {
            Crashlytics.sharedInstance().setUserIdentifier(user.id)

            if getLoggedInUserProfile() == nil {
                self.presentHomelessViewController()
                return false
            }
            
            // Check if the counts are zero. If yes, fetch and update organization details in local cache
            if let organization = getLoggedInUserOrganization() where organization.profileCount == 0 {
                fetchAndCacheUserOrganization(user.id, completion: nil)
            }
        } else {
            presentSplashViewController()
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
            LocksmithAuthenticationTokenService, 
            keychainAccount: AuthenticationPasscode, 
            touchIDReason: NSLocalizedString("Touch to unlock circle", comment: "Help text for touch ID alert"),
            passcodeAttemptLimit: 10, 
            splashViewControllerClass: PasscodeTouchIDSplashViewController.self
        )
    }

    // MARK: - IBActions
    
    @IBAction func signInButtonTapped(sender: AnyObject!) {
        // Check if there is an account for this email address
        // If yes, check if its google sign in or regular sign in
        // If google sign in, redirect to social connect
        // If password sign in, show password
        // If user does not have an account, show password and change title to create account
        if workEmailTextField.text?.trimWhitespace() == "" {
            signInButton.addShakeAnimation()
            return
        }
        
        if passwordTextField.alpha == 1.0 && passwordTextField.text?.trimWhitespace() == "" {
            signInButton.addShakeAnimation()
            return
        }

        showLoadingState()
        if passwordTextField.alpha == 1.0 {
            if isNewAccount {
                signUpUser()
            }
            else {
                signInUser()
            }
        }
        else {
            checkAuthenticationMethod()
        }
    }
    
    private func checkAuthenticationMethod() {
        Services.User.Actions.getAuthenticationInstructions(workEmailTextField.text ?? "", completionHandler: { (backend, accountExists, authorizationURL, providerName, error) -> Void in
            self.hideLoadingState()
            
            var provider: Services.User.Containers.IdentityV1.ProviderV1
            switch backend! {
            case .Okta:
                provider = .Okta
            default:
                provider = .Google
            }
            
            if error != nil {
                self.signInButton.addShakeAnimation()
            }
            else if let authorizationURL = authorizationURL, providerName = providerName where authorizationURL.trimWhitespace() != "" {
                self.openExternalAuthentication(provider, authorizationURL: authorizationURL, providerName: providerName)
            }
            else {
                let newAccount = (accountExists != nil) ? !(accountExists!) : true
                self.isNewAccount = newAccount
                self.showPasswordField(newAccount)
            }
        })
    }
    
    private func signUpUser() {
        Services.User.Actions.createUser(workEmailTextField.text?.trimWhitespace() ?? "", password: passwordTextField.text?.trimWhitespace() ?? "") { (user, error) -> Void in
            self.hideLoadingState()
            if error != nil {
                print("Error \(error)")
                self.signInButton.addShakeAnimation()
                let alertController = UIAlertController(title: "Error signing up", message: "There was an error in creating your account. Please try again.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                self.signInUser()
            }
        }
    }

    private func signInUser() {
        let credentials = Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1.Builder()
        credentials.key = workEmailTextField.text?.trimWhitespace() ?? ""
        credentials.secret = passwordTextField.text?.trimWhitespace() ?? ""
        login(.Internal, credentials: try! credentials.build())
    }
    
    private func openExternalAuthentication(provider: Services.User.Containers.IdentityV1.ProviderV1, authorizationURL: String, providerName: String) {
        authorizationVC.provider = provider
        authorizationVC.loginHint = workEmailTextField.text
        authorizationVC.providerName = providerName
        if authorizationURL.trimWhitespace() != "" {
            authorizationVC.authorizationURL = authorizationURL
        }
        let socialNavController = UINavigationController(rootViewController: authorizationVC)
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            socialNavController.modalPresentationStyle = .FormSheet
        }
        
        presentViewController(socialNavController, animated: true, completion: {() -> Void in
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        })
    }
    
    private func showPasswordField(newAccount: Bool) {
        signInButtonTopConstraint.constant = 80.0
        signInButton.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.3,
            animations: { () -> Void in
                self.passwordTextField.alpha = 1.0
                self.passwordFieldBottomBorder.alpha = 1.0
                self.signInButton.layoutIfNeeded()
            },
            completion: { (completed) -> Void in
                self.passwordTextField.becomeFirstResponder()
            }
        )
        
        if newAccount {
            titleLabel.text = AppStrings.SignUpCTA
            signInButton.setCustomAttributedTitle(
                AppStrings.SignUpCTA.localizedUppercaseString(),
                forState: .Normal
            )
        }
    }
    
    private func hidePasswordField(newAccount: Bool) {
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordTextField {
            signInButtonTapped(textField)
        }

        return true
    }
}
