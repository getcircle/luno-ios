//
//  AppTheme.swift
//  Circle
//
//  Created by Ravi Rani on 5/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol Theme {
    var app_tint_color: UIColor { get }
    var app_ui_background_color: UIColor { get }
    
    var app_nav_bar_color: UIColor { get }
    var app_nav_bar_text_controls_color: UIColor { get }
    
    var app_tab_bar_color: UIColor { get }
    var app_tab_bar_text_controls_color: UIColor { get }
    var app_tab_bar_deselected_text_controls_color: UIColor { get }
    
    var app_light_text_color: UIColor { get }
    var app_dark_text_color: UIColor { get }
    
    var status_bar_style: UIStatusBarStyle { get }
}

struct DefaultTheme: Theme {
    var app_tint_color = UIColor.appHighlightColor()
    var app_ui_background_color = UIColor(red: 72, green: 73, blue: 89)
    
    var app_nav_bar_color = UIColor.whiteColor()
    var app_nav_bar_text_controls_color = UIColor.blackColor().colorWithAlphaComponent(0.7)
    
    var app_tab_bar_color = UIColor(white: 1.0, alpha: 0.5)
    var app_tab_bar_text_controls_color = UIColor.appHighlightColor()
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 176, green: 176, blue: 177)
    
    var app_light_text_color = UIColor.whiteColor()
    var app_dark_text_color = UIColor(red: 38, green: 38, blue: 38)
    
    var status_bar_style = UIStatusBarStyle.Default
}

struct AppTheme {
    static var currentTheme: Theme = DefaultTheme()
    
    static func switchToDefaultTheme() {
        if !(AppTheme.currentTheme is DefaultTheme) {
            AppTheme.currentTheme = DefaultTheme()
            updateAppearanceProxy()
        }
    }
    
    private static func changeThemeByOrganization(organization: Services.Organization.Containers.OrganizationV1) {
        let newTheme: Theme
        switch organization.domain {
            default:
                newTheme = DefaultTheme()
        }
        
        if String(stringInterpolationSegment: AppTheme.currentTheme.dynamicType) != String(stringInterpolationSegment: newTheme.dynamicType) {
            AppTheme.currentTheme = newTheme
            updateAppearanceProxy()
            print(organization.domain)
        }
    }
    
    static func updateThemeForOrganization() {
        // Switch app themes for organization
        if let organization = AuthenticationViewController.getLoggedInUserOrganization() {
            AppTheme.changeThemeByOrganization(organization)
        }
    }
    
    private static func updateAppearanceProxy() {
        let application = UIApplication.sharedApplication()
        let appDelegate = (application.delegate as! AppDelegate)
        appDelegate.customizeAppearance(application)
        if let viewController = appDelegate.window?.rootViewController {
            viewController.view.setNeedsLayout()
            viewController.view.setNeedsDisplay()
            viewController.view.layoutIfNeeded()
            viewController.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

