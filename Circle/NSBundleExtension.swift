//
//  NSBundleExtension.swift
//  Circle
//
//  Created by Ravi Rani on 1/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

extension NSBundle {

    class func appName() -> String {
        if let bundleName: String = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String {
            return bundleName
        }
        
        return "circle"
    }
    
    class func appVersion() -> String {
        if let bundleVersion: String = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return bundleVersion
        }
        
        return "version"
    }
    
    class func appBuild() -> String {
        if let bundleBuild: String = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            return bundleBuild
        }
        
        return "build"
    }
}