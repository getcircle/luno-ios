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
    
    class var sharedTimestampFormatter: NSDateFormatter {
        struct Static {
            static let instance = dateFormatter
            static var dateFormatter: NSDateFormatter {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                return dateFormatter
            }
        }
        
        return Static.instance
    }

    class var sharedBirthdayFormatter: NSDateFormatter {
        struct Static {
            static let instance = dateFormatter
            static var dateFormatter: NSDateFormatter {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMMM d"
                dateFormatter.locale = NSLocale.currentLocale()
                return dateFormatter
            }
        }
        
        return Static.instance
    }

    class var sharedAnniversaryFormatter: NSDateFormatter {
        struct Static {
            static let instance = dateFormatter
            static var dateFormatter: NSDateFormatter {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMMM YYYY"
                dateFormatter.locale = NSLocale.currentLocale()
                return dateFormatter
            }
        }
        
        return Static.instance
    }
    
    class var sharedRelativeDateFormatter: NSDateFormatter {
        struct Static {
            static let instance = dateFormatter
            static var dateFormatter: NSDateFormatter {
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                return dateFormatter
            }
        }
        
        return Static.instance
    }
    
    class var sharedOfficeCurrentDateFormatter: NSDateFormatter {
        struct Static {
            static let instance = dateFormatter
            static var dateFormatter: NSDateFormatter {
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.dateFormat = "EEEE, MMMM d"
                return dateFormatter
            }
        }

        return Static.instance
    }
    
    class var sharedOfficeCurrentTimeFormatter: NSDateFormatter {
        struct Static {
            static let instance = dateFormatter
            static var dateFormatter: NSDateFormatter {
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.dateFormat = "h:mm a zzz"
                return dateFormatter
            }
        }
        return Static.instance
    }
    
    class func stringFromDateWithStyles(
        date: NSDate,
        dateStyle: NSDateFormatterStyle,
        timeStyle: NSDateFormatterStyle
    ) -> String {
        self.sharedInstance.dateStyle = dateStyle
        self.sharedInstance.timeStyle = timeStyle
        return self.sharedInstance.stringFromDate(date)
    }
    
    class func shortStyleStringFromDate(date: NSDate) -> String {
        self.sharedInstance.dateStyle = .ShortStyle
        return self.sharedInstance.stringFromDate(date)
    }
    
    class func dateFromTimestampString(timestamp: String) -> NSDate? {
        let dateFormatter = NSDateFormatter.sharedTimestampFormatter
        return dateFormatter.dateFromString(timestamp)
    }
    
    class func localizedRelativeDateString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter.sharedRelativeDateFormatter
        if NSCalendar.currentCalendar().isDateInToday(date) {
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = .NoStyle
        }
        else {
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.dateStyle = .ShortStyle
        }

        return dateFormatter.stringFromDate(date)
    }
}
