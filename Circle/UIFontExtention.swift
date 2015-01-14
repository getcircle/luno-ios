//
//  UIFontExtention.swift
//  Circle
//
//  Created by Ravi Rani on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIFont {

    class func navigationBarFont() -> UIFont! {
        return UIFont(name: "Avenir-Roman", size: 17.0)
    }
    
    class func segmentedControlTitleFont() -> UIFont! {
        return UIFont(name: "Avenir-Roman", size: 14.0)
    }
    
    class func lightFont() -> UIFont! {
        return UIFont(name: "Avenir-Light", size: 17.0)
    }
    
    class func lightFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "Avenir-Light", size: size)
    }
}
