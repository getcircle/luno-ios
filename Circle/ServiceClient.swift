//
//  ServiceClient.swift
//  Circle
//
//  Created by Michael Hahn on 12/19/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

public typealias ServiceCompletionHandler = (NSURLRequest, NSHTTPURLResponse?, ServiceResponse?, ActionResponse?, NSError?) -> Void

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
        paginatorBuilder: PaginatorBuilder?,
        completionHandler: ServiceCompletionHandler
    ) {
        let serviceRequest = ServiceRequest.builder()
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
            paginatorBuilder = Paginator.builder()
        }
        actionControl.service = serviceName
        actionControl.action = actionName
        actionControl.paginator = paginatorBuilder!.build()
        actionRequest.control = actionControl.build()
        
        let actionRequestParams = ActionRequestParams.builder()
        actionRequestParams.setExtension(extensionField, value: requestBuilder.build())
        actionRequest.params = actionRequestParams.build()
        
        serviceRequest.actions += [actionRequest.build()]
        self.transport.sendRequest(serviceRequest.build(), completionHandler: completionHandler)
    }
    
}
