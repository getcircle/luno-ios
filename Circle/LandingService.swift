//
//  LandingService.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetCategoriesCompletionHandler = (categories: Array<LandingService.Containers.Category>?, error: NSError?) -> Void
typealias GetOrganizationCategoriesCompletionHandler = (categories: Array<LandingService.Containers.Category>?, error: NSError?) -> Void

extension LandingService {
    class Actions {
        
        class func getCategories(profileId: String, completionHandler: GetCategoriesCompletionHandler?) {
            let requestBuilder = LandingService.GetCategories.Request.builder()
            requestBuilder.profile_id = profileId
            let client = ServiceClient(serviceName: "landing")
            client.callAction(
                "get_categories",
                extensionField: LandingServiceRequests_get_categories,
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    LandingServiceRequests_get_categories
                ) as? LandingService.GetCategories.Response
                completionHandler?(
                    categories: response?.categories,
                    error: error
                )
            }
        }
        
        class func getOrganizationCategories(organizationId: String, completionHandler: GetOrganizationCategoriesCompletionHandler?) {
            let requestBuilder = LandingService.GetOrganizationCategories.Request.builder()
            requestBuilder.organization_id = organizationId
            let client = ServiceClient(serviceName: "landing")
            client.callAction(
                "get_organization_categories",
                extensionField: LandingServiceRequests_get_organization_categories,
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    LandingServiceRequests_get_organization_categories
                ) as? LandingService.GetOrganizationCategories.Response
                completionHandler?(categories: response?.categories, error: error)
            }
        }
        
    }
}