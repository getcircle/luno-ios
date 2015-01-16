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
    }
}
