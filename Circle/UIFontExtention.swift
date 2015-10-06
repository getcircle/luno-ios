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
        return UIFont.regularFont(17.0)
    }
    
    static func appVerificationCodeFieldFont() -> UIFont! {
        return lightFont(30.0)
    }
    
    static func appSocialCTATitleFont() -> UIFont {
        return regularFont(16.0)
    }
    
    static func appAttributeTitleLabelFont() -> UIFont {
        return semiboldFont(13.0)
    }

    static func appAttributeValueLabelFont() -> UIFont {
        return regularFont(16.0)
    }

    static func appModalTitleLabelFont() -> UIFont {
        return regularFont(14.0)
    }
    
    static func appOnboardingModalTitle() -> UIFont {
        return semiboldFont(20.0)
    }

    static func appOnboardingModalText() -> UIFont {
        return regularFont(16.0)
    }
    
    static func appOnboardingModalCTA() -> UIFont {
        return lightFont(20.0)
    }

    static func appTagTokenFont() -> UIFont {
        return regularFont(15.0)
    }
    
    static func appMessageFont() -> UIFont {
        return lightFont(16.0)
    }

    static func appSecondaryActionCTAFont() -> UIFont {
        return lightFont(18.0)
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
    
    static func italicFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "OpenSans-Italic", size: size)
    }
    
    static func boldFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "OpenSans-Bold", size: size)
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
