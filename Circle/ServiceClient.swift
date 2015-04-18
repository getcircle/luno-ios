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
            token: AuthViewController.getLoggedInUserToken()
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
        paginatorBuilder: Soa.PaginatorV1Builder?
    ) -> Soa.ServiceRequestV1 {
        let serviceRequest = Soa.ServiceRequestV1.builder()
        let control = Control.builder()
        control.service = serviceName
        if let token = token {
            control.token = token
        }
        serviceRequest.control = control.build()
        
        let actionRequest = ActionRequest.builder()
        let actionControl = ActionControl.builder()
        var paginatorBuilder = paginatorBuilder
        if paginatorBuilder == nil {
            paginatorBuilder = Soa.PaginatorV1.builder()
        }
        actionControl.service = serviceName
        actionControl.action = actionName
        actionControl.paginator = paginatorBuilder!.build()
        actionRequest.control = actionControl.build()
        
        let actionRequestParams = ActionRequestParams.builder()
        actionRequestParams.setExtension(extensionField, value: requestBuilder.build())
        actionRequest.params = actionRequestParams.build()
        serviceRequest.actions += [actionRequest.build()]
        return serviceRequest.build()
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
        paginatorBuilder: Soa.PaginatorV1Builder?,
        completionHandler: ServiceCompletionHandler
    ) {
        let serviceRequest = buildRequest(
            actionName,
            extensionField: extensionField,
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
        )
        transport.sendRequest(serviceRequest, completionHandler: completionHandler)
    }
    
    public class func sendRequest(serviceRequest: Soa.ServiceRequestV1, completionHandler: ServiceCompletionHandler) {
        let client = ServiceClient(serviceName: "")
        client.transport.sendRequest(serviceRequest, completionHandler: completionHandler)
    }
    
}
