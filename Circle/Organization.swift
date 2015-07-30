//
//  Organization.swift
//  Circle
//
//  Created by Michael Hahn on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetAddressesCompletionHandler = (addresses: Array<Services.Organization.Containers.AddressV1>?, error: NSError?) -> Void

typealias GetTeamsCompletionHandler = (teams: Array<Services.Organization.Containers.TeamV1>?, nextRequest: Soa.ServiceRequestV1?, error: NSError?) -> Void

typealias GetTeamDescendantsCompletionHandler = (teams: Array<Services.Organization.Containers.TeamV1>?, error: NSError?) -> Void

typealias GetOrganizationCompletionHandler = (organization: Services.Organization.Containers.OrganizationV1?, error: NSError?) -> Void

typealias GetLocationsCompletionHandler = (locations: Array<Services.Organization.Containers.LocationV1>?, error: NSError?) -> Void

typealias GetLocationCompletionHandler = (location: Services.Organization.Containers.LocationV1?, error: NSError?) -> Void

typealias GetIntegrationStatusCompletionHandler = (status: Bool, error: NSError?) -> Void

extension Services.Organization.Actions {
        
    static func getAddresses(organizationId: String, completionHandler: GetAddressesCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetAddresses.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_addresses",
            extensionField: Services.Registry.Requests.Organization.getAddresses(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.getAddresses()
            ) as? Services.Organization.Actions.GetAddresses.ResponseV1
            completionHandler?(addresses: response?.addresses, error: error)
        }
    }
    
    static func getTeams(
        requestBuilder: Services.Organization.Actions.GetTeams.RequestV1Builder,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetTeamsCompletionHandler?
    ) {
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_teams",
            extensionField: Services.Registry.Requests.Organization.getTeams(),
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Organization.getTeams()
                ) as? Services.Organization.Actions.GetTeams.ResponseV1
                let nextRequest = wrapped?.getNextRequest()
                completionHandler?(teams: response?.teams, nextRequest: nextRequest, error: error)
        }
    }
    
    static func getTeams(
        organizationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetTeamsCompletionHandler?
    ) {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        self.getTeams(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getTeams(
        #locationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetTeamsCompletionHandler?
    ) {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.builder()
        requestBuilder.locationId = locationId
        self.getTeams(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getTeamDescendants(
        teamId: String,
        depth: UInt32? = nil,
        attributes: [String]? = nil,
        completionHandler: GetTeamDescendantsCompletionHandler?
    ) {
        let requestBuilder = Services.Organization.Actions.GetTeamDescendants.RequestV1.builder()
        requestBuilder.teamIds = [teamId]
        if depth != nil {
            requestBuilder.depth = depth!
        }
        if attributes != nil {
            requestBuilder.attributes.extend(attributes!)
        }
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_team_descendants",
            extensionField: Services.Registry.Requests.Organization.getTeamDescendants(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.getTeamDescendants()
            ) as? Services.Organization.Actions.GetTeamDescendants.ResponseV1
            completionHandler?(teams: response?.descendants[0].teams, error: error)
        }
    }
    
    static func getOrganization(organizationId: String, completionHandler: GetOrganizationCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetOrganization.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_organization",
            extensionField: Services.Registry.Requests.Organization.getOrganization(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Organization.getOrganization()
                ) as? Services.Organization.Actions.GetOrganization.ResponseV1
                completionHandler?(organization: response?.organization, error: error)
        }
    }

    static func getLocation(#locationId: String, completionHandler: GetLocationCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetLocation.RequestV1.builder()
        requestBuilder.locationId = locationId
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_location",
            extensionField: Services.Registry.Requests.Organization.getLocation(),
            requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Organization.getLocation()
                ) as? Services.Organization.Actions.GetLocation.ResponseV1
                completionHandler?(location: response?.location, error: error)
        }
    }

    static func getLocations(organizationId: String, completionHandler: GetLocationsCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetLocations.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_locations",
            extensionField: Services.Registry.Requests.Organization.getLocations(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.getLocations()
            ) as? Services.Organization.Actions.GetLocations.ResponseV1
            completionHandler?(locations: response?.locations, error: error)
        }
    }
    
    static func getIntegrationStatus(type: Services.Organization.Containers.Integration.IntegrationTypeV1, completionHandler: GetIntegrationStatusCompletionHandler?) {
        
        if let integrationStatus = CircleCache.getIntegrationSetting(type) {
            completionHandler?(status: integrationStatus, error: nil)
            return
        }
        
        let requestBuilder = Services.Organization.Actions.GetIntegration.RequestV1.builder()
        requestBuilder.integrationType = type

        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_integration",
            extensionField: Services.Registry.Requests.Organization.getIntegration(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.getIntegration()
            ) as? Services.Organization.Actions.GetIntegration.ResponseV1
            
            var status = false
            if let response = response, integration = response.integration {
                status = true
            }

            CircleCache.setIntegrationSetting(status, ofType: type)
            completionHandler?(status: status, error: error)
        }
    }
}
