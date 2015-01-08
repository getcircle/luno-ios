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

        // Setup Crashlytics
        Crashlytics.startWithAPIKey("e4192b2c032ea5f8065aac4bde634b85760f8d49")

        // Populate the Search Cache
        loadCacheForUser()

        return true
    }
}

