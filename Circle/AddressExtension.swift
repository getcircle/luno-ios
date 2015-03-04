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
}