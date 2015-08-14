//
//  AddressExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Services.Organization.Containers.LocationV1 {

    func shortOfficeAddress() -> String {
        var address = address1
        
        if hasAddress2 {
            address += ", " + address2
        }
        
        address = address.trimWhitespace()
        address = address.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
        return address
    }
    
    func cityRegion() -> String {
        var address = city
        if hasRegion {
            address += ", " + region
        }

        return address
    }

    func cityRegionPostalCode() -> String {
        var address = city
        if hasRegion {
            address += ", " + region
        }
        
        if hasPostalCode {
            address += " " + postalCode
        }
        
        return address
    }
    
    func fullAddress() -> String {
        var address = shortOfficeAddress()
        address += ",\n" + city
        if hasRegion {
            address += ", " + region
        }
        
        address += ", " + countryCode
        if hasPostalCode {
            address += " " + postalCode
        }

        return address
    }
    
    func officeName() -> String {
        var officeName = name
        if officeName.trimWhitespace() == "" {
            officeName = city + ", " + region
        }
        
        return officeName
    }
    
    func officeCurrentDateAndTimeLabel() -> String {
        let currentDate = NSDate()
        return officeCurrentDateLabel(currentDate) + " " + officeCurrentTimeLabel(currentDate)
    }
    
    func officeCurrentDateLabel(date: NSDate?) -> String {
        var currentDate = date ?? NSDate()
        var currentDateString: String
        let officeTimeZone = NSTimeZone(name: timezone)!
        NSDateFormatter.sharedOfficeCurrentDateFormatter.timeZone = officeTimeZone
        currentDateString = NSDateFormatter.sharedOfficeCurrentDateFormatter.stringFromDate(currentDate)
        if NSBundle.mainBundle().preferredLocalizations[0] as! String == "en" {
            currentDateString += dateSuffixForDate(currentDate)
        }
        return currentDateString
    }
    
    func officeCurrentTimeLabel(date: NSDate?, addDifferenceText: Bool? = false) -> String {
        var currentDate = date ?? NSDate()
        let officeTimeZone = NSTimeZone(name: timezone)!
        NSDateFormatter.sharedOfficeCurrentTimeFormatter.timeZone = officeTimeZone
        var currentTime = NSDateFormatter.sharedOfficeCurrentTimeFormatter.stringFromDate(currentDate)
        if let addText = addDifferenceText where addText {
            let sourceSeconds = NSTimeZone.systemTimeZone().secondsFromGMTForDate(currentDate)
            let destinationSeconds = officeTimeZone.secondsFromGMTForDate(currentDate)
            let hoursDifference = (destinationSeconds - sourceSeconds)/3600
            
            if hoursDifference > 0 {
                if hoursDifference == 1 {
                    currentTime += " (1 hour ahead)"
                }
                else {
                    currentTime += " (" + String(hoursDifference) + " hours ahead)"
                }
            }
            else if hoursDifference < 0 {
                if hoursDifference == -1 {
                    currentTime += " (1 hour behind)"
                }
                else {
                    currentTime += " (" + String((-1 * hoursDifference)) + " hours behind)"
                }
            }
        }
        
        return currentTime
    }
    
    func officeDaylightIndicator() -> UIImage? {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar?.timeZone = NSTimeZone(name: timezone)!
        let components = calendar?.components(NSCalendarUnit.CalendarUnitHour, fromDate: NSDate())
        var image: UIImage?
        if components?.hour >= 18 || components?.hour < 6 {
            image = UIImage(named: "Moon")
        } else {
            image = UIImage(named: "Sun")
        }

        return image?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    func dateSuffixForDate(date: NSDate) -> String {
        let dayOfMonth = NSCalendar.currentCalendar().componentsInTimeZone(NSTimeZone(name: timezone)!, fromDate: date).day
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }

}
