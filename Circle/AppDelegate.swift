//
//  AppDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
import ProtobufRegistry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Customize Appearance
        customizeAppearance(application)

        // Setup Third Party Services
        Crashlytics.startWithAPIKey("e4192b2c032ea5f8065aac4bde634b85760f8d49")
        Mixpanel.setup()

        // Populate the Search Cache
        loadStoreForUser()
        
        // Record device
        UserService.Actions.recordDevice(nil, completionHandler: nil)

        // Initialize splash view with passcode & touch ID
        AuthViewController.initializeSplashViewWithPasscodeAndTouchID()
        
        // Register app level notifications
        registerNotifications()

        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
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
        UserService.Actions.recordDevice(deviceTokenString, completionHandler: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Error registering for notifications \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Will ideally use a URL router here
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
        let preferredLanguage: String = NSLocale.preferredLanguages()[0] as String
        // TODO: Register language
        println(preferredLanguage)
    }
}
