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

    static func updateTeam(team: Services.Organization.Containers.TeamV1, completionHandler: UpdateProfileCompletionHandler?) {
//        let requestBuilder = Services.Organization.Actions.UpdateTeam.RequestV1.builder()
//        requestBuilder.team = team
//        
//        let client = ServiceClient(serviceName: "organization")
//        client.callAction(
//            "update_team",
//            extensionField: Services.Registry.Requests.Profile.updateProfile(),
//            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
//                let response = wrapped?.response?.result.getExtension(
//                    Services.Registry.Responses.Profile.updateProfile()
//                    ) as? Services.Profile.Actions.UpdateProfile.ResponseV1
//                ObjectStore.sharedInstance.update(response?.profile, type: .Profile)
//                completionHandler?(profile: response?.profile, error: error)
//                // DWM - Discuss with Michael
//                // TODO: Either check for no errors or pass than along in the userInfo
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    NSNotificationCenter.defaultCenter().postNotificationName(
//                        ProfileServiceNotifications.onProfileUpdatedNotification,
//                        object: nil
//                    )
//                })
//        }
    }
}