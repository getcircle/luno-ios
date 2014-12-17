//
//  NSDateFormatterExtension.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    
    class var sharedInstance: NSDateFormatter {
        struct Static {
            static let instance = NSDateFormatter()
        }
        return Static.instance
    }
    
    class func shortStyleStringFromDate(date: NSDate) -> String {
        self.sharedInstance.dateStyle = .ShortStyle
        return self.sharedInstance.stringFromDate(date)
    }

}