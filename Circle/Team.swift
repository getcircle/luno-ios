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
                ObjectStore.sharedInstance.update(response?.team, type: .Team)
                completionHandler?(team: response?.team, error: error)
        }
    }
}