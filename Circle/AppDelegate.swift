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
    
}

