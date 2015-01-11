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
        for character in self {
            if character == "_" {
                needsUpperCase = true
                continue
            }
            
            if needsUpperCase {
                needsUpperCase = false
                var string = String(character)
                camelCase += String(character).uppercaseString
                continue
            }
            
            camelCase += String(character)
        }
        return camelCase
    }

    // http://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }
    
    func toDate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter.dateFromString(self)
    }
}