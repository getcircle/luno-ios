//
//  Appreciation.swift
//  Circle
//
//  Created by Michael Hahn on 2/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias CreateAppreciationCompletionHandler = (appreciation: Services.Appreciation.Containers.AppreciationV1?, error: NSError?) -> Void
typealias DeleteAppreciationCompletionHandler = (error: NSError?) -> Void
typealias GetAppreciationCompletionHandler = (appreciation: Array<Services.Appreciation.Containers.AppreciationV1>?, error: NSError?) -> Void
typealias UpdateAppreciationCompletionHandler = (appreciation: Services.Appreciation.Containers.AppreciationV1?, error: NSError?) -> Void

extension Services.Appreciation.Actions {
        
    class func createAppreciation(appreciation: Services.Appreciation.Containers.AppreciationV1, completionHandler: CreateAppreciationCompletionHandler?) {
        let requestBuilder = Services.Appreciation.Actions.CreateAppreciation.RequestV1.builder()
        requestBuilder.appreciation = appreciation
        let client = ServiceClient(serviceName: "appreciation")
        client.callAction(
            "create_appreciation",
            extensionField: Services.Registry.Requests.Appreciation.createAppreciation(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Appreciation.createAppreciation()
            ) as? Services.Appreciation.Actions.CreateAppreciation.ResponseV1
            completionHandler?(appreciation: response?.appreciation, error: error)
        }
    }
    
    class func deleteAppreciation(appreciation: Services.Appreciation.Containers.AppreciationV1, completionHandler: DeleteAppreciationCompletionHandler?) {
        let requestBuilder = Services.Appreciation.Actions.DeleteAppreciation.RequestV1.builder()
        requestBuilder.appreciation = appreciation
        let client = ServiceClient(serviceName: "appreciation")
        client.callAction(
            "delete_appreciation",
            extensionField: Services.Registry.Requests.Appreciation.deleteAppreciation(),
            requestBuilder: requestBuilder
        ) { (_, _, _, error) -> Void in
            completionHandler?(error: error)
            return
        }
    }
    
    class func updateAppreciation(appreciation: Services.Appreciation.Containers.AppreciationV1, completionHandler: UpdateAppreciationCompletionHandler?) {
        let requestBuilder = Services.Appreciation.Actions.UpdateAppreciation.RequestV1.builder()
        requestBuilder.appreciation = appreciation
        let client = ServiceClient(serviceName: "appreciation")
        client.callAction(
            "update_appreciation",
            extensionField: Services.Registry.Requests.Appreciation.updateAppreciation(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Appreciation.updateAppreciation()
            ) as? Services.Appreciation.Actions.UpdateAppreciation.ResponseV1
            completionHandler?(appreciation: appreciation, error: error)
        }
    }
    
    class func getAppreciation(forProfileId: String, completionHandler: GetAppreciationCompletionHandler?) {
        let requestBuilder = Services.Appreciation.Actions.GetAppreciation.RequestV1.builder()
        requestBuilder.destination_profileId = forProfileId
        let client = ServiceClient(serviceName: "appreciation")
        client.callAction(
            "get_appreciation",
            extensionField: Services.Registry.Requests.Appreciation.getAppreciation(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Appreciation.getAppreciation()
            ) as? Services.Appreciation.Actions.GetAppreciation.ResponseV1
            completionHandler?(appreciation: response?.appreciation, error: error)
        }
    }
        
}
