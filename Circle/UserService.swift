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
typealias UpdateUserCompletionHandler = (user: UserService.Containers.User?, error: NSError?) -> Void
typealias SendVerificationCodeCompletionHandler = (error: NSError?) -> Void
typealias VerifyVerificationCodeCompletionHandler = (verified: Bool?, error: NSError?) -> Void
typealias GetAuthorizationInstructionsCompletionHandler = (authorizationURL: String?, error: NSError?) -> Void
typealias CompleteAuthorizationCompletionHandler = (user: UserService.Containers.User?, identity: UserService.Containers.Identity?, error: NSError?) -> Void

extension UserService {
    class Actions {
    
        class func authenticateUser(
            backend: UserService.AuthenticateUser.Request.AuthBackend,
            email: String,
            password: String,
            completionHandler: AuthenticateUserCompletionHandler?
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
                completionHandler?(user: response?.user, token: response?.token, error: error)
            }
        }
        
        class func updateUser(user: UserService.Containers.User, completionHandler: UpdateUserCompletionHandler?) {
            let requestBuilder = UserService.UpdateUser.Request.builder()
            requestBuilder.user = user
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "update_user",
                extensionField: UserServiceRequests_update_user,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(UserServiceRequests_update_user) as? UserService.UpdateUser.Response
                completionHandler?(user: response?.user, error: error)
            }
        }
        
        
        class func sendVerificationCode(user: UserService.Containers.User, completionHandler: SendVerificationCodeCompletionHandler?) {
            let requestBuilder = UserService.SendVerificationCode.Request.builder()
            requestBuilder.user_id = user.id
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "send_verification_code",
                extensionField: UserServiceRequests_send_verification_code,
                requestBuilder: requestBuilder
            ) { (_, _, _, _, error) -> Void in
                completionHandler?(error: error)
                return
            }
        }
        
        class func verifyVerificationCode(code: String, user: UserService.Containers.User, completionHandler: VerifyVerificationCodeCompletionHandler?) {
            let requestBuilder = UserService.VerifyVerificationCode.Request.builder()
            requestBuilder.user_id = user.id
            requestBuilder.code = code
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "verify_verification_code",
                extensionField: UserServiceRequests_verify_verification_code,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    UserServiceRequests_verify_verification_code
                ) as? UserService.VerifyVerificationCode.Response
                completionHandler?(verified: response?.verified, error: error)
            }
        }
        
        class func getAuthorizationInstructions(provider: UserService.Provider, completionHandler: GetAuthorizationInstructionsCompletionHandler?) {
            let requestBuilder = UserService.GetAuthorizationInstructions.Request.builder()
            requestBuilder.provider = provider
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "get_authorization_instructions",
                extensionField: UserServiceRequests_get_authorization_instructions,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        UserServiceRequests_get_authorization_instructions
                    ) as? UserService.GetAuthorizationInstructions.Response
                    completionHandler?(authorizationURL: response?.authorization_url, error: error)
            }
        }
        
        class func completeAuthorization(provider: UserService.Provider, oauth2Details: UserService.Containers.OAuth2Details, completionHandler: CompleteAuthorizationCompletionHandler?) {
            let requestBuilder = UserService.CompleteAuthorization.Request.builder()
            requestBuilder.provider = provider
            requestBuilder.oauth2_details = oauth2Details
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "complete_authorization",
                extensionField: UserServiceRequests_complete_authorization,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        UserServiceRequests_complete_authorization
                    ) as? UserService.CompleteAuthorization.Response
                    completionHandler?(user: response?.user, identity: response?.identity, error: error)
            }
        }
        
    }
}