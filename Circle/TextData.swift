//
//  TextData.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class TextData {
    
    enum TextDataType {
        case LocationDescription
        case ProfileStatus
        case TeamDescription
        case TeamStatus
    }
    
    private(set) var value: String
    private(set) var editProfileId: String?
    private(set) var editedTimestamp: String?
    private(set) var type: TextDataType
    var placeholder: String?
    private(set) var updatedTimestamp: String?

    init(type withType: TextDataType, andValue: String, andPlaceholder: String? = nil, andTimestamp: String? = nil) {
        type = withType
        value = andValue
        placeholder = andPlaceholder
        updatedTimestamp = andTimestamp
    }
    
    func getFormattedTimestamp() -> String? {
        if let timestamp = updatedTimestamp where timestamp.trimWhitespace() != "" {
            var formattedTimestamp = "\u{2013} "

            let today = NSDate()
            if let updatedDate = NSDateFormatter.dateFromTimestampString(timestamp),
                calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
                let unitFlags = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
                let diffComponents = calendar.components(
                    unitFlags,
                    fromDate: updatedDate, 
                    toDate: today, 
                    options: nil
                )
                
                if diffComponents.day > 0 {
                    formattedTimestamp += String(diffComponents.day) + "d "
                }
                
                if diffComponents.hour > 0 {
                    formattedTimestamp += String(diffComponents.hour) + "h "
                }
                else if diffComponents.day == 0 {
                    formattedTimestamp += String(diffComponents.minute) + "m "
                }
                
                return formattedTimestamp + "ago"
            }
        }
        
        return nil
    }
}