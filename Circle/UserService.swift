//
//  UserService.swift
//  Circle
//
//  Created by Michael Hahn on 12/21/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry
import ProtocolBuffers

extension UserService {
    enum Requests: ServiceRequestConvertible {
        case AuthenticateUser(
            UserService.AuthenticateUser.Request.AuthBackend,
            String,
            String
        )
        
        var builder: GeneratedMessageBuilder {
            switch self {
            case AuthenticateUser(let backend, let email, let password):
                let requestBuilder = UserService.AuthenticateUser.Request.builder()
                requestBuilder.backend = backend
                
                let credentials = requestBuilder.credentials.builder()
                credentials.key = email
                credentials.secret = password
                requestBuilder.credentials = credentials.build()
                return requestBuilder
            }
        }
        
        var actionName: String {
            switch self {
            case .AuthenticateUser:
                return "authenticate_user"
            }
        }
        
        var extensionField: ConcreateExtensionField {
            switch self {
            case .AuthenticateUser:
                return UserServiceRequests_authenticate_user
            }
        }
    }
    
    enum Responses: ServiceResponseConvertible {
        
        case AuthenticateUser(ActionResponse)
        
        var success: Bool {
            switch self {
            case .AuthenticateUser(let response):
                return response.result.success
            }
        }
        
        var result: GeneratedMessage {
            switch self {
            case .AuthenticateUser(let response):
                return response.result.getExtension(
                    UserServiceResponses_authenticate_user
                ) as GeneratedMessage
            }
        }
        
    }
}