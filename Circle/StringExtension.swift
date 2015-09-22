//
//  StringExtension.swift
//  Circle
//
//  Created by Michael Hahn on 12/19/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation

extension String {
    
    public var camelcaseString: String {
        var camelCase = ""
        var needsUpperCase = false
        for character in self.characters {
            if character == "_" {
                needsUpperCase = true
                continue
            }
            
            if needsUpperCase {
                needsUpperCase = false
                camelCase += String(character).uppercaseString
                continue
            }
            
            camelCase += String(character)
        }
        return camelCase
    }

    subscript(integerIndex: Int) -> String {
        let index = startIndex.advancedBy(integerIndex)
        return String(self[index])
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = startIndex.advancedBy(integerRange.startIndex)
        let end = startIndex.advancedBy(integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
    
    func toDate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.dateFromString(self)
    }
        
    func trimWhitespace() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    /**
        Removes spaces, brances, hypens from a phone number string.
        Although this function can be called for all strings, the recommended use case is to call
        it on a formatted phone number.
    
        There is currently no validation that the final string is a valid phone number.
    
        - returns:
    */
    func removePhoneNumberFormatting() -> String {
        var phoneNumber = self.stringByReplacingOccurrencesOfString(" ", withString: "", options: .LiteralSearch, range: nil)
        phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("(", withString: "", options: .LiteralSearch, range: nil)
        phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(")", withString: "", options: .LiteralSearch, range: nil)
        phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "", options: .LiteralSearch, range: nil)
        return phoneNumber
    }
    
    func localizedUppercaseString() -> String {
        return uppercaseStringWithLocale(NSLocale.currentLocale())
    }
}
