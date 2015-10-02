//
//  AppDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import Crashlytics
import Mixpanel
import ProtobufRegistry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Customize Appearance
        customizeAppearance(application)

        // Set theme if user is already logged in
        AppTheme.updateThemeForOrganization()
        
        // Setup Third Party Services
        Crashlytics.startWithAPIKey("e4192b2c032ea5f8065aac4bde634b85760f8d49")
        Mixpanel.setup()
        
        // Record device
        Services.User.Actions.recordDevice(nil, completionHandler: nil)

        // Initialize splash view with passcode & touch ID
        AuthenticationViewController.initializeSplashViewWithPasscodeAndTouchID()
        
        // Register app level notifications
        registerNotifications()

        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        Tracker.sharedInstance.trackSessionStart()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        Tracker.sharedInstance.trackSessionEnd()
    }

    // MARK: - Remote Notification Delegate
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var deviceTokenString = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        deviceTokenString = deviceTokenString.stringByReplacingOccurrencesOfString(" ", withString: "")
        deviceTokenString = deviceTokenString.trimWhitespace()
        Mixpanel.sharedInstance().people.addPushDeviceToken(deviceToken)
        Services.User.Actions.recordDevice(deviceTokenString, completionHandler: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Error registering for notifications \(error)")
    }
    
    // MARK: - Notification
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "recordUsersLocaleSetting:", 
            name: NSCurrentLocaleDidChangeNotification, 
            object: nil
        )
    }

    // MARK: - Notification Handlers

    func recordUsersLocaleSetting(sender: AnyObject!) {
        let preferredLanguage: String = NSLocale.preferredLanguages()[0] 
        // TODO: Register language
        print(preferredLanguage)
    }
}
