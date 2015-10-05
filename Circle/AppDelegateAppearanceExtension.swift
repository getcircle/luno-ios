//
//  AppDelegateAppearanceExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func customizeAppearance(application: UIApplication) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        UIApplication.sharedApplication().setStatusBarStyle(AppTheme.currentTheme.status_bar_style, animated: false)
        
        window!.tintColor = UIColor.appUIBackgroundColor()
        UINavigationBar.appearance().tintColor = UIColor.appNavigationBarTintColor()
        UINavigationBar.appearance().barTintColor = UIColor.appNavigationBarBarTintColor()
        UINavigationBar.appearance().translucent = false

        UITabBar.appearance().tintColor = UIColor.appTabBarTintColor()
        UITabBar.appearance().barTintColor = UIColor.appTabBarBarTintColor()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage.imageFromColor(
            UIColor.appTabBarBarTintColor(),
            withRect: CGRectMake(0.0, 0.0, 1.0, 1.0)
        )

        let navBarTitleAttributes = [
            NSFontAttributeName: UIFont.navigationBarFont(),
            NSForegroundColorAttributeName: UIColor.appNavigationBarTitleColor(),
        ]
        let disabledBarButtonItemTitleAttributes = [
            NSFontAttributeName: UIFont.navigationBarFont(),
            NSForegroundColorAttributeName: UIColor(white: 0.0, alpha: 0.2),
        ]
        UINavigationBar.appearance().titleTextAttributes = navBarTitleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarTitleAttributes, forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarTitleAttributes, forState: .Highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(disabledBarButtonItemTitleAttributes, forState: .Disabled)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffsetMake(0.0, -60.0),
            forBarMetrics: .Default
        )
        let backButtonImage = UIImage(named: "navbar_back")!.imageWithRenderingMode(.AlwaysTemplate)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(
            backButtonImage,
            forState: .Normal,
            barMetrics: .Default
        )
        
        UIButton.appearance().tintColor = UIColor.appTintColor()
    }
}
