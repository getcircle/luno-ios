//
//  AppDelegateAppearanceExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func customizeAppearance(application: UIApplication) {
        application.setStatusBarStyle(.LightContent, animated: false)
        window!.tintColor = UIColor.appTintColor()
        UINavigationBar.appearance().tintColor = UIColor.navigationBarTintColor()
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarBarTintColor()

        let navBarTitleAttributes = [
            NSFontAttributeName: UIFont.navigationBarFont(),
            NSForegroundColorAttributeName: UIColor.navigationBarTitleColor(),
        ]
        UINavigationBar.appearance().titleTextAttributes = navBarTitleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarTitleAttributes, forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarTitleAttributes, forState: .Highlighted)
    }
}