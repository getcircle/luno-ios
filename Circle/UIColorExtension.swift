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
}
