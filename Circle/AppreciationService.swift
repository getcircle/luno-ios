//
//  AppreciationService.swift
//  Circle
//
//  Created by Michael Hahn on 2/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias CreateAppreciationCompletionHandler = (appreciation: AppreciationService.Containers.Appreciation?, error: NSError?) -> Void
typealias DeleteAppreciationCompletionHandler = (error: NSError?) -> Void
typealias GetAppreciationCompletionHandler = (appreciation: Array<AppreciationService.Containers.Appreciation>?, error: NSError?) -> Void
typealias UpdateAppreciationCompletionHandler = (appreciation: AppreciationService.Containers.Appreciation?, error: NSError?) -> Void

extension AppreciationService {
    class Actions {
        
        class func createAppreciation(appreciation: AppreciationService.Containers.Appreciation, completionHandler: CreateAppreciationCompletionHandler?) {
            let requestBuilder = AppreciationService.CreateAppreciation.Request.builder()
            requestBuilder.appreciation = appreciation
            let client = ServiceClient(serviceName: "appreciation")
            client.callAction(
                "create_appreciation",
                extensionField: AppreciationServiceRequests_create_appreciation,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    AppreciationServiceRequests_create_appreciation
                ) as? AppreciationService.CreateAppreciation.Response
                completionHandler?(appreciation: response?.appreciation, error: error)
            }
        }
        
        class func deleteAppreciation(appreciation: AppreciationService.Containers.Appreciation, completionHandler: DeleteAppreciationCompletionHandler?) {
            let requestBuilder = AppreciationService.DeleteAppreciation.Request.builder()
            requestBuilder.appreciation = appreciation
            let client = ServiceClient(serviceName: "appreciation")
            client.callAction(
                "delete_appreciation",
                extensionField: AppreciationServiceRequests_delete_appreciation,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                completionHandler?(error: error)
                return
            }
        }
        
        class func updateAppreciation(appreciation: AppreciationService.Containers.Appreciation, completionHandler: UpdateAppreciationCompletionHandler?) {
            let requestBuilder = AppreciationService.UpdateAppreciation.Request.builder()
            requestBuilder.appreciation = appreciation
            let client = ServiceClient(serviceName: "appreciation")
            client.callAction(
                "update_appreciation",
                extensionField: AppreciationServiceRequests_update_appreciation,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    AppreciationServiceRequests_update_appreciation
                ) as? AppreciationService.UpdateAppreciation.Response
                completionHandler?(appreciation: appreciation, error: error)
            }
        }
        
        class func getAppreciation(forProfileId: String, completionHandler: GetAppreciationCompletionHandler?) {
            let requestBuilder = AppreciationService.GetAppreciation.Request.builder()
            requestBuilder.destination_profile_id = forProfileId
            let client = ServiceClient(serviceName: "appreciation")
            client.callAction(
                "get_appreciation",
                extensionField: AppreciationServiceRequests_get_appreciation,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    AppreciationServiceRequests_get_appreciation
                ) as? AppreciationService.GetAppreciation.Response
                completionHandler?(appreciation: response?.appreciation, error: error)
            }
        }
        
    }
}
