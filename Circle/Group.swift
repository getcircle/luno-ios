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

typealias GetGroupCompletionHandler = (
    group: Services.Group.Containers.GroupV1?,
    error: NSError?
) -> Void

typealias GetGroupsCompletionHandler = (
    groups: Array<Services.Group.Containers.GroupV1>?,
    nextRequest: Soa.ServiceRequestV1?,
    error: NSError?
) -> Void

typealias JoinGroupCompletionHandler = (
    request: Services.Group.Containers.MembershipRequestV1?,
    error: NSError?
) -> Void

typealias LeaveGroupCompletionHandler = (
    error: NSError?
) -> Void

typealias RespondToMembershipRequestCompletionHandler = (
    error: NSError?
) -> Void

typealias AddMembersCompletionHandler = (
    newMembers: Array<Services.Group.Containers.MemberV1>?,
    error: NSError?
) -> Void

extension Services.Group.Actions {
    
    static func getGroup(groupId: String, completionHandler: GetGroupCompletionHandler?) {
        let requestBuilder = Services.Group.Actions.GetGroup.RequestV1.Builder()
        requestBuilder.groupId = groupId
        requestBuilder.provider = .Google
        
        let client = ServiceClient(serviceName: "group")
        client.callAction("get_group",
            extensionField: Services.Registry.Requests.Group.getGroup(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        ){
                (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Group.getGroup()
                ) as? Services.Group.Actions.GetGroup.ResponseV1
                wrapped?.getNextRequest()
                completionHandler?(group: response?.group, error: error)
        }
    }
    
    
    static func getMembers(
        groupId: String,
        role: Services.Group.Containers.RoleV1,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetGroupProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Group.Actions.GetMembers.RequestV1.Builder()
        requestBuilder.groupId = groupId
        requestBuilder.role = role
        requestBuilder.provider = .Google
        
        let client = ServiceClient(serviceName: "group")
        client.callAction("get_members",
            extensionField: Services.Registry.Requests.Group.getMembers(),
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
        ){
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Group.getMembers()
            ) as? Services.Group.Actions.GetMembers.ResponseV1
            let nextRequest = wrapped?.getNextRequest()
            completionHandler?(members: response?.members, nextRequest: nextRequest, error: error)
        }
    }
    
    static func getGroups(
        profileId: String?,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetGroupsCompletionHandler?
    ) {
    
        let requestBuilder = Services.Group.Actions.GetGroups.RequestV1.Builder()
        if let profileId = profileId {
            requestBuilder.profileId = profileId
        }
        requestBuilder.provider = .Google
        
        let client = ServiceClient(serviceName: "group")
        client.callAction("get_groups", extensionField: Services.Registry.Requests.Group.getGroups(), requestBuilder: requestBuilder, paginatorBuilder: paginatorBuilder) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Group.getGroups()
            ) as? Services.Group.Actions.GetGroups.ResponseV1
            let nextRequest = wrapped?.getNextRequest()
            completionHandler?(groups: response?.groups, nextRequest: nextRequest, error: error)
        }
    }
    
    static func joinGroup(
        groupId: String,
        completionHandler: JoinGroupCompletionHandler?
    ) {
        let requestBuilder = Services.Group.Actions.JoinGroup.RequestV1.Builder()
        requestBuilder.groupId = groupId
        requestBuilder.provider = .Google

        let client = ServiceClient(serviceName: "group")
        client.callAction("join_group",
            extensionField: Services.Registry.Requests.Group.joinGroup(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        ){
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Group.joinGroup()
            ) as? Services.Group.Actions.JoinGroup.ResponseV1
            completionHandler?(request: response?.request, error: error)
        }
    }

    static func leaveGroup(
        groupId: String,
        completionHandler: LeaveGroupCompletionHandler?
    ) {
        let requestBuilder = Services.Group.Actions.LeaveGroup.RequestV1.Builder()
        requestBuilder.groupId = groupId
        requestBuilder.provider = .Google
        
        let client = ServiceClient(serviceName: "group")
        client.callAction("leave_group",
            extensionField: Services.Registry.Requests.Group.leaveGroup(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        ){
            (_, _, wrapped, error) -> Void in
            wrapped?.response?.result.getExtension(Services.Registry.Responses.Group.leaveGroup())
            completionHandler?(error: error)
        }
    }
    
    static func respondToMembershipRequest(
        requestId: String,
        action: Services.Group.Actions.RespondToMembershipRequest.RequestV1.ResponseActionV1,
        completionHandler: RespondToMembershipRequestCompletionHandler?
        ) {
            let requestBuilder = Services.Group.Actions.RespondToMembershipRequest.RequestV1.Builder()
            requestBuilder.action = action
            requestBuilder.requestId = requestId
            
            let client = ServiceClient(serviceName: "group")
            client.callAction("respond_to_membership_request",
                extensionField: Services.Registry.Requests.Group.respondToMembershipRequest(),
                requestBuilder: requestBuilder,
                paginatorBuilder: nil
            ){
                (_, _, wrapped, error) -> Void in
                wrapped?.response?.result.getExtension(Services.Registry.Responses.Group.respondToMembershipRequest())
                completionHandler?(error: error)
            }
    }
    
    static func addMembers(
        groupId: String,
        profiles: Array<Services.Profile.Containers.ProfileV1>, 
        completionHandler: AddMembersCompletionHandler?
    ) {
        let requestBuilder = Services.Group.Actions.AddToGroup.RequestV1.Builder()
        requestBuilder.groupId = groupId
        requestBuilder.profileIds = profiles.map({ $0.id })
        requestBuilder.provider = .Google

        let client = ServiceClient(serviceName: "group")
        client.callAction("add_to_group",
            extensionField: Services.Registry.Requests.Group.addToGroup(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
            ){
                (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Group.addToGroup()
                ) as? Services.Group.Actions.AddToGroup.ResponseV1
                completionHandler?(newMembers: response?.newMembers, error: error)
        }
    }
}