//
//  UIFontExtention.swift
//  Circle
//
//  Created by Ravi Rani on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIFont {

    static func navigationBarFont() -> UIFont! {
        return UIFont(name: "Avenir-Roman", size: 17.0)
    }
    
    static func lightFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "Avenir-Light", size: size)
    }
    
    static func appSocialCTATitleFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 12.0)!
    }
    
    static func appAttributeTitleLabelFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 13.0)!
    }

    static func appAttributeValueLabelFont() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 16.0)!
    }

    static func appModalTitleLabelFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 14.0)!
    }
    
    static func appOnboardingModalTitle() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 20.0)!
    }

    static func appOnboardingModalText() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 16.0)!
    }
    
    static func appOnboardingModalCTA() -> UIFont {
        return UIFont(name: "Avenir-Light", size: 20.0)!
    }

    static func appPrimaryTextFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 15.0)!
    }
    
    static func appSecondaryTextFont() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 13.0)!
    }
    
    static func appTagTokenFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 15.0)!
    }
    
    static func appMessageFont() -> UIFont {
        return UIFont(name: "Avenir-Light", size: 16.0)!
    }

    static func appSecondaryActionCTAFont() -> UIFont {
        return UIFont(name: "Avenir-Light", size: 18.0)!
    }
}
