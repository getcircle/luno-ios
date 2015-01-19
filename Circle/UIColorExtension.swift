//
//  UIColorExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed   = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue  = CGFloat(Double(blue) / 255.0)
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
    }
    
    class func appTintColor() -> UIColor {
        return UIColor(red: 225, green: 40, blue: 47)
    }
    
    class func defaultLightTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func defaultDarkTextColor() -> UIColor {
        return UIColor(red: 51, green: 51, blue: 51)
    }
    
    class func navigationBarBarTintColor() -> UIColor {
        return UIColor.appTintColor()
    }

    class func navigationBarTintColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func navigationBarTitleColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func tabBarTintColor() -> UIColor {
        return UIColor(red: 49, green: 45, blue: 41)
    }
    
    class func accessoryButtonBackgroundColor() -> UIColor {
        return UIColor(red: 240, green: 240, blue: 240)
    }
    
    class func separatorViewColor() -> UIColor {
        return UIColor(red: 222, green: 222, blue: 222)
    }
    
    class func viewBackgroundColor() -> UIColor {
        return UIColor(red: 240, green: 240, blue: 240)
    }
    
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

    class func emailTintColor() -> UIColor {
        return UIColor(red: 83, green: 83, blue: 83)
    }
    
    class func phoneTintColor() -> UIColor {
        return UIColor(red: 83, green: 83, blue: 83)
    }
    
    class func linkedinColor() -> UIColor {
        return UIColor(red: 45, green: 68, blue: 134)
    }
    
    class func githubColor() -> UIColor {
        return UIColor(red: 83, green: 83, blue: 83)
    }
    
    class func searchTextFieldBackground() -> UIColor {
        return UIColor(red: 220, green: 220, blue: 220)
    }
    
    class func searchOverlayButtonBackgroundColor() -> UIColor {
        return UIColor.viewBackgroundColor()
    }
    
    class func tagNormalBackgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func tagSelectedBackgroundColor() -> UIColor {
        return UIColor.appTintColor()
    }

    class func tagNormalBorderColor() -> UIColor {
        return UIColor(red: 180, green: 180, blue: 180)
    }
    
    class func tagSelectedBorderColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func actionSheetControlsTintColor() -> UIColor {
        return UIColor(red: 85, green: 85, blue: 94)
    }
    
    class func controlHighlightedColor() -> UIColor {
        return UIColor(red: 206, green: 206, blue: 206).colorWithAlphaComponent(0.5)
    }
    
    class func teamHeaderBackgroundColor() -> UIColor {
        let palette = [
            UIColor(red: 17, green: 36, blue: 65),
            UIColor(red: 65, green: 20, blue: 20),
            UIColor(red: 70, green: 33, blue: 18),
            UIColor(red: 37, green: 37, blue: 37),
            UIColor(red: 20, green: 50, blue: 21),
            UIColor(red: 44, green: 25, blue: 49)
        ]
        
        return palette[Int(arc4random()) % Int(palette.count)]
    }
}
