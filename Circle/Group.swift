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
    members: Array<Services.Group.Containers.MemberV1>?,
    nextRequest: Soa.ServiceRequestV1?, 
    error: NSError?
) -> Void

extension Services.Group.Actions {
    
    static func listMembers(
        groupId: String,
        role: Services.Group.Containers.RoleV1,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetGroupProfilesCompletionHandler?
    ) {
        
            // TODO: REMOVE WHEN BACKEND IS READY
            //===================================================================================
                completionHandler?(members: getFakeMembers(), nextRequest: nil, error: nil)
                return
            //===================================================================================
        
            let requestBuilder = Services.Group.Actions.ListMembers.RequestV1.builder()
            requestBuilder.groupId = groupId
            requestBuilder.role = role
            
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
                completionHandler?(members: response?.members, nextRequest: nextRequest, error: error)
            }
    }
    
    // TODO: REMOVE WHEN BACKEND IS READY
    private static func getFakeMembers() -> Array<Services.Group.Containers.MemberV1> {
        var members = Array<Services.Group.Containers.MemberV1>()
        for i in 0..<6 {
            let member = Services.Group.Containers.MemberV1.builder()
            let profile = Services.Profile.Containers.ProfileV1.builder()
            profile.id = "hello"
            profile.title = "Co-founder"
            profile.fullName = "Ravi Rani"
            profile.firstName = "Ravi"
            profile.lastName = "Rani"
            member.profile = profile.build()
            members.append(member.build())
        }
        return members
    }
}