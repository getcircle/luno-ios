//
//  UserService.swift
//  Circle
//
//  Created by Michael Hahn on 12/21/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias AuthenticateUserCompletionHandler = (user: UserService.Containers.User?, token: String?, error: NSError?) -> Void

extension UserService {
    class Actions {
    
        class func authenticateUser(
            backend: UserService.AuthenticateUser.Request.AuthBackend,
            email: String,
            password: String,
            completionHandler: AuthenticateUserCompletionHandler
        ) {
            let requestBuilder = UserService.AuthenticateUser.Request.builder()
            requestBuilder.backend = backend
            
            let credentials = requestBuilder.credentials.builder()
            credentials.key = email
            credentials.secret = password
            requestBuilder.credentials = credentials.build()

            let client = ServiceClient(serviceName: "user")
            client.callAction("authenticate_user", extensionField: UserServiceRequests_authenticate_user, requestBuilder: requestBuilder) {
                (_, _, _, actionResponse, error) in
                let response = actionResponse?.result.getExtension(UserServiceRequests_authenticate_user) as? UserService.AuthenticateUser.Response
                completionHandler(user: response?.user, token: response?.token, error: error)
            }
        }
        
    }
}