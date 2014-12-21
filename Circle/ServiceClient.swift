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

public class ServiceClient {
    
    let serviceName: String
    var transport: ServiceTransport
    
    public init(serviceName: String) {
        self.serviceName = serviceName
        self.transport = HttpsTransport()
    }
    
    public func callAction(
        actionName: String,
        extensionField: ConcreateExtensionField,
        request: GeneratedMessage,
        completionHandler: ServiceCompletionHandler
    ) {
        let serviceRequest = ServiceRequest.builder()
        let control = Control.builder()
        control.service = serviceName
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
