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

    subscript(integerIndex: Int) -> String {
        let index = advance(startIndex, integerIndex)
        return String(self[index])
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = advance(startIndex, integerRange.startIndex)
        let end = advance(startIndex, integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
    
    func toDate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter.dateFromString(self)
    }
    
    func trimWhitespace() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}