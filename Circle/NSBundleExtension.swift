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
}