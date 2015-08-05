//
//  Team.swift
//  Circle
//
//  Created by Ravi Rani on 6/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias UpdateTeamCompletionHandler = (team: Services.Organization.Containers.TeamV1?, error: NSError?) -> Void

extension Services.Organization.Actions {

    static func updateTeam(team: Services.Organization.Containers.TeamV1, completionHandler: UpdateTeamCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.UpdateTeam.RequestV1.builder()
        requestBuilder.team = team
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "update_team",
            extensionField: Services.Registry.Requests.Organization.updateTeam(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Organization.updateTeam()
                ) as? Services.Organization.Actions.UpdateTeam.ResponseV1
                completionHandler?(team: response?.team, error: error)
        }
    }
}

extension Services.Organization.Containers.TeamV1 {
    
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