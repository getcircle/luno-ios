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
    var app_tint_color = UIColor(red: 0, green: 201, blue: 255)
    var app_ui_background_color = UIColor(red: 47, green: 55, blue: 62)
    
    var app_nav_bar_color = UIColor(red: 47, green: 55, blue: 62)
    var app_nav_bar_text_controls_color = UIColor.whiteColor()
    
    var app_tab_bar_color = UIColor(red: 47, green: 55, blue: 62)
    var app_tab_bar_text_controls_color = UIColor(red: 0, green: 201, blue: 255)
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 145, green: 145, blue: 145)
    
    var app_light_text_color = UIColor.whiteColor()
    var app_dark_text_color = UIColor(red: 38, green: 38, blue: 38)
    
    var status_bar_style = UIStatusBarStyle.LightContent
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
        if let organization = AuthViewController.getLoggedInUserOrganization() {
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

