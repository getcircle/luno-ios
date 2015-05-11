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

typealias GetGroupsCompletionHandler = (
    groups: Array<Services.Group.Containers.GroupV1>?,
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
        let requestBuilder = Services.Group.Actions.ListMembers.RequestV1.builder()
        requestBuilder.groupId = groupId
        requestBuilder.role = role
        requestBuilder.provider = .Google
        
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
    
    static func listGroups(
        profileId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetGroupsCompletionHandler?
    ) {
    
        let requestBuilder = Services.Group.Actions.ListGroups.RequestV1.builder()
        requestBuilder.profileId = profileId
        requestBuilder.provider = .Google
        
        let client = ServiceClient(serviceName: "group")
        client.callAction("list_groups", extensionField: Services.Registry.Requests.Group.listGroups(), requestBuilder: requestBuilder, paginatorBuilder: paginatorBuilder) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Group.listGroups()
            ) as? Services.Group.Actions.ListGroups.ResponseV1
            let nextRequest = wrapped?.getNextRequest()
            completionHandler?(groups: response?.groups, nextRequest: nextRequest, error: error)
        }
    }
}