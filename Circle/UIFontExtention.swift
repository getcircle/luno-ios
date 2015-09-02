//
//  UIFontExtention.swift
//  Circle
//
//  Created by Ravi Rani on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIFont {
    
    // MARK: - v1
    
    static func navigationBarFont() -> UIFont! {
        return UIFont(name: "Avenir-Roman", size: 17.0)
    }
    
    static func appVerificationCodeFieldFont() -> UIFont! {
        return UIFont(name: "Avenir-Light", size: 30.0)
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
    
    // MARK: - v2

    static func lightFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "OpenSans-Light", size: size)
    }
    
    static func regularFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "OpenSans", size: size)!
    }
    
    static func semiboldFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
    
    static func headerTextFont() -> UIFont! {
        return semiboldFont(11.0)
    }
    
    static func mainTextFont() -> UIFont! {
        return regularFont(14.0)
    }
    
    static func secondaryTextFont() -> UIFont! {
        return regularFont(12.0)
    }
}
