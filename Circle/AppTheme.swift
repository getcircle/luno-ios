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
    var app_ui_background_color = UIColor(red: 255, green: 217, blue: 21)
    
    var app_nav_bar_color = UIColor(red: 240, green: 240, blue: 240)
    var app_nav_bar_text_controls_color = UIColor(red: 66, green: 66, blue: 66)
    
    var app_tab_bar_color = UIColor(red: 254, green: 224, blue: 0)
    var app_tab_bar_text_controls_color = UIColor(red: 66, green: 66, blue: 66)
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 120, green: 113, blue: 71)
    
    var app_light_text_color = UIColor(red: 67, green: 66, blue: 67)
    var app_dark_text_color = UIColor(red: 66, green: 66, blue: 66)
    
    var status_bar_style = UIStatusBarStyle.Default
}

struct LookoutTheme: Theme {
    var app_tint_color = UIColor(red: 0, green: 190, blue: 78)
    var app_ui_background_color = UIColor(red: 0, green: 190, blue: 78)
    
    var app_nav_bar_color = UIColor(red: 0, green: 190, blue: 78)
    var app_nav_bar_text_controls_color = UIColor(red: 255, green: 255, blue: 255)
    
    var app_tab_bar_color = UIColor(red: 248, green: 248, blue: 248)
    var app_tab_bar_text_controls_color = UIColor(red: 44, green: 44, blue: 44)
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 160, green: 160, blue: 160)
    
    var app_light_text_color = UIColor(red: 245, green: 245, blue: 245)
    var app_dark_text_color = UIColor(red: 0, green: 0, blue: 0)
    
    var status_bar_style = UIStatusBarStyle.LightContent
}

struct NetflixTheme: Theme {
    var app_tint_color = UIColor(red: 229, green: 9, blue: 20)
    var app_ui_background_color = UIColor(red: 229, green: 9, blue: 20)
    
    var app_nav_bar_color = UIColor(red: 229, green: 9, blue: 20)
    var app_nav_bar_text_controls_color = UIColor(red: 255, green: 255, blue: 255)
    
    var app_tab_bar_color = UIColor(red: 248, green: 248, blue: 248)
    var app_tab_bar_text_controls_color = UIColor(red: 44, green: 44, blue: 44)
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 160, green: 160, blue: 160)
    
    var app_light_text_color = UIColor(red: 245, green: 245, blue: 245)
    var app_dark_text_color = UIColor(red: 0, green: 0, blue: 0)
    
    var status_bar_style = UIStatusBarStyle.LightContent
}

struct BoxTheme: Theme {
    var app_tint_color = UIColor(red: 29, green: 94, blue: 166)
    var app_ui_background_color = UIColor(red: 29, green: 94, blue: 166)
    
    var app_nav_bar_color = UIColor(red: 29, green: 94, blue: 166)
    var app_nav_bar_text_controls_color = UIColor(red: 255, green: 255, blue: 255)
    
    var app_tab_bar_color = UIColor(red: 37, green: 37, blue: 37)
    var app_tab_bar_text_controls_color = UIColor(red: 253, green: 253, blue: 253)
    var app_tab_bar_deselected_text_controls_color = UIColor(red: 160, green: 160, blue: 160)
    
    var app_light_text_color = UIColor(red: 245, green: 245, blue: 245)
    var app_dark_text_color = UIColor(red: 48, green: 48, blue: 48)
    
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
            case "soul-cycle.com":
                newTheme = SoulCycleTheme()
            case "lookout.com":
                newTheme = LookoutTheme()
            case "netflix.com":
                newTheme = NetflixTheme()
            case "box.com":
                newTheme = BoxTheme()
            default:
                newTheme = DefaultTheme()
        }
        
        if String(stringInterpolationSegment: AppTheme.currentTheme.dynamicType) != String(stringInterpolationSegment: newTheme.dynamicType) {
            AppTheme.currentTheme = newTheme
            updateAppearanceProxy()
            println(organization.domain)
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

