//
//  Organization.swift
//  Circle
//
//  Created by Michael Hahn on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetTeamsCompletionHandler = (teams: Array<Services.Organization.Containers.TeamV1>?, nextRequest: Soa.ServiceRequestV1?, error: NSError?) -> Void
typealias GetOrganizationCompletionHandler = (organization: Services.Organization.Containers.OrganizationV1?, error: NSError?) -> Void
typealias GetLocationsCompletionHandler = (locations: Array<Services.Organization.Containers.LocationV1>?, error: NSError?) -> Void
typealias GetLocationCompletionHandler = (location: Services.Organization.Containers.LocationV1?, error: NSError?) -> Void
typealias GetIntegrationStatusCompletionHandler = (status: Bool, error: NSError?) -> Void
typealias GetTeamReportingDetailsCompletionHandler = (
    members: Array<Services.Profile.Containers.ProfileV1>?,
    childTeams: Array<Services.Organization.Containers.TeamV1>?,
    manager: Services.Profile.Containers.ProfileV1?,
    error: NSError?
) -> Void

extension Services.Organization.Actions {
    
    static func getTeams(
        organizationId: String,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetTeamsCompletionHandler?
    ) {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.Builder()
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
    
    static func getOrganization(completionHandler: GetOrganizationCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetOrganization.RequestV1.Builder()
        
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

    static func getLocation(locationId locationId: String, completionHandler: GetLocationCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetLocation.RequestV1.Builder()
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

    static func getLocations(completionHandler: GetLocationsCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetLocations.RequestV1.Builder()
        
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
    
    static func getTeamReportingDetails(teamId: String, completionHandler: GetTeamReportingDetailsCompletionHandler?) {
        let requestBuilder = Services.Organization.Actions.GetTeamReportingDetails.RequestV1.Builder()
        requestBuilder.teamId = teamId
        
        let client = ServiceClient(serviceName: "organization")
        client.callAction(
            "get_team_reporting_details",
            extensionField: Services.Registry.Requests.Organization.getTeamReportingDetails(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Organization.getTeamReportingDetails()
            ) as? Services.Organization.Actions.GetTeamReportingDetails.ResponseV1
            completionHandler?(members: response?.members, childTeams: response?.childTeams, manager: response?.manager, error: error)
        }
    }
}
