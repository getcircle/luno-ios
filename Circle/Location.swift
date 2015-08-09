//
//  Location.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

struct LocationServiceNotifications {
    static let onLocationUpdatedNotification = "com.rhlabs.notification:onLocationUpdatedNotification"
}

typealias UpdateLocationCompletionHandler = (location: Services.Organization.Containers.LocationV1?, error: NSError?) -> Void

extension Services.Organization.Actions {

    static func updateLocation(
        location: Services.Organization.Containers.LocationV1,
        completionHandler: UpdateLocationCompletionHandler?
    ) {
            let requestBuilder = Services.Organization.Actions.UpdateLocation.RequestV1.builder()
            requestBuilder.location = location
            
            let client = ServiceClient(serviceName: "organization")
            client.callAction(
                "update_location",
                extensionField: Services.Registry.Requests.Organization.updateLocation(),
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Organization.updateLocation()
                ) as? Services.Organization.Actions.UpdateLocation.ResponseV1
                completionHandler?(location: response?.location, error: error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        LocationServiceNotifications.onLocationUpdatedNotification,
                        object: nil
                    )
                })
            }
    }
}