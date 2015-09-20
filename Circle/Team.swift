//
//  Team.swift
//  Circle
//
//  Created by Ravi Rani on 6/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

struct TeamServiceNotifications {
    static let onTeamUpdatedNotification = "com.rhlabs.notification:onTeamUpdatedNotification"
}

typealias GetTeamCompletionHandler = (team: Services.Organization.Containers.TeamV1?, error: NSError?) -> Void
typealias UpdateTeamCompletionHandler = (team: Services.Organization.Containers.TeamV1?, error: NSError?) -> Void

extension Services.Organization.Actions {

    static func getTeam(teamId: String, completionHandler: GetTeamCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetTeam.RequestV1.Builder()
        requestBuilder.teamId = teamId
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_team",
            extensionField: Services.Registry.Requests.Organization.getTeam(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.getTeam()
            ) as? Services.Organization.Actions.GetTeam.ResponseV1
            completionHandler?(team: response?.team, error: error)
        }
    }
    
    static func updateTeam(team: Services.Organization.Containers.TeamV1, completionHandler: UpdateTeamCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.UpdateTeam.RequestV1.Builder()
        requestBuilder.team = team
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "update_team",
            extensionField: Services.Registry.Requests.Organization.updateTeam(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.updateTeam()
            ) as? Services.Organization.Actions.UpdateTeam.ResponseV1
            completionHandler?(team: response?.team, error: error)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(
                    TeamServiceNotifications.onTeamUpdatedNotification,
                    object: nil
                )
            })
        }
    }
}

extension Services.Organization.Containers.TeamV1 {
    
    public func getName() -> String {
        if count(name) > 0 {
            return name
        }
        else if count(displayName) > 0 {
            return displayName
        }
        else if let manager = manager where count(manager.firstName) > 0 {
            return manager.firstName + "'s Nameless Team"
        }
        else {
            return "Nameless Team"
        }
    }
    
    public func getTeamCounts() -> String {
        var teamCountsString = ""
        
        if childTeamCount > 0 {
            if childTeamCount == 1 {
                teamCountsString += "1 Team"
            }
            else {
                teamCountsString += String(childTeamCount) + " Teams"
            }
            
            teamCountsString += ", "
        }
        if profileCount == 1 {
            teamCountsString += "1 Person"
        }
        else {
            teamCountsString += String(profileCount) + " People"
        }
        
        return teamCountsString
    }
}