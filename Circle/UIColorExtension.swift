//
//  UIColorExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIColor {

    struct TeamColorsHolder {
        static var colors = [String: UIColor]()
    }

    convenience init(red: Int, green: Int, blue: Int) {
        let newRed   = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue  = CGFloat(Double(blue) / 255.0)
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
    }
    
    class func appTintColor() -> UIColor {
        return UIColor(red: 0, green: 201, blue: 255)
    }
    
    class func appUIBackgroundColor() -> UIColor {
        // return UIColor(red: 225, green: 40, blue: 47)
        return UIColor(red: 47, green: 55, blue: 62)
    }
    
    class func appDefaultLightTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func appDefaultDarkTextColor() -> UIColor {
        return UIColor(red: 38, green: 38, blue: 38)
    }
    
    class func appPrimaryTextColor() -> UIColor {
        return UIColor(red: 48, green: 48, blue: 48)
    }

    class func appSecondaryTextColor() -> UIColor {
        return UIColor(red: 112, green: 112, blue: 112)
    }

    class func appNavigationBarBarTintColor() -> UIColor {
        return UIColor.appUIBackgroundColor()
    }

    class func appNavigationBarTintColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func appNavigationBarTitleColor() -> UIColor {
        return UIColor.whiteColor()
    }

    class func appTabBarBarTintColor() -> UIColor {
        return UIColor.appUIBackgroundColor()
    }
    
    class func appSeparatorViewColor() -> UIColor {
        return UIColor(red: 222, green: 222, blue: 222)
    }
    
    class func appViewBackgroundColor() -> UIColor {
        return UIColor(red: 240, green: 240, blue: 240)
    }
    
    class func appLinkedinConnectCTABackgroundColor() -> UIColor {
        return UIColor(red: 36, green: 104, blue: 167)
    }

    class func appKeyValueNextImageTintColor() -> UIColor {
        return UIColor(red: 150, green: 150, blue: 150)
    }
    
    class func appSearchTextFieldBackground() -> UIColor {
        return UIColor(red: 220, green: 220, blue: 220)
    }
    
    class func appSkillNormalBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func appSkillSelectedBackgroundColor() -> UIColor {
        return UIColor.appUIBackgroundColor()
    }

    class func appSkillNormalBorderColor() -> UIColor {
        return UIColor(red: 212, green: 212, blue: 212)
    }
    
    class func appSkillSelectedBorderColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func appActionSheetControlsTintColor() -> UIColor {
        return UIColor(red: 85, green: 85, blue: 94)
    }
    
    class func appControlHighlightedColor() -> UIColor {
        return UIColor(red: 206, green: 206, blue: 206).colorWithAlphaComponent(0.5)
    }
    
    class func appTeamHeaderBackgroundColor(teamId: String) -> UIColor {
        if let color = TeamColorsHolder.colors[teamId] {
            return color
        }
        else {
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
        
            let color = palette[Int(arc4random_uniform(UInt32(palette.count)))]
            TeamColorsHolder.colors[teamId] = color
            return color
        }
    }
    
    class func appProfileImageBackgroundColor(randomNumber withRandomNumber: Int? = 0) -> UIColor {
        let palette = [
            UIColor(red: 30, green: 146, blue: 57),
            UIColor(red: 14, green: 99, blue: 177),
            UIColor(red: 109, green: 109, blue: 109),
            UIColor(red: 213, green: 102, blue: 19),
            UIColor(red: 119, green: 65, blue: 133),
            UIColor(red: 179, green: 44, blue: 40),
        ]

        var randomNumber = withRandomNumber != nil && withRandomNumber != 0 ? withRandomNumber : palette.count
        return palette[Int(arc4random_uniform(UInt32(randomNumber!)))]
    }
    
    class func appDetailViewBorderColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.8)
    }
    
    class func appActionButtonTintColor() -> UIColor {
        return UIColor(red: 0, green: 128, blue: 189)
    }
    
    class func appActivityIndicatorViewColor() -> UIColor {
        return UIColor(red: 51, green: 51, blue: 51)
    }
    
    class func appQuickActionsDarkTintColor() -> UIColor {
        return UIColor(red: 102, green: 102, blue: 102)
    }
    
    class func appButtonHighlightColor() -> UIColor {
        return UIColor(red: 215, green: 215, blue: 215)
    }
    
    class func appProfileImageBorderColor() -> UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
    }
    
    class func appSegmentedControlTitleNormalColor() -> UIColor {
        return UIColor.whiteColor().colorWithAlphaComponent(0.8)
    }

    class func appSegmentedControlTitleSelectedColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func appAttributeTitleLabelColor() -> UIColor {
        return UIColor(red: 119, green: 119, blue: 119)
    }
    
    class func appQuickActionsTintColor() -> UIColor {
        return UIColor(red: 119, green: 119, blue: 119)
    }
    
    class func appCTABackgroundColor() -> UIColor {
        return UIColor(red: 48, green: 48, blue: 48)
    }
    
    class func appCTATextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func appWorkAnniversaryBannerBackground() -> UIColor {
        return UIColor(red: 0, green: 212, blue: 143)
    }
    
    class func appWorkAnniversaryBannerCTABackground() -> UIColor {
        return UIColor(red: 0, green: 169, blue: 115)
    }

    class func appBirthdayBannerBackground() -> UIColor {
        return UIColor(red: 0, green: 172, blue: 203)
    }
    
    class func appBirthdayBannerCTABackground() -> UIColor {
        return UIColor(red: 0, green: 137, blue: 163)
    }

    class func appNewHireBannerBackground() -> UIColor {
        return UIColor(red: 0, green: 172, blue: 203)
    }
    
    class func appNewHireBannerCTABackground() -> UIColor {
        return UIColor(red: 0, green: 137, blue: 163)
    }

    // MARK: - Social
    
    class func twitterColor() -> UIColor {
        return UIColor(red: 85, green: 172, blue: 238)
    }
    
    class func facebookColor() -> UIColor {
        return UIColor(red: 45, green: 68, blue: 134)
    }
    
    class func pinterestColor() -> UIColor {
        return UIColor(red: 197, green: 34, blue: 34)
    }
    
    class func googlePlusColor() -> UIColor {
        return UIColor(red: 211, green: 53, blue: 44)
    }
    
    class func linkedinColor() -> UIColor {
        return UIColor(red: 30, green: 136, blue: 190)
    }
    
    class func githubColor() -> UIColor {
        return UIColor(red: 83, green: 83, blue: 83)
    }
}
