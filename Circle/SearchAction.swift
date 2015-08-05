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
        case TeamsInOffice
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
            title: "Email " + profile.fullName,
            ofType: .EmailPerson,
            withImageSource: "Email"
        )
        emailAction.underlyingObject = profile as AnyObject
        searchActions.append(emailAction)

        // Message
        let messageAction = SearchAction(
            title: "Message " + profile.fullName,
            ofType: .MessagePerson,
            withImageSource: "Sms"
        )
        messageAction.underlyingObject = profile as AnyObject
        searchActions.append(messageAction)

        // Call Action
        let callAction = SearchAction(
            title: "Call " + profile.fullName,
            ofType: .CallPerson,
            withImageSource: "Call"
        )
        callAction.underlyingObject = profile as AnyObject
        searchActions.append(callAction)

        // Reports To Action
        // TODO: Only show for managers
        let reportsToAction = SearchAction(
            title: "Reports to " + profile.fullName,
            ofType: .ReportsToPerson,
            withImageSource: "SearchTab"
        )
        reportsToAction.underlyingObject = profile as AnyObject
        searchActions.append(reportsToAction)
        return searchActions
    }
}