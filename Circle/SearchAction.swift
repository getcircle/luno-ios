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
        
        case AddressOfLocation
        case LocalTimeAtLocation
        case ContactsOfLocation
        case PeopleInLocation
        
        case MembersOfTeam
        case SubTeamsOfTeam
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
            withImageSource: "detail_email"
        )
        emailAction.underlyingObject = profile as AnyObject
        searchActions.append(emailAction)

        // Message
        let messageAction = SearchAction(
            title: "Message " + profile.firstName,
            ofType: .MessagePerson,
            withImageSource: "detail_chat"
        )
        messageAction.underlyingObject = profile as AnyObject
        searchActions.append(messageAction)

        // Call Action
        let callAction = SearchAction(
            title: "Call " + profile.firstName,
            ofType: .CallPerson,
            withImageSource: "detail_phone"
        )
        callAction.underlyingObject = profile as AnyObject
        searchActions.append(callAction)

        // Reports To Action
        // TODO: Only show for managers
        //        let reportsToAction = SearchAction(
        //            title: "Reports to " + profile.firstName,
        //            ofType: .ReportsToPerson,
        //            withImageSource: "results_search"
        //        )
        //        reportsToAction.underlyingObject = profile as AnyObject
        //        searchActions.append(reportsToAction)
        return searchActions
    }

    static func searchActionsForTeam(team: Services.Organization.Containers.TeamV1) -> [SearchAction] {
        var searchActions = [SearchAction]()
        
        // Members of Team
        let membersAction = SearchAction(
            title: "Works in " + team.name,
            ofType: .MembersOfTeam,
            withImageSource: "SearchTab"
        )
        membersAction.underlyingObject = team as AnyObject
        searchActions.append(membersAction)
        
        if team.childTeamCount > 0 {
            // Sub teams of Team
            let subTeamsAction = SearchAction(
                title: "Teams in " + team.name,
                ofType: .SubTeamsOfTeam,
                withImageSource: "SearchTab"
            )
            subTeamsAction.underlyingObject = team as AnyObject
            searchActions.append(subTeamsAction)
        }
        
        return searchActions
    }

    static func searchActionsForLocation(location: Services.Organization.Containers.LocationV1) -> [SearchAction] {
        var searchActions = [SearchAction]()
        
        // Address action
        let addressAction = SearchAction(
            title: "Address of " + location.name,
            ofType: .AddressOfLocation,
            withImageSource: "Compass"
        )
        addressAction.underlyingObject = location as AnyObject
        searchActions.append(addressAction)
        
        // Local time
        let timeAction = SearchAction(
            title: "Local Time is " + location.officeCurrentTimeLabel(true),
            ofType: .LocalTimeAtLocation,
            withImageSource: "Info"
        )
        timeAction.underlyingObject = location as AnyObject
        searchActions.append(timeAction)

        // People
        let peopleAction = SearchAction(
            title: "People in " + location.name + " Office",
            ofType: .PeopleInLocation,
            withImageSource: "SearchTab"
        )
        peopleAction.underlyingObject = location as AnyObject
        searchActions.append(peopleAction)
        
        return searchActions
    }
}