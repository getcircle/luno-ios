//
//  UIColorExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

extension UIColor {
    
    struct TeamColorsHolder {
        static var colors = [String: UIColor]()
    }

    struct GroupColorsHolder {
        static var colors = [String: UIColor]()
    }

    convenience init(red: Int, green: Int, blue: Int) {
        let newRed   = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue  = CGFloat(Double(blue) / 255.0)
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
    }
    
    static func appTintColor() -> UIColor {
        return AppTheme.currentTheme.app_tint_color
    }
    
    static func appUIBackgroundColor() -> UIColor {
        return AppTheme.currentTheme.app_ui_background_color
    }
    
    static func appDefaultLightTextColor() -> UIColor {
        return AppTheme.currentTheme.app_light_text_color
    }
    
    static func appDefaultDarkTextColor() -> UIColor {
        return AppTheme.currentTheme.app_dark_text_color
    }
    
    static func appNavigationBarBarTintColor() -> UIColor {
        return AppTheme.currentTheme.app_nav_bar_color
    }
    
    static func appNavigationBarTintColor() -> UIColor {
        return AppTheme.currentTheme.app_nav_bar_text_controls_color
    }
    
    static func appNavigationBarTitleColor() -> UIColor {
        return AppTheme.currentTheme.app_nav_bar_text_controls_color
    }
    
    static func appTabBarTintColor() -> UIColor {
        return AppTheme.currentTheme.app_tab_bar_text_controls_color
    }
    
    static func appTabBarBarTintColor() -> UIColor {
        return AppTheme.currentTheme.app_tab_bar_color
    }

    static func appTabBarDeselectedTintColor() -> UIColor {
        return AppTheme.currentTheme.app_tab_bar_deselected_text_controls_color
    }
    
    static func appPrimaryTextColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.8)
    }

    static func appSecondaryTextColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.5)
    }

    static func appSecondaryCTABackgroundColor() -> UIColor {
        return UIColor(red: 170, green: 170, blue: 170)
    }
    
    static func appSeparatorViewColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.12)
    }
    
    static func appCardContentSeparatorViewColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.06)
    }
    
    static func appSearchCardSeparatorViewColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.05)
    }
    
    static func appViewBackgroundColor() -> UIColor {
        return UIColor(red: 242, green: 244, blue: 245)
    }
    
    static func appSearchBackgroundColor() -> UIColor {
        return UIColor(red: 247, green: 248, blue: 250)
    }
    
    static func appLinkedinConnectCTABackgroundColor() -> UIColor {
        return UIColor(red: 36, green: 104, blue: 167)
    }

    static func appKeyValueNextImageTintColor() -> UIColor {
        return UIColor(red: 150, green: 150, blue: 150)
    }
    
    static func appSearchTextFieldBackground() -> UIColor {
        return UIColor(red: 220, green: 220, blue: 220)
    }
    
    static func appTagNormalBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static func appTagSelectedBackgroundColor() -> UIColor {
        return UIColor.appUIBackgroundColor()
    }

    static func appTagNormalBorderColor() -> UIColor {
        return UIColor(red: 212, green: 212, blue: 212)
    }
    
    static func appTagSelectedBorderColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static func appActionSheetControlsTintColor() -> UIColor {
        return UIColor(red: 85, green: 85, blue: 94)
    }
    
    static func appControlHighlightedColor() -> UIColor {
        return UIColor(red: 206, green: 206, blue: 206).colorWithAlphaComponent(0.5)
    }
    
    static func appTeamHeaderBackgroundColor(team: Services.Organization.Containers.TeamV1) -> UIColor {
        if let color = TeamColorsHolder.colors[team.id] {
            return color
        }
        else {
            let color = getRandomColor()
            TeamColorsHolder.colors[team.id] = color
            return color
        }
    }
    
    static func appGroupHeaderBackgroundColor(group: Services.Group.Containers.GroupV1) -> UIColor {
        if let color = GroupColorsHolder.colors[group.id] {
            return color
        }
        else {
            let color = getRandomColor()
            GroupColorsHolder.colors[group.id] = color
            return color
        }
    }
    
    private static func getRandomColor() -> UIColor {
        let randomPalette = [
            UIColor(red: 17, green: 36, blue: 65),
            UIColor(red: 65, green: 20, blue: 20),
            UIColor(red: 70, green: 33, blue: 18),
            UIColor(red: 37, green: 37, blue: 37),
            UIColor(red: 20, green: 50, blue: 21),
            UIColor(red: 44, green: 25, blue: 49)
        ]
        
        // flatuicolors.com
        let palette = [
            UIColor(red: 26, green: 188, blue: 156),
            UIColor(red: 26, green: 188, blue: 156),
            UIColor(red: 46, green: 204, blue: 113),
            UIColor(red: 52, green: 152, blue: 219),
            UIColor(red: 155, green: 89, blue: 182),
            UIColor(red: 52, green: 73, blue: 94),
            UIColor(red: 22, green: 160, blue: 133),
            UIColor(red: 39, green: 174, blue: 96),
            UIColor(red: 41, green: 128, blue: 185),
            UIColor(red: 142, green: 68, blue: 173),
            UIColor(red: 44, green: 62, blue: 80),
            UIColor(red: 241, green: 196, blue: 15),
            UIColor(red: 230, green: 126, blue: 34),
            UIColor(red: 231, green: 76, blue: 60),
            UIColor(red: 149, green: 165, blue: 166),
            UIColor(red: 243, green: 156, blue: 18),
            UIColor(red: 211, green: 84, blue: 0),
            UIColor(red: 192, green: 57, blue: 43),
            UIColor(red: 127, green: 140, blue: 141)
        ]
        
        return palette[Int(arc4random_uniform(UInt32(palette.count)))]
    }
    
    static func appProfileImageBackgroundColor(randomNumber withRandomNumber: Int? = 0) -> UIColor {
        let palette = [
            UIColor(red: 198, green: 174, blue: 141),
            UIColor(red: 196, green: 105, blue: 115),
            UIColor(red: 192, green: 133, blue: 174),
            UIColor(red: 179, green: 125, blue: 209),
            UIColor(red: 137, green: 143, blue: 210),
            UIColor(red: 119, green: 165, blue: 197),
            UIColor(red: 140, green: 203, blue: 157),
        ]

        let randomNumber = withRandomNumber != nil && withRandomNumber != 0 ? withRandomNumber : palette.count
        return palette[Int(arc4random_uniform(UInt32(randomNumber!)))]
    }
    
    static func appDetailViewBorderColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.8)
    }
    
    static func appActionButtonTintColor() -> UIColor {
        return UIColor(red: 0, green: 128, blue: 189)
    }
    
    static func appActivityIndicatorViewColor() -> UIColor {
        return UIColor(red: 51, green: 51, blue: 51)
    }
    
    static func appQuickActionsDarkTintColor() -> UIColor {
        return UIColor(red: 102, green: 102, blue: 102)
    }
    
    static func appButtonHighlightColor() -> UIColor {
        return UIColor(red: 215, green: 215, blue: 215)
    }
    
    static func appProfileImageBorderColor() -> UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
    }
    
    static func appSegmentedControlTitleNormalColor() -> UIColor {
        return UIColor.whiteColor().colorWithAlphaComponent(0.8)
    }

    static func appSegmentedControlTitleSelectedColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static func appAttributeTitleLabelColor() -> UIColor {
        return UIColor(red: 119, green: 119, blue: 119)
    }
    
    static func appSectionHeaderTextColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.4)
    }

    static func appAttributeValueLabelColor() -> UIColor {
        return UIColor(red: 48, green: 48, blue: 48)
    }
    
    static func appQuickActionsTintColor() -> UIColor {
        return UIColor(red: 119, green: 119, blue: 119)
    }
    
    static func appCTABackgroundColor() -> UIColor {
        return UIColor(red: 48, green: 48, blue: 48)
    }
    
    static func appCTATextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static func appWorkAnniversaryBannerBackground() -> UIColor {
        return UIColor(red: 0, green: 212, blue: 143)
    }
    
    static func appWorkAnniversaryBannerCTABackground() -> UIColor {
        return UIColor(red: 0, green: 169, blue: 115)
    }

    static func appBirthdayBannerBackground() -> UIColor {
        return UIColor(red: 0, green: 172, blue: 203)
    }
    
    static func appBirthdayBannerCTABackground() -> UIColor {
        return UIColor(red: 0, green: 137, blue: 163)
    }

    static func appNewHireBannerBackground() -> UIColor {
        return UIColor(red: 0, green: 172, blue: 203)
    }
    
    static func appNewHireBannerCTABackground() -> UIColor {
        return UIColor(red: 0, green: 137, blue: 163)
    }

    static func appHighlightColor() -> UIColor {
        return UIColor(red: 122, green: 142, blue: 255)
    }
    
    static func appIconBorderColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.2)
    }
    
    static func appIconColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    // MARK: - Social
    
    static func twitterColor() -> UIColor {
        return UIColor(red: 85, green: 172, blue: 238)
    }
    
    static func facebookColor() -> UIColor {
        return UIColor(red: 45, green: 68, blue: 134)
    }
    
    static func pinterestColor() -> UIColor {
        return UIColor(red: 197, green: 34, blue: 34)
    }
    
    static func googlePlusColor() -> UIColor {
        return UIColor(red: 211, green: 53, blue: 44)
    }
    
    static func linkedinColor() -> UIColor {
        return UIColor(red: 30, green: 136, blue: 190)
    }
    
    static func githubColor() -> UIColor {
        return UIColor(red: 83, green: 83, blue: 83)
    }
}
