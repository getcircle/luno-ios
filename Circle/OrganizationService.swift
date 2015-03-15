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
typealias GetTeamsCompletionHandler = (teams: Array<OrganizationService.Containers.Team>?, nextRequest: ServiceRequest?, error: NSError?) -> Void
typealias GetTeamDescendantsCompletionHandler = (teams: Array<OrganizationService.Containers.Team>?, error: NSError?) -> Void
typealias GetOrganizationCompletionHandler = (organization: OrganizationService.Containers.Organization?, error: NSError?) -> Void
typealias GetLocationsCompletionHandler = (locations: Array<OrganizationService.Containers.Location>?, error: NSError?) -> Void

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
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    OrganizationServiceRequests_get_addresses
                ) as? OrganizationService.GetAddresses.Response
                completionHandler?(addresses: response?.addresses, error: error)
            }
        }
        
        class func getTeams(
            requestBuilder: OrganizationService.GetTeams.RequestBuilder,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetTeamsCompletionHandler?
        ) {
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_teams",
                extensionField: OrganizationServiceRequests_get_teams,
                requestBuilder: requestBuilder,
                paginatorBuilder: paginatorBuilder
                ) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        OrganizationServiceRequests_get_teams
                        ) as? OrganizationService.GetTeams.Response
                    let nextRequest = wrapped?.getNextRequest()
                    completionHandler?(teams: response?.teams, nextRequest: nextRequest, error: error)
            }
        }
        
        class func getTeams(
            organizationId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetTeamsCompletionHandler?
        ) {
            let requestBuilder = OrganizationService.GetTeams.Request.builder()
            requestBuilder.organization_id = organizationId
            self.getTeams(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
        }
        
        class func getTeams(
            #locationId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetTeamsCompletionHandler?
        ) {
            let requestBuilder = OrganizationService.GetTeams.Request.builder()
            requestBuilder.location_id = locationId
            self.getTeams(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
        }
        
        class func getTeamDescendants(
            teamId: String,
            depth: UInt32? = nil,
            attributes: [String]? = nil,
            completionHandler: GetTeamDescendantsCompletionHandler?
        ) {
            let requestBuilder = OrganizationService.GetTeamDescendants.Request.builder()
            requestBuilder.team_id = teamId
            if depth != nil {
                requestBuilder.depth = depth!
            }
            if attributes != nil {
                requestBuilder.attributes.extend(attributes!)
            }
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_team_descendants",
                extensionField: OrganizationServiceRequests_get_team_descendants,
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    OrganizationServiceRequests_get_team_descendants
                ) as? OrganizationService.GetTeamDescendants.Response
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
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        OrganizationServiceRequests_get_organization
                    ) as? OrganizationService.GetOrganization.Response
                    completionHandler?(organization: response?.organization, error: error)
            }
        }
        
        class func getLocations(organizationId: String, completionHandler: GetLocationsCompletionHandler?) {
            let requestBuilder = OrganizationService.GetLocations.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "get_locations",
                extensionField: OrganizationServiceRequests_get_locations,
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    OrganizationServiceRequests_get_locations
                ) as? OrganizationService.GetLocations.Response
                completionHandler?(locations: response?.locations, error: error)
            }
        }
        
    }
}
