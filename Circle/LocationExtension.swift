//
//  AddressExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

extension Services.Organization.Containers.LocationV1 {

    func shortLocationsAddress() -> String {
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
        var address = shortLocationsAddress()
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
        return "Local Time: " + officeCurrentDateLabel() + ", " + officeCurrentTimeLabel()
    }
    
    func officeCurrentDateLabel() -> String {
        var currentDate = NSDate()
        var currentDateString = ""
        if let officeTimeZone = NSTimeZone(name: timezone) {
            // Convert date to the time zone the office is in.
            if officeTimeZone != NSTimeZone.localTimeZone() {
                currentDate = currentDate.dateByAddingTimeInterval(
                    Double(officeTimeZone.secondsFromGMTForDate(currentDate))
                )
            }
            currentDateString = NSDateFormatter.localizedRelativeDateString(NSDate())
        }
        return currentDateString
    }
    
    func officeCurrentTimeLabel(addDifferenceText: Bool? = false) -> String {
        let currentDate = NSDate()
        let officeTimeZone = NSTimeZone(name: timezone)!
        NSDateFormatter.sharedLocationsCurrentTimeFormatter.timeZone = officeTimeZone
        var currentTime = NSDateFormatter.sharedLocationsCurrentTimeFormatter.stringFromDate(currentDate)
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
}
