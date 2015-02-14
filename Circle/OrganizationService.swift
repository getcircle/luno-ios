//
//  OrganizationService.swift
//  Circle
//
//  Created by Michael Hahn on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetAddressesCompletionHandler = (addresses: Array<OrganizationService.Containers.Address>?, error: NSError?) -> Void
typealias GetTeamsCompletionHandler = (teams: Array<OrganizationService.Containers.Team>?, error: NSError?) -> Void
typealias GetTeamChildrenCompletionHandler = (teams: Array<OrganizationService.Containers.Team>?, error: NSError?) -> Void
typealias GetOrganizationCompletionHandler = (organization: OrganizationService.Containers.Organization?, error: NSError?) -> Void

extension OrganizationService {
    class Actions {
        
        class func getAddresses(organizationId: String, completionHandler: GetAddressesCompletionHandler?) {
            let requestBuilder = OrganizationService.GetAddresses.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_addresses",
                extensionField: OrganizationServiceRequests_get_addresses,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    OrganizationServiceRequests_get_addresses
                ) as? OrganizationService.GetAddresses.Response
                completionHandler?(addresses: response?.addresses, error: error)
            }
        }
        
        class func getTeams(organizationId: String, completionHandler: GetTeamsCompletionHandler?) {
            let requestBuilder = OrganizationService.GetTeams.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_teams",
                extensionField: OrganizationServiceRequests_get_teams,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    OrganizationServiceRequests_get_teams
                ) as? OrganizationService.GetTeams.Response
                completionHandler?(teams: response?.teams, error: error)
            }
        }
        
        class func getTeamChildren(teamId: String, completionHandler: GetTeamChildrenCompletionHandler?) {
            let requestBuilder = OrganizationService.GetTeamChildren.Request.builder()
            requestBuilder.team_id = teamId
            
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_team_children",
                extensionField: OrganizationServiceRequests_get_team_children,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        OrganizationServiceRequests_get_team_children
                    ) as? OrganizationService.GetTeamChildren.Response
                    completionHandler?(teams: response?.teams, error: error)
            }
        }
        
        class func getOrganization(organizationId: String, completionHandler: GetOrganizationCompletionHandler?) {
            let requestBuilder = OrganizationService.GetOrganization.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_organization",
                extensionField: OrganizationServiceRequests_get_organization,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        OrganizationServiceRequests_get_organization
                    ) as? OrganizationService.GetOrganization.Response
                    completionHandler?(organization: response?.organization, error: error)
            }
        }
    }
}
