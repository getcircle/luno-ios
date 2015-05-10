//
//  Group.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetGroupProfilesCompletionHandler = (
    adminProfiles: Array<Services.Profile.Containers.ProfileV1>?, 
    profiles: Array<Services.Profile.Containers.ProfileV1>?, 
    nextRequest: Soa.ServiceRequestV1?, 
    error: NSError?
) -> Void

extension Services.Group.Actions {
    
    static func listMembers(
        groupId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetGroupProfilesCompletionHandler?
    ) {
            let requestBuilder = Services.Group.Actions.ListMembers.RequestV1.builder()
            requestBuilder.groupId = groupId
            
            let client = ServiceClient(serviceName: "group")
            client.callAction("list_members",
                extensionField: Services.Registry.Requests.Group.listMembers(),
                requestBuilder: requestBuilder,
                paginatorBuilder: paginatorBuilder
            ){
                (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Group.listMembers()
                ) as? Services.Group.Actions.ListMembers.ResponseV1
                let nextRequest = wrapped?.getNextRequest()
                // completionHandler!(profiles: response?.profiles, nextRequest: nextRequest, error: error)
            }
    }
}

