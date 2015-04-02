//
//  UserService.swift
//  Circle
//
//  Created by Michael Hahn on 12/21/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias AuthenticateUserCompletionHandler = (user: UserService.Containers.User?, token: String?, newUser: Bool?, error: NSError?) -> Void
typealias UpdateUserCompletionHandler = (user: UserService.Containers.User?, error: NSError?) -> Void
typealias SendVerificationCodeCompletionHandler = (error: NSError?) -> Void
typealias VerifyVerificationCodeCompletionHandler = (verified: Bool?, error: NSError?) -> Void
typealias GetAuthorizationInstructionsCompletionHandler = (authorizationURL: String?, error: NSError?) -> Void
typealias CompleteAuthorizationCompletionHandler = (user: UserService.Containers.User?, identity: UserService.Containers.Identity?, error: NSError?) -> Void
typealias GetIdentitiesCompletionHandler = (identities: Array<UserService.Containers.Identity>?, error: NSError?) -> Void
typealias RecordDeviceCompletionHandler = (device: UserService.Containers.Device?, error: NSError?) -> Void
typealias RequestAccessCompletionHandler = (access_request: UserService.Containers.AccessRequest?, error: NSError?) -> Void
typealias DeleteIdentityCompletionHandler = (error: NSError?) -> Void

extension UserService {
    class Actions {
    
        class func authenticateUser(
            backend: UserService.AuthenticateUser.Request.AuthBackend,
            credentials: UserService.AuthenticateUser.Request.Credentials,
            completionHandler: AuthenticateUserCompletionHandler?
        ) {
            let requestBuilder = UserService.AuthenticateUser.Request.builder()
            requestBuilder.backend = backend
            requestBuilder.credentials = credentials
            let client = ServiceClient(serviceName: "user")
            client.callAction("authenticate_user", extensionField: UserServiceRequests_authenticate_user, requestBuilder: requestBuilder) {
                (_, _, wrapped, error) in
                let response = wrapped?.response?.result.getExtension(UserServiceRequests_authenticate_user) as? UserService.AuthenticateUser.Response
                completionHandler?(user: response?.user, token: response?.token, newUser: response?.new_user, error: error)
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
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(UserServiceRequests_update_user) as? UserService.UpdateUser.Response
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
            ) { (_, _, _, error) -> Void in
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
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
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
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        UserServiceRequests_get_authorization_instructions
                    ) as? UserService.GetAuthorizationInstructions.Response
                    completionHandler?(authorizationURL: response?.authorization_url, error: error)
            }
        }
        
        class func completeAuthorization(
            provider: UserService.Provider,
            oAuth2Details: UserService.Containers.OAuth2Details?,
            oAuthSDKDetails: UserService.Containers.OAuthSDKDetails?,
            completionHandler: CompleteAuthorizationCompletionHandler?
        ) {
            let requestBuilder = UserService.CompleteAuthorization.Request.builder()
            requestBuilder.provider = provider
            if let oAuth2Details = oAuth2Details {
                requestBuilder.oauth2_details = oAuth2Details
            }
            if let oAuthSDKDetails = oAuthSDKDetails {
                requestBuilder.oauth_sdk_details = oAuthSDKDetails
            }

            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "complete_authorization",
                extensionField: UserServiceRequests_complete_authorization,
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        UserServiceRequests_complete_authorization
                    ) as? UserService.CompleteAuthorization.Response
                    completionHandler?(user: response?.user, identity: response?.identity, error: error)
            }
        }
        
        class func getIdentities(userId: String, completionHandler: GetIdentitiesCompletionHandler?) {
            let requestBuilder = UserService.GetIdentities.Request.builder()
            requestBuilder.user_id = userId
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "get_identities",
                extensionField: UserServiceRequests_get_identities,
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        UserServiceRequests_get_identities
                    ) as? UserService.GetIdentities.Response
                    completionHandler?(identities: response?.identities, error: error)
            }
        }

        class func recordDevice(pushToken: String?, completionHandler: RecordDeviceCompletionHandler?) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
                if let loggedInUser = AuthViewController.getLoggedInUser() {
                    let deviceBuilder = UserService.Containers.Device.builder()
                    deviceBuilder.platform = UIDevice.currentDevice().modelName
                    deviceBuilder.os_version = NSString(format:"%@ %@", UIDevice.currentDevice().systemName, UIDevice.currentDevice().systemVersion)
                    deviceBuilder.app_version = NSString(format:"%@ (%@)", NSBundle.appVersion(), NSBundle.appBuild())
                    deviceBuilder.device_uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
                    deviceBuilder.user_id = loggedInUser.id
                    if let pushToken = pushToken {
                        deviceBuilder.notification_token = pushToken
                    }
                    let requestBuilder = UserService.RecordDevice.Request.builder()
                    requestBuilder.device = deviceBuilder.build()
                    
                    let client = ServiceClient(serviceName: "user")
                    client.callAction(
                        "record_device",
                        extensionField: UserServiceRequests_record_device,
                        requestBuilder: requestBuilder
                    ) { (_, _, wrapped, error) -> Void in
                        let response = wrapped?.response?.result.getExtension(
                            UserServiceRequests_record_device
                        ) as? UserService.RecordDevice.Response
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler?(device: response?.device, error: error)
                            return
                        })
                    }
                }
            })
        }

        class func requestAccess(completionHandler: RequestAccessCompletionHandler?) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
                if let loggedInUser = AuthViewController.getLoggedInUser() {
                    let requestBuilder = UserService.RequestAccess.Request.builder()
                    requestBuilder.user_id = loggedInUser.id
                    
                    let client = ServiceClient(serviceName: "user")
                    client.callAction(
                        "request_access",
                        extensionField: UserServiceRequests_request_access,
                        requestBuilder: requestBuilder
                    ) { (_, _, wrapped, error) -> Void in
                            let response = wrapped?.response?.result.getExtension(
                                UserServiceRequests_request_access
                            ) as? UserService.RequestAccess.Response
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler?(access_request: response?.access_request, error: error)
                            return
                        })
                    }
                }
            })
        }
        
        class func deleteIdentity(identity: UserService.Containers.Identity, completionHandler: DeleteIdentityCompletionHandler?) {
            let requestBuilder = UserService.DeleteIdentity.Request.builder()
            requestBuilder.identity = identity
            
            let client = ServiceClient(serviceName: "user")
            client.callAction(
                "delete_identity",
                extensionField: UserServiceRequests.delete_identity(),
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    UserServiceRequests.delete_identity()
                ) as? UserService.RequestAccess.Response
                completionHandler?(error: error)
            }
        }
    
    }
}
