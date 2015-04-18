//
//  User.swift
//  Circle
//
//  Created by Michael Hahn on 12/21/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias AuthenticateUserCompletionHandler = (user: Services.User.Containers.UserV1?, token: String?, newUser: Bool?, error: NSError?) -> Void
typealias UpdateUserCompletionHandler = (user: Services.User.Containers.UserV1?, error: NSError?) -> Void
typealias SendVerificationCodeCompletionHandler = (error: NSError?) -> Void
typealias VerifyVerificationCodeCompletionHandler = (verified: Bool?, error: NSError?) -> Void
typealias GetAuthorizationInstructionsCompletionHandler = (authorizationURL: String?, error: NSError?) -> Void
typealias CompleteAuthorizationCompletionHandler = (user: Services.User.Containers.UserV1?, identity: Services.User.Containers.IdentityV1?, error: NSError?) -> Void
typealias GetIdentitiesCompletionHandler = (identities: Array<Services.User.Containers.IdentityV1>?, error: NSError?) -> Void
typealias RecordDeviceCompletionHandler = (device: Services.User.Containers.DeviceV1?, error: NSError?) -> Void
typealias RequestAccessCompletionHandler = (access_request: Services.User.Containers.AccessRequestV1?, error: NSError?) -> Void
typealias DeleteIdentityCompletionHandler = (error: NSError?) -> Void

extension Services.User.Actions {
    
    class func authenticateUser(
        backend: Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1,
        credentials: Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1,
        completionHandler: AuthenticateUserCompletionHandler?
    ) {
        let requestBuilder = Services.User.Actions.AuthenticateUser.RequestV1.builder()
        requestBuilder.backend = backend
        requestBuilder.credentials = credentials
        let client = ServiceClient(serviceName: "user")
        client.callAction("authenticate_user", extensionField: Services.Registry.Requests.authenticateUser(), requestBuilder: requestBuilder) {
            (_, _, wrapped, error) in
            let response = wrapped?.response?.result.getExtension(Services.Registry.Requests.authenticateUser()) as? Services.User.Actions.AuthenticateUser.ResponseV1
            completionHandler?(user: response?.user, token: response?.token, newUser: response?.new_user, error: error)
        }
    }
    
    class func updateUser(user: Services.User.Containers.UserV1, completionHandler: UpdateUserCompletionHandler?) {
        let requestBuilder = Services.User.Actions.UpdateUser.RequestV1.builder()
        requestBuilder.user = user
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "update_user",
            extensionField: Services.Registry.Requests.updateUser(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(Services.Registry.Requests.updateUser()) as? Services.User.Actions.UpdateUser.ResponseV1
            completionHandler?(user: response?.user, error: error)
        }
    }
    
    
    class func sendVerificationCode(user: Services.User.Containers.UserV1, completionHandler: SendVerificationCodeCompletionHandler?) {
        let requestBuilder = Services.User.Actions.SendVerificationCode.RequestV1.builder()
        requestBuilder.userId = user.id
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "send_verification_code",
            extensionField: Services.Registry.Requests.sendVerificationCode(),
            requestBuilder: requestBuilder
        ) { (_, _, _, error) -> Void in
            completionHandler?(error: error)
            return
        }
    }
    
    class func verifyVerificationCode(code: String, user: Services.User.Containers.UserV1, completionHandler: VerifyVerificationCodeCompletionHandler?) {
        let requestBuilder = Services.User.Actions.VerifyVerificationCode.RequestV1.builder()
        requestBuilder.userId = user.id
        requestBuilder.code = code
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "verify_verification_code",
            extensionField: Services.Registry.Requests.verifyVerificationCode(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.verifyVerificationCode()
            ) as? Services.User.Actions.VerifyVerificationCode.ResponseV1
            completionHandler?(verified: response?.verified, error: error)
        }
    }
    
    class func getAuthorizationInstructions(provider: Services.User.Actions.Provider, completionHandler: GetAuthorizationInstructionsCompletionHandler?) {
        let requestBuilder = Services.User.Actions.GetAuthorizationInstructions.RequestV1.builder()
        requestBuilder.provider = provider
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "get_authorization_instructions",
            extensionField: Services.Registry.Requests.getAuthorizationInstructions(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Requests.getAuthorizationInstructions()
                ) as? Services.User.Actions.GetAuthorizationInstructions.ResponseV1
                completionHandler?(authorizationURL: response?.authorization_url, error: error)
        }
    }
    
    class func completeAuthorization(
        provider: Services.User.Actions.Provider,
        oAuth2Details: Services.User.Actions.Containers.OAuth2Details?,
        oAuthSDKDetails: Services.User.Actions.Containers.OAuthSDKDetails?,
        completionHandler: CompleteAuthorizationCompletionHandler?
    ) {
        let requestBuilder = Services.User.Actions.CompleteAuthorization.RequestV1.builder()
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
            extensionField: Services.Registry.Requests.completeAuthorization(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Requests.completeAuthorization()
                ) as? Services.User.Actions.CompleteAuthorization.ResponseV1
                completionHandler?(user: response?.user, identity: response?.identity, error: error)
        }
    }
    
    class func getIdentities(userId: String, completionHandler: GetIdentitiesCompletionHandler?) {
        let requestBuilder = Services.User.Actions.GetIdentities.RequestV1.builder()
        requestBuilder.userId = userId
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "get_identities",
            extensionField: Services.Registry.Requests.getIdentities(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Requests.getIdentities()
                ) as? Services.User.Actions.GetIdentities.ResponseV1
                completionHandler?(identities: response?.identities, error: error)
        }
    }

    class func recordDevice(pushToken: String?, completionHandler: RecordDeviceCompletionHandler?) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
            if let loggedInUser = AuthViewController.getLoggedInUser() {
                let deviceBuilder = Services.User.Containers.DeviceV1.builder()
                deviceBuilder.platform = UIDevice.currentDevice().modelName
                deviceBuilder.os_version = NSString(format:"%@ %@", UIDevice.currentDevice().systemName, UIDevice.currentDevice().systemVersion)
                deviceBuilder.app_version = NSString(format:"%@ (%@)", NSBundle.appVersion(), NSBundle.appBuild())
                deviceBuilder.device_uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
                deviceBuilder.userId = loggedInUser.id
                if let pushToken = pushToken {
                    deviceBuilder.notification_token = pushToken
                }
                let requestBuilder = Services.User.Actions.RecordDevice.RequestV1.builder()
                requestBuilder.device = deviceBuilder.build()
                
                let client = ServiceClient(serviceName: "user")
                client.callAction(
                    "record_device",
                    extensionField: Services.Registry.Requests.recordDevice(),
                    requestBuilder: requestBuilder
                ) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        Services.Registry.Requests.recordDevice()
                    ) as? Services.User.Actions.RecordDevice.ResponseV1
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
                let requestBuilder = Services.User.Actions.RequestAccess.RequestV1.builder()
                requestBuilder.userId = loggedInUser.id
                
                let client = ServiceClient(serviceName: "user")
                client.callAction(
                    "request_access",
                    extensionField: Services.Registry.Requests.requestAccess(),
                    requestBuilder: requestBuilder
                ) { (_, _, wrapped, error) -> Void in
                        let response = wrapped?.response?.result.getExtension(
                            Services.Registry.Requests.requestAccess()
                        ) as? Services.User.Actions.RequestAccess.ResponseV1
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler?(access_request: response?.access_request, error: error)
                        return
                    })
                }
            }
        })
    }
    
    class func deleteIdentity(identity: Services.User.Containers.IdentityV1, completionHandler: DeleteIdentityCompletionHandler?) {
        let requestBuilder = Services.User.Actions.DeleteIdentity.RequestV1.builder()
        requestBuilder.identity = identity
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "delete_identity",
            extensionField: Services.Registry.Requests.deleteIdentity(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.deleteIdentity()
            ) as? Services.User.Actions.RequestAccess.ResponseV1
            completionHandler?(error: error)
        }
    }
    
}
