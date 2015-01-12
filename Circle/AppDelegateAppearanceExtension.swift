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
        application.setStatusBarStyle(.LightContent, animated: false)
        
        if let appWindow = window {
            appWindow.layer.cornerRadius = 6.0
            appWindow.layer.masksToBounds = true
            appWindow.layer.opaque = false
            appWindow.layer.shouldRasterize = true
            appWindow.layer.rasterizationScale = UIScreen.mainScreen().scale
        }
        
        window!.tintColor = UIColor.appTintColor()
        UINavigationBar.appearance().tintColor = UIColor.navigationBarTintColor()
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarBarTintColor()
        UINavigationBar.appearance().translucent = false

        let navBarTitleAttributes = [
            NSFontAttributeName: UIFont.navigationBarFont(),
            NSForegroundColorAttributeName: UIColor.navigationBarTitleColor(),
        ]
        UINavigationBar.appearance().titleTextAttributes = navBarTitleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarTitleAttributes, forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarTitleAttributes, forState: .Highlighted)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffsetMake(0.0, -60.0),
            forBarMetrics: .Default
        )
        var backButtonImage = UIImage(named: "PreviousFilled")!.imageWithRenderingMode(.AlwaysTemplate)
        backButtonImage = backButtonImage.resizableImageWithCapInsets(UIEdgeInsetsMake(0.0, 32.0, 0.0, 0.0))
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(
            backButtonImage,
            forState: .Normal,
            barMetrics: .Default
        )
    }
}