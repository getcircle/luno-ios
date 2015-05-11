//
//  AppTheme.swift
//  Circle
//
//  Created by Ravi Rani on 5/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
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

struct SoulCycleTheme: Theme {
    var app_tint_color = UIColor(red: 255, green: 217, blue: 21)
    var app_ui_background_color = UIColor(red: 240, green: 240, blue: 240)
    
    var app_nav_bar_color = UIColor(red: 240, green: 240, blue: 240)
    var app_nav_bar_text_controls_color = UIColor(red: 66, green: 66, blue: 66)
    
    var app_tab_bar_color = UIColor(red: 254, green: 224, blue: 0)
    var app_tab_bar_text_controls_color = UIColor(red: 66, green: 66, blue: 66)
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 120, green: 113, blue: 71)
    
    var app_light_text_color = UIColor(red: 67, green: 66, blue: 67)
    var app_dark_text_color = UIColor(red: 66, green: 66, blue: 66)
    
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
        println(organization.domain)
        if organization.domain == "soul-cycle.com" {
            if !(AppTheme.currentTheme is SoulCycleTheme) {
                AppTheme.currentTheme = SoulCycleTheme()
                updateAppearanceProxy()                
            }
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
