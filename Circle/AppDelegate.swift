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
        AuthViewController.initializeSplashViewWithPasscodeAndTouchID()
        
        // Register app level notifications
        registerNotifications()

        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
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
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Display an alert when the notification is received in the foreground
        handleRemoteNotification(userInfo)
        completionHandler(.NewData)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if let identifier = identifier {

            if identifier == NotificationAction.Approve.rawValue {
                if let requestID = userInfo[NotificationUserInfoKey.GroupRequestID.rawValue] as? String {
                    actOnGroupRequest(requestID, shouldApprove: true)
                }
            }
            else if identifier == NotificationAction.Deny.rawValue {
                if let requestID = userInfo[NotificationUserInfoKey.GroupRequestID.rawValue] as? String {
                    actOnGroupRequest(requestID, shouldApprove: false)
                }
            }
        }
        
        completionHandler()
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
