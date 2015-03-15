//
//  AddressExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension OrganizationService.Containers.Address {

    func shortOfficeAddress() -> String {
        var address = address_1
        
        if hasAddress2 {
            address += ", " + address_2
        }
        
        address = address.trimWhitespace()
        address = address.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
        return address
    }
    
    func cityRegionPostalCode() -> String {
        var address = city
        if hasRegion {
            address += ", " + region
        }
        
        if hasPostalCode {
            address += " " + postal_code
        }
        
        return address
    }
    
    func fullAddress() -> String {
        var address = shortOfficeAddress()
        address += ",\n" + city
        if hasRegion {
            address += ", " + region
        }
        
        address += ", " + country_code
        if hasPostalCode {
            address += " " + postal_code
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
        if NSBundle.mainBundle().preferredLocalizations[0] as String == "en" {
            currentDateString += dateSuffixForDate(currentDate)
        }
        return currentDateString
    }
    
    func officeCurrentTimeLabel(date: NSDate?) -> String {
        var currentDate = date ?? NSDate()
        let officeTimeZone = NSTimeZone(name: timezone)!
        NSDateFormatter.sharedOfficeCurrentTimeFormatter.timeZone = officeTimeZone
        return NSDateFormatter.sharedOfficeCurrentTimeFormatter.stringFromDate(currentDate)
    }
    
    func officeDaylightIndicator() -> UIImage? {
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        calendar?.timeZone = NSTimeZone(name: timezone)!
        let components = calendar?.components(NSCalendarUnit.CalendarUnitHour, fromDate: NSDate())
        var image: UIImage?
        if components?.hour >= 18 {
            image = UIImage(named: "Moon")
        } else {
            image = UIImage(named: "Sun")
        }
        return image
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