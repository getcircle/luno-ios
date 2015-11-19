//
//  TextData.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class TextData {
    
    enum TextDataType {
        case LocationDescription
        case TeamDescription
    }
    
    var placeholder: String?

    private(set) var authorProfile: Services.Profile.Containers.ProfileV1?
    private(set) var canEdit: Bool?
    private(set) var editProfileId: String?
    private(set) var editedTimestamp: String?
    private(set) var type: TextDataType
    private(set) var value: String
    private(set) var updatedTimestamp: String?

    init(type withType: TextDataType,
        andValue: String, 
        andPlaceholder: String? = nil, 
        andTimestamp: String? = nil,
        andAuthor: Services.Profile.Containers.ProfileV1? = nil,
        andCanEdit: Bool? = false
    ) {
        authorProfile = andAuthor
        canEdit = andCanEdit
        type = withType
        value = andValue
        updatedTimestamp = andTimestamp
        if let canEdit = canEdit where canEdit == true {
            placeholder = getEditablePlaceholder(withType)
        } else {
            placeholder = andPlaceholder
        }
    }
    
    static func getFormattedTimestamp(timestamp: String?, authorProfile: Services.Profile.Containers.ProfileV1? = nil, addHyphen: Bool = true) -> String? {
        if let statusTimestamp = timestamp where statusTimestamp.trimWhitespace() != "" {
            var formattedTimestamp = (addHyphen ? " \u{2013} " : "")

            let today = NSDate()
            if let updatedDate = NSDateFormatter.dateFromTimestampString(statusTimestamp),
                calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            {
                let unitFlags: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute]
                let diffComponents = calendar.components(
                    unitFlags,
                    fromDate: updatedDate,
                    toDate: today,
                    options: []
                )
                
                if diffComponents.day > 0 {
                    formattedTimestamp += String(diffComponents.day) + "d "
                }
                
                if diffComponents.hour > 0 {
                    formattedTimestamp += String(diffComponents.hour) + "h "
                }
                else if diffComponents.day == 0 {
                    let minuteString = diffComponents.minute == 0 ? "<1" : String(diffComponents.minute)
                    formattedTimestamp += minuteString + "m "
                }
                formattedTimestamp += "ago"

                if let author = authorProfile {
                    formattedTimestamp += " by " + author.fullName
                }

                return formattedTimestamp
            }
        }
        
        return nil
    }
    
    private func getEditablePlaceholder(type: TextDataType) -> String {
        switch type {
        case .TeamDescription:
            return AppStrings.AddTeamDescriptionPlaceholder
            
        default:
            return AppStrings.AddDetailsPlaceholder
        }
    }
}