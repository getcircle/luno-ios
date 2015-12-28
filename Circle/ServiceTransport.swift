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

let ServiceErrorDomain = "com.lunohq.luno.services"

let AttributionsURL = "http://www.lunohq.com/attributions.html"
let PrivacyPolicyURL = "http://www.lunohq.com/privacy.html"
let TermsURL = "http://www.lunohq.com/terms.html"

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
            do {
                nextRequest = try serviceRequest.getNextRequest(paginator)
            }
            catch {
                print("Error: \(error)")
            }
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
    static func ServiceResponseSerializer() -> GenericResponseSerializer<Soa.ServiceResponseV1> {
        return GenericResponseSerializer { (request, response, data) in
            if data == nil {
                let failureReason = "Data could not be serialized. Input data was nil."
                return .Failure(data, Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason))
            }
            
            if data!.length == 0 {
                let failureReason = "Data could not be serialized. Input data had length = 0."
                return .Failure(data, Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason))
            }
            
            if response?.statusCode != 200 {
                // print("error making service request: \(response?)")
                if response?.statusCode == 401 {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        AuthenticationViewController.logOut()
                    })
                }
                
                let failureReason = "Status code validation failed. Got status code: \(response?.statusCode)"
                return .Failure(data, Error.errorWithCode(.StatusCodeValidationFailed, failureReason: failureReason))
            }
            
            do {
                let serviceResponse = try Soa.ServiceResponseV1.parseFromData(
                    data!,
                    extensionRegistry: Services.Registry.Responses.ResponsesRoot.sharedInstance.extensionRegistry
                )
                return .Success(serviceResponse)
            }
            catch {
                return .Failure(data, Error.errorWithCode(.DataSerializationFailed, failureReason: "\(error)"))
            }
        }
    }
    
    func responseProtobuf(completionHandler: ServiceTransportCompletionHandler) -> Self {
        return response(responseSerializer: Request.ServiceResponseSerializer(), completionHandler: { (request, response, result) in
            var serviceResponse: Soa.ServiceResponseV1?
            var serviceError: NSError?
            
            if case .Success(let response) = result {
                serviceResponse = response
            }
            else if case .Failure(_, let error) = result {
                serviceError = error as NSError
            }
            
            let actionResponse = serviceResponse?.actions[0]
            if serviceError == nil {
                if let result = actionResponse?.result {
                    if !result.success {
                        let userInfo = [
                            "errors": result.errors,
                            "error_details": result.errorDetails,
                        ]
                        serviceError = NSError(domain: ServiceErrorDomain, code: -1, userInfo: userInfo as? [NSObject : AnyObject])
                    }
                }
            }

            completionHandler(request!, response, serviceResponse, actionResponse, serviceError)
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
        case Dev
        case Local
        case Staging
        case Production
        
        var scheme: String {
            switch self {
            case .Local, .Dev: return "http"
            default: return "https"
            }
        }
        
        var host: String {
            switch self {
            case .Dev: return "api.dev.lunohq.com"
            case .Local: return "api.local.lunohq.com"
            case .Staging: return "api.lunohq.com"
            case .Production: return "api.lunohq.com"
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
            case .Dev: return "dev"
            case .Local: return "local"
            case .Staging: return "staging"
            case .Production: return "production"
            }
        }
        
        var redirectHostSuffix: String {
            switch self {
            case .Dev, .Local, .Staging, .Production: return "lunohq.com"
            }
        }
    }
    
//    static let environment = Environment.Production
    static let environment = Environment.Local
//    static let environment = Environment.Dev
    
    var data: NSData
    var token: String?
    
    init(data withData: NSData, token withToken: String?) {
        data = withData
        token = withToken
    }
    
    var URLRequest: NSMutableURLRequest {
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
    
    private func printErrorMessage(serviceRequest: Soa.ServiceRequestV1, error: NSError?) {
        if let error = error {
            print("Error Description: \(serviceRequest.control.service):\(serviceRequest.actions[0].control.action): \(error.description)")
            if let errorDetails = error.userInfo["error_details"] as? [ProtobufRegistry.Soa.ActionResultV1.ErrorDetailV1] {
                for errorDetail in errorDetails {
                    print("Error Details: \(errorDetail)")
                }
            }
        }
    }
    
    override func processRequest(serviceRequest: Soa.ServiceRequestV1, serializedRequest: NSData, completionHandler: ServiceCompletionHandler) {
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
                self.printErrorMessage(serviceRequest, error: error)
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
