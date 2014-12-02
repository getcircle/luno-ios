//
//  UIColorExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
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
        return UIColor(red: 225/255.0, green: 40/255.0, blue: 47/255.0, alpha: 1.0)
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
        return UIColor.whiteColor()
    }
    
    class func twitterColor() -> UIColor {
        return UIColor(red: 85, green: 172, blue: 238)
    }

    class func facebookColor() -> UIColor {
        return UIColor(red: 45, green: 68, blue: 134)
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
}
