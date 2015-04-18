//
//  Feed.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetCategoriesCompletionHandler = (categories: Array<Services.Feed.Containers.CategoryV1>?, error: NSError?) -> Void
typealias GetOrganizationCategoriesCompletionHandler = (categories: Array<Services.Feed.Containers.CategoryV1>?, error: NSError?) -> Void

extension Services.Feed.Actions {
        
    class func getCategories(profileId: String, completionHandler: GetCategoriesCompletionHandler?) {
        let requestBuilder = Services.Feed.Actions.GetCategories.RequestV1.builder()
        requestBuilder.profileId = profileId
        let client = ServiceClient(serviceName: "feed")
        client.callAction(
            "get_categories",
            extensionField: Services.Registry.Requests.Feed.getProfileFeed(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Feed.getProfileFeed()
            ) as? Services.Feed.Actions.GetCategories.ResponseV1
            completionHandler?(
                categories: response?.categories,
                error: error
            )
        }
    }
    
    class func getOrganizationCategories(organizationId: String, completionHandler: GetOrganizationCategoriesCompletionHandler?) {
        let requestBuilder = Services.Feed.Actions.GetOrganizationCategories.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        let client = ServiceClient(serviceName: "feed")
        client.callAction(
            "get_organization_categories",
            extensionField: Services.Registry.Requests.Feed.getOrganizationFeed(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Feed.getOrganizationFeed()
            ) as? Services.Feed.Actions.GetOrganizationCategories.ResponseV1
            completionHandler?(categories: response?.categories, error: error)
        }
    }
    
}
