//
//  SearchAction.swift
//  Circle
//
//  Created by Ravi Rani on 8/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class SearchAction: SearchSuggestion {
    
    enum Type: Int {
        case EmailPerson = 1
        case CallPerson
        case MessagePerson
        case ReportsToPerson
        
        case AddressOfOffice
        case LocalTimeAtOffice
        case ContactsOfOffice
        case PeopleInOffice
        
        case MembersOfTeam
    }
    
    var type: Type
    var underlyingObject: AnyObject?

    init(title: String, ofType: Type, withImageSource: String) {
        type = ofType
        super.init(title: title, imageSource: withImageSource)
    }
    
    static func searchActionsForProfile(profile: Services.Profile.Containers.ProfileV1) -> [SearchAction] {
        var searchActions = [SearchAction]()
        
        // Email
        let emailAction = SearchAction(
            title: "Email " + profile.firstName,
            ofType: .EmailPerson,
            withImageSource: "Email"
        )
        emailAction.underlyingObject = profile as AnyObject
        searchActions.append(emailAction)

        // Message
        let messageAction = SearchAction(
            title: "Message " + profile.firstName,
            ofType: .MessagePerson,
            withImageSource: "Sms"
        )
        messageAction.underlyingObject = profile as AnyObject
        searchActions.append(messageAction)

        // Call Action
        let callAction = SearchAction(
            title: "Call " + profile.firstName,
            ofType: .CallPerson,
            withImageSource: "Call"
        )
        callAction.underlyingObject = profile as AnyObject
        searchActions.append(callAction)

        // Reports To Action
        // TODO: Only show for managers
        let reportsToAction = SearchAction(
            title: "Reports to " + profile.firstName,
            ofType: .ReportsToPerson,
            withImageSource: "SearchTab"
        )
        reportsToAction.underlyingObject = profile as AnyObject
        searchActions.append(reportsToAction)
        return searchActions
    }
    
    static func searchActionsForLocation(location: Services.Organization.Containers.LocationV1) -> [SearchAction] {
        var searchActions = [SearchAction]()
        
        // Address action
        let addressAction = SearchAction(
            title: "Address of " + location.name,
            ofType: .AddressOfOffice,
            withImageSource: "Compass"
        )
        addressAction.underlyingObject = location as AnyObject
        searchActions.append(addressAction)
        
        // Local time
        let timeAction = SearchAction(
            title: "Local Time is " + location.officeCurrentTimeLabel(nil, addDifferenceText: true),
            ofType: .LocalTimeAtOffice,
            withImageSource: "Info"
        )
        timeAction.underlyingObject = location as AnyObject
        searchActions.append(timeAction)

        // People
        let peopleAction = SearchAction(
            title: "People in " + location.name + " Office",
            ofType: .PeopleInOffice,
            withImageSource: "SearchTab"
        )
        peopleAction.underlyingObject = location as AnyObject
        searchActions.append(peopleAction)
        
        return searchActions
    }
}