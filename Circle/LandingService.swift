//
//  LandingService.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetCategoriesCompletionHandler = (
    profileCategories: Array<LandingService.Containers.ProfileCategory>?,
    addressCategories: Array<LandingService.Containers.AddressCategory>?,
    error: NSError?
) -> Void

extension LandingService {
    class Actions {
        
        class func getCategories(profileId: String, completionHandler: GetCategoriesCompletionHandler) {
            let requestBuilder = LandingService.GetCategories.Request.builder()
            requestBuilder.profile_id = profileId
            let client = ServiceClient(serviceName: "landing")
            client.callAction(
                "get_categories",
                extensionField: LandingServiceRequests_get_categories,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    LandingServiceRequests_get_categories
                ) as? LandingService.GetCategories.Response
                completionHandler(
                    profileCategories: response?.profile_categories,
                    addressCategories: response?.address_categories,
                    error: nil
                )
            }
        }
        
    }
}