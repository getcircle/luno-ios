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

let ServiceErrorDomain = "co.circlehq.circle.services"

public struct WrappedResponse {
    
    var serviceRequest: ServiceRequest
    var serviceResponse: ServiceResponse?
    var response: ActionResponse?
    
    init(serviceRequest withServiceRequest: ServiceRequest, serviceResponse withServiceResponse: ServiceResponse?, actionResponse: ActionResponse?) {
        serviceRequest = withServiceRequest
        serviceResponse = withServiceResponse
        response = actionResponse
    }
    
    func getPaginator() -> Paginator? {
        return response?.control.paginator
    }
    
}

protocol ServiceTransport {
    func sendRequest(serviceRequest: ServiceRequest, completionHandler: ServiceCompletionHandler);
    func processRequest(serviceRequest: ServiceRequest, serializedRequest: NSData, completionHandler: ServiceCompletionHandler);
}

public typealias ServiceTransportCompletionHandler = (NSURLRequest, NSHTTPURLResponse?, ServiceResponse?, ActionResponse?, NSError?) -> Void

extension Request {
    class func ServiceResponseSerializer() -> Serializer {
        return { (request, response, data) in
            if data == nil {
                return (nil, nil)
            }
            
            if data!.length == 0 {
                return (nil, nil)
            }
            
            if response?.statusCode != 200 {
                println("error making service request: \(response?)")
                return (nil, nil)
            }
            
            let serviceResponse = ServiceResponse.parseFromNSData(data!, extensionRegistry: ResponseRegistryRoot.sharedInstance.extensionRegistry)
            return (serviceResponse, nil)
        }
    }
    
    func responseProtobuf(completionHandler: ServiceTransportCompletionHandler) -> Self {
        return response(serializer: Request.ServiceResponseSerializer(), completionHandler: { (request, response, serviceResponse, error) in
            let serviceResponse = serviceResponse as? ServiceResponse
            let actionResponse = serviceResponse?.actions[0]
            var serviceError = error
            if serviceError == nil {
                if let result = actionResponse?.result {
                    if !result.success {
                        let userInfo = [
                            "errors": result.errors,
                            "error_details": result.error_details,
                        ]
                        serviceError = NSError(domain: ServiceErrorDomain, code: -1, userInfo: userInfo)
                    }
                }
            }

            completionHandler(request, response, serviceResponse, actionResponse, serviceError)
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
    
    enum Environment {
        case Local
        case Staging
        case Production
        
        var scheme: String {
            return "https"
        }
        
        var host: String {
            switch self {
            case .Local: return "localhost"
            case .Staging: return "api.circlehq.co"
            case .Production: return "api.circlehq.co"
            }
        }
        
        var serviceEndpoint: NSURL {
            var url = "\(scheme)://\(host)"
            switch self {
            case .Local:
                url = "\(url):8000"
            default:
                break
            }
            return NSURL(string: url)!
        }
        
        var name: String {
            switch self {
            case .Local: return "local"
            case .Staging: return "staging"
            case .Production: return "production"
            }
        }
    }
    
    static let environment = Environment.Staging
//    static let environment = Environment.Local
    
    var data: NSData
    var token: String?
    
    init(data withData: NSData, token withToken: String?) {
        data = withData
        token = withToken
    }
    
    var URLRequest: NSURLRequest {
        let mutableURLRequest = NSMutableURLRequest(URL: ServiceHttpRequest.environment.serviceEndpoint)
        mutableURLRequest.setValue("application/x-protobuf", forHTTPHeaderField: "Content-Type")
        if token != "" {
            mutableURLRequest.setValue("Token \(token!)", forHTTPHeaderField: "Authorization")
        }
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        mutableURLRequest.HTTPBody = data
        return mutableURLRequest
    }
}

class HttpsTransport: BaseTransport {
    private struct NetworkActivity {
        static var totalRequests = 0
    }
    
    override func processRequest(serviceRequest: ServiceRequest, serializedRequest: NSData, completionHandler: ServiceCompletionHandler) {
        NetworkActivity.totalRequests++
        updateNetworkIndicatorVisibility()
        
        Alamofire.request(ServiceHttpRequest(data: serializedRequest, token: serviceRequest.control.token))
            .responseProtobuf { (request, response, serviceResponse, actionResponse, error) -> Void in
                NetworkActivity.totalRequests--
                self.updateNetworkIndicatorVisibility()
                let wrapped = WrappedResponse(
                    serviceRequest: serviceRequest,
                    serviceResponse: serviceResponse,
                    actionResponse: actionResponse
                )
                completionHandler(request, response, wrapped, error)
        }
    }
    
    private func updateNetworkIndicatorVisibility() {
        if NetworkActivity.totalRequests > 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}
