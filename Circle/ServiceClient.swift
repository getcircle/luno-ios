//
//  ServiceClient.swift
//  Circle
//
//  Created by Michael Hahn on 12/19/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

public typealias ServiceCompletionHandler = (NSURLRequest, NSHTTPURLResponse?, WrappedResponse?, NSError?) -> Void

public class ServiceClient {
    
    let serviceName: String
    var transport: ServiceTransport
    
    public var token: String?
    
    convenience init(serviceName: String) {
        self.init(
            serviceName: serviceName,
            token: AuthenticationViewController.getLoggedInUserToken()
        )
    }
    
    public init(serviceName: String, token: String?) {
        self.serviceName = serviceName
        self.transport = HttpsTransport()
        self.token = token
    }
    
    public func buildRequest(
        actionName: String,
        extensionField: ConcreateExtensionField,
        requestBuilder: AbstractMessageBuilder,
        paginatorBuilder: Soa.PaginatorV1.Builder?
    ) throws -> Soa.ServiceRequestV1? {
        let serviceRequest = Soa.ServiceRequestV1.Builder()
        let control = Soa.ControlV1.Builder()
        control.service = serviceName
        if let token = token {
            control.token = token
        }
        serviceRequest.control = try control.build()
        
        let actionRequest = Soa.ActionRequestV1.Builder()
        let actionControl = Soa.ActionControlV1.Builder()
        var paginatorBuilder = paginatorBuilder
        if paginatorBuilder == nil {
            paginatorBuilder = Soa.PaginatorV1.Builder()
        }
        actionControl.service = serviceName
        actionControl.action = actionName
        actionControl.paginator = try paginatorBuilder!.build()
        actionRequest.control = try actionControl.build()
        
        let actionRequestParams = Soa.ActionRequestParamsV1.Builder()
        try actionRequestParams.setExtension(extensionField, value: try requestBuilder.build())
        actionRequest.params = try actionRequestParams.build()
        serviceRequest.actions += [try actionRequest.build()]
        return try serviceRequest.build()
    }
    
    public func callAction(
        actionName: String,
        extensionField: ConcreateExtensionField,
        requestBuilder: AbstractMessageBuilder,
        completionHandler: ServiceCompletionHandler
    ) {
        callAction(
            actionName,
            extensionField: extensionField,
            requestBuilder: requestBuilder,
            paginatorBuilder: nil,
            completionHandler: completionHandler
        )
    }
    
    public func callAction(
        actionName: String,
        extensionField: ConcreateExtensionField,
        requestBuilder: AbstractMessageBuilder,
        paginatorBuilder: Soa.PaginatorV1.Builder?,
        completionHandler: ServiceCompletionHandler
    ) {
        do {
            if let serviceRequest = try buildRequest(
                actionName,
                extensionField: extensionField,
                requestBuilder: requestBuilder,
                paginatorBuilder: paginatorBuilder
                ) {
                    transport.sendRequest(serviceRequest, completionHandler: completionHandler)
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    public static func sendRequest(serviceRequest: Soa.ServiceRequestV1, completionHandler: ServiceCompletionHandler) {
        let client = ServiceClient(serviceName: "")
        client.transport.sendRequest(serviceRequest, completionHandler: completionHandler)
    }
    
}
