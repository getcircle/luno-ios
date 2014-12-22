//
//  ServiceClient.swift
//  Circle
//
//  Created by Michael Hahn on 12/19/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry
import ProtocolBuffers

public typealias ServiceCompletionHandler = (NSURLRequest, NSHTTPURLResponse?, ServiceResponse?, ActionResponse?, NSError?) -> Void

public protocol ServiceRequestConvertible {
    var builder: GeneratedMessageBuilder { get }
    var actionName: String { get }
    var extensionField: ConcreateExtensionField { get }
}

public protocol ServiceResponseConvertible {
    var success: Bool { get }
    var result: GeneratedMessage { get }
}

public class ServiceClient {
    
    let serviceName: String
    var transport: ServiceTransport
    
    public var token: String?
    
    public init(serviceName: String, token: String?) {
        self.serviceName = serviceName
        self.transport = HttpsTransport()
        self.token = token
    }
    
    public func callAction(
        request: ServiceRequestConvertible,
        completionHandler: ServiceCompletionHandler
    ) {
        let message = request.builder.build()
        callAction(
            request.actionName,
            extensionField: request.extensionField,
            request: message,
            completionHandler: completionHandler
        )
    }
    
    public func callAction(
        actionName: String,
        extensionField: ConcreateExtensionField,
        request: AbstractMessage,
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
        actionControl.service = serviceName
        actionControl.action = actionName
        actionRequest.control = actionControl.build()
        
        let actionRequestParams = ActionRequestParams.builder()
        actionRequestParams.setExtension(extensionField, value: request)
        actionRequest.params = actionRequestParams.build()
        
        serviceRequest.actions += [actionRequest.build()]
        self.transport.sendRequest(serviceRequest.build(), completionHandler: completionHandler)
    }
    
}
