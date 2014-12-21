//
//  ServiceTransport.swift
//  Circle
//
//  Created by Michael Hahn on 12/19/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import Alamofire
import ProtobufRegistry

protocol ServiceTransport {
    func sendRequest(serviceRequest: ServiceRequest, completionHandler: ServiceCompletionHandler);
    func processRequest(serviceRequest: ServiceRequest, serializedRequest: NSData, completionHandler: ServiceCompletionHandler);
}

extension Request {
    class func ServiceResponseSerializer() -> Serializer {
        return { (request, response, data) in
            if data == nil {
                return (nil, nil)
            }
            
            // TODO: Handle 0 bytes in data (network error)
            let serviceResponse = ServiceResponse.parseFromNSData(data!, extensionRegistry: ResponseRegistryRoot.sharedInstance.extensionRegistry)
            return (serviceResponse, nil)
        }
    }
    
    func responseProtobuf(completionHandler: ServiceCompletionHandler) -> Self {
        return response(serializer: Request.ServiceResponseSerializer(), completionHandler: { (request, response, serviceResponse, error) in
            let serviceResponse = serviceResponse as? ServiceResponse
            let actionResponse = serviceResponse?.actions[0]
            completionHandler(request, response, serviceResponse, actionResponse, error)
        })
    }
}

class BaseTransport: ServiceTransport {
    
    func sendRequest(serviceRequest: ServiceRequest, completionHandler: ServiceCompletionHandler) {
        let serializedRequest = serviceRequest.getNSData()
        processRequest(serviceRequest, serializedRequest: serializedRequest, completionHandler: completionHandler)
    }
    
    func processRequest(serviceRequest: ServiceRequest, serializedRequest: NSData, completionHandler: ServiceCompletionHandler) {
        assert(false, "Subclass must override `processRequest`")
    }
    
}

struct ServiceHttpRequest: URLRequestConvertible {
    
    static let baseURLString = "http://127.0.0.1:8000"
    var data: NSData
    
    init(data: NSData) {
        self.data = data
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: ServiceHttpRequest.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.setValue("application/x-protobuf", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        mutableURLRequest.HTTPBody = data
        return mutableURLRequest
    }
}

class HttpsTransport: BaseTransport {
    override func processRequest(serviceRequest: ServiceRequest, serializedRequest: NSData, completionHandler: ServiceCompletionHandler) {
        Alamofire.request(ServiceHttpRequest(data: serializedRequest))
            .responseProtobuf { (request, response, serviceResponse, actionResponse, error) -> Void in
                completionHandler(request, response, serviceResponse, actionResponse, error)
        }
    }
}