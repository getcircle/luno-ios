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
let AttributionsURL = "http://www.circlehq.co/attributions.html"
let PrivacyPolicyURL = "http://www.circlehq.co/privacy.html"
let TermsURL = "http://www.circlehq.co/terms.html"

public struct WrappedResponse {
    
    var serviceRequest: Soa.ServiceRequestV1
    var serviceResponse: Soa.ServiceResponseV1?
    var response: Soa.ActionResponseV1?
    
    init(serviceRequest withServiceRequest: Soa.ServiceRequestV1, serviceResponse withServiceResponse: Soa.ServiceResponseV1?, actionResponse: Soa.ActionResponseV1?) {
        serviceRequest = withServiceRequest
        serviceResponse = withServiceResponse
        response = actionResponse
    }
    
    func getNextRequest() -> Soa.ServiceRequestV1? {
        var nextRequest: Soa.ServiceRequestV1? = nil
        if let paginator = getPaginator() where paginator.hasNextPage {
            nextRequest = serviceRequest.getNextRequest(paginator)
        }
        return nextRequest
    }
    
    func getPaginator() -> Soa.PaginatorV1? {
        return response?.control.paginator
    }
    
}

protocol ServiceTransport {
    func sendRequest(serviceRequest: Soa.ServiceRequestV1, completionHandler: ServiceCompletionHandler);
    func processRequest(serviceRequest: Soa.ServiceRequestV1, serializedRequest: NSData, completionHandler: ServiceCompletionHandler);
}

public typealias ServiceTransportCompletionHandler = (NSURLRequest, NSHTTPURLResponse?, Soa.ServiceResponseV1?, Soa.ActionResponseV1?, NSError?) -> Void

extension Request {
    static func ServiceResponseSerializer() -> Serializer {
        return { (request, response, data) in
            if data == nil {
                return (nil, nil)
            }
            
            if data!.length == 0 {
                return (nil, nil)
            }
            
            if response?.statusCode != 200 {
                // println("error making service request: \(response?)")
                if response?.statusCode == 401 {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        AuthViewController.logOut()
                    })
                }
                return (nil, nil)
            }
            
            let serviceResponse = Soa.ServiceResponseV1.parseFromData(
                data!,
                extensionRegistry: Services.Registry.Responses.ResponsesRoot.sharedInstance.extensionRegistry
            )
            return (serviceResponse, nil)
        }
    }
    
    func responseProtobuf(completionHandler: ServiceTransportCompletionHandler) -> Self {
        return response(serializer: Request.ServiceResponseSerializer(), completionHandler: { (request, response, serviceResponse, error) in
            let serviceResponse = serviceResponse as? Soa.ServiceResponseV1
            let actionResponse = serviceResponse?.actions[0]
            var serviceError = error
            if serviceError == nil {
                if let result = actionResponse?.result {
                    if !result.success {
                        let userInfo = [
                            "errors": result.errors,
                            "error_details": result.errorDetails,
                        ]
                        serviceError = NSError(domain: ServiceErrorDomain, code: -1, userInfo: userInfo as [NSObject : AnyObject])
                    }
                }
            }

            completionHandler(request, response, serviceResponse, actionResponse, serviceError)
        })
    }
}

class BaseTransport: ServiceTransport {
    
    func sendRequest(serviceRequest: Soa.ServiceRequestV1, completionHandler: ServiceCompletionHandler) {
        let serializedRequest = serviceRequest.data()
        processRequest(serviceRequest, serializedRequest: serializedRequest, completionHandler: completionHandler)
    }
    
    func processRequest(serviceRequest: Soa.ServiceRequestV1, serializedRequest: NSData, completionHandler: ServiceCompletionHandler) {
        assert(false, "Subclass must override `processRequest`")
    }
    
}

struct ServiceHttpRequest: URLRequestConvertible {
    
    enum Environment {
        case Local
        case Staging
        case Production
        
        var scheme: String {
            switch self {
            case .Local: return "http"
            default: return "https"
            }
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
    
    static let environment = Environment.Production
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
        mutableURLRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
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
    
    override func processRequest(serviceRequest: Soa.ServiceRequestV1, serializedRequest: NSData, completionHandler: ServiceCompletionHandler) {
        let startTime = CACurrentMediaTime()
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
                let endTime = CACurrentMediaTime()
                // println("\(serviceRequest.control.service):\(serviceRequest.actions[0].control.action): Time - \(endTime - startTime)")
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
