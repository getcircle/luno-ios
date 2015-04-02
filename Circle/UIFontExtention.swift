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
    
    class func appSegmentedControlTitleFont() -> UIFont! {
        return UIFont(name: "Avenir-Medium", size: 13.0)
    }
    
    class func lightFont() -> UIFont! {
        return UIFont(name: "Avenir-Light", size: 17.0)
    }
    
    class func lightFont(size: CGFloat) -> UIFont! {
        return UIFont(name: "Avenir-Light", size: size)
    }
    
    class func appSettingsCardHeader() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 12.0)!
    }

    class func appCTATitleFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 12.0)!
    }
    
    class func appSocialCTATitleFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 12.0)!
    }
    
    class func appTagsOverviewSectionHeader() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 15.0)!
    }
    
    class func appAttributeTitleLabelFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 13.0)!
    }

    class func appAttributeValueLabelFont() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 16.0)!
    }

    class func appModalTitleLabelFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 14.0)!
    }
    
    class func appOnboardingModalTitle() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 20.0)!
    }

    class func appOnboardingModalText() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 16.0)!
    }
    
    class func appOnboardingModalCTA() -> UIFont {
        return UIFont(name: "Avenir-Light", size: 20.0)!
    }

    class func appPrimaryTextFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 15.0)!
    }
    
    class func appSecondaryTextFont() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 13.0)!
    }
    
    class func appTagTokenFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 15.0)!
    }
}
