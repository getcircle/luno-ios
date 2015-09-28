//
//  User.swift
//  Circle
//
//  Created by Michael Hahn on 12/21/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

typealias CreateUserCompletionHandler = (user: Services.User.Containers.UserV1?, error: NSError?) -> Void
typealias AuthenticateUserCompletionHandler = (user: Services.User.Containers.UserV1?, token: String?, newUser: Bool?, error: NSError?) -> Void
typealias UpdateUserCompletionHandler = (user: Services.User.Containers.UserV1?, error: NSError?) -> Void
typealias SendVerificationCodeCompletionHandler = (error: NSError?) -> Void
typealias VerifyVerificationCodeCompletionHandler = (verified: Bool?, error: NSError?) -> Void
typealias GetAuthorizationInstructionsCompletionHandler = (authorizationURL: String?, error: NSError?) -> Void
typealias GetAuthenticationInstructionsCompletionHandler = (backend: Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1?, accountExists: Bool?, authorizationURL: String?, providerName: String?, error: NSError?) -> Void
typealias CompleteAuthorizationCompletionHandler = (user: Services.User.Containers.UserV1?, identity: Services.User.Containers.IdentityV1?, error: NSError?) -> Void
typealias GetIdentitiesCompletionHandler = (identities: Array<Services.User.Containers.IdentityV1>?, error: NSError?) -> Void
typealias RecordDeviceCompletionHandler = (device: Services.User.Containers.DeviceV1?, error: NSError?) -> Void
typealias RequestAccessCompletionHandler = (accessRequest: Services.User.Containers.AccessRequestV1?, error: NSError?) -> Void
typealias DeleteIdentityCompletionHandler = (error: NSError?) -> Void
typealias LogoutCompletionHandler = (error: NSError?) -> Void

extension Services.User.Actions {
    
    static func createUser(
        email: String,
        password: String,
        completionHandler: CreateUserCompletionHandler?
    ) {
            let requestBuilder = Services.User.Actions.CreateUser.RequestV1.Builder()
            requestBuilder.email = email
            requestBuilder.password = password
            let client = ServiceClient(serviceName: "user")
            client.callAction("create_user", extensionField: Services.Registry.Requests.User.createUser(), requestBuilder: requestBuilder) {
                (_, _, wrapped, error) in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.User.createUser()
                ) as? Services.User.Actions.CreateUser.ResponseV1
                completionHandler?(user: response?.user, error: error)
            }
    }

    static func authenticateUser(
        backend: Services.User.Actions.AuthenticateUser.RequestV1.AuthBackendV1,
        credentials: Services.User.Actions.AuthenticateUser.RequestV1.CredentialsV1,
        completionHandler: AuthenticateUserCompletionHandler?
    ) {
        let requestBuilder = Services.User.Actions.AuthenticateUser.RequestV1.Builder()
        requestBuilder.backend = backend
        requestBuilder.credentials = credentials
        requestBuilder.clientType = .Ios
        let client = ServiceClient(serviceName: "user")
        client.callAction("authenticate_user", extensionField: Services.Registry.Requests.User.authenticateUser(), requestBuilder: requestBuilder) {
            (_, _, wrapped, error) in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.User.authenticateUser()
            ) as? Services.User.Actions.AuthenticateUser.ResponseV1
            completionHandler?(user: response?.user, token: response?.token, newUser: response?.newUser, error: error)
        }
    }
    
    static func updateUser(user: Services.User.Containers.UserV1, completionHandler: UpdateUserCompletionHandler?) {
        let requestBuilder = Services.User.Actions.UpdateUser.RequestV1.Builder()
        requestBuilder.user = user
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "update_user",
            extensionField: Services.Registry.Requests.User.updateUser(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.User.updateUser()
            ) as? Services.User.Actions.UpdateUser.ResponseV1
            completionHandler?(user: response?.user, error: error)
        }
    }
    
    static func sendVerificationCode(user: Services.User.Containers.UserV1, completionHandler: SendVerificationCodeCompletionHandler?) {
        let requestBuilder = Services.User.Actions.SendVerificationCode.RequestV1.Builder()
        requestBuilder.userId = user.id
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "send_verification_code",
            extensionField: Services.Registry.Requests.User.sendVerificationCode(),
            requestBuilder: requestBuilder
        ) { (_, _, _, error) -> Void in
            completionHandler?(error: error)
            return
        }
    }
    
    static func verifyVerificationCode(code: String, user: Services.User.Containers.UserV1, completionHandler: VerifyVerificationCodeCompletionHandler?) {
        let requestBuilder = Services.User.Actions.VerifyVerificationCode.RequestV1.Builder()
        requestBuilder.userId = user.id
        requestBuilder.code = code
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "verify_verification_code",
            extensionField: Services.Registry.Requests.User.verifyVerificationCode(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.User.verifyVerificationCode()
            ) as? Services.User.Actions.VerifyVerificationCode.ResponseV1
            completionHandler?(verified: response?.verified, error: error)
        }
    }
    
    static func getAuthorizationInstructions(provider: Services.User.Containers.IdentityV1.ProviderV1, loginHint: String? = nil, completionHandler: GetAuthorizationInstructionsCompletionHandler?) {
        let requestBuilder = Services.User.Actions.GetAuthorizationInstructions.RequestV1.Builder()
        requestBuilder.provider = provider
        if loginHint != nil {
            requestBuilder.loginHint = loginHint!
        }
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "get_authorization_instructions",
            extensionField: Services.Registry.Requests.User.getAuthorizationInstructions(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.User.getAuthorizationInstructions()
                    ) as? Services.User.Actions.GetAuthorizationInstructions.ResponseV1
                completionHandler?(authorizationURL: response?.authorizationUrl, error: error)
        }
    }

    static func getAuthenticationInstructions(email: String, completionHandler: GetAuthenticationInstructionsCompletionHandler?) {
        let requestBuilder = Services.User.Actions.GetAuthenticationInstructions.RequestV1.Builder()
        requestBuilder.email = email

        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "get_authentication_instructions",
            extensionField: Services.Registry.Requests.User.getAuthenticationInstructions(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.User.getAuthenticationInstructions()
                ) as? Services.User.Actions.GetAuthenticationInstructions.ResponseV1
                completionHandler?(backend: response?.backend, accountExists: response?.userExists, authorizationURL: response?.authorizationUrl, providerName: response?.providerName, error: error)
            }
    }
    
    static func completeAuthorization(
        provider: Services.User.Containers.IdentityV1.ProviderV1,
        oAuth2Details: Services.User.Containers.OAuth2DetailsV1?,
        oAuthSDKDetails: Services.User.Containers.OAuthSDKDetailsV1?,
        completionHandler: CompleteAuthorizationCompletionHandler?
    ) {
        let requestBuilder = Services.User.Actions.CompleteAuthorization.RequestV1.Builder()
        requestBuilder.provider = provider
        if let oAuth2Details = oAuth2Details {
            requestBuilder.oauth2Details = oAuth2Details
        }
        if let oAuthSDKDetails = oAuthSDKDetails {
            requestBuilder.oauthSdkDetails = oAuthSDKDetails
        }

        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "complete_authorization",
            extensionField: Services.Registry.Requests.User.completeAuthorization(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.User.completeAuthorization()
                ) as? Services.User.Actions.CompleteAuthorization.ResponseV1
                completionHandler?(user: response?.user, identity: response?.identity, error: error)
        }
    }
    
    static func getIdentities(userId: String, completionHandler: GetIdentitiesCompletionHandler?) {
        let requestBuilder = Services.User.Actions.GetIdentities.RequestV1.Builder()
        requestBuilder.userId = userId
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "get_identities",
            extensionField: Services.Registry.Requests.User.getIdentities(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.User.getIdentities()
                ) as? Services.User.Actions.GetIdentities.ResponseV1
                completionHandler?(identities: response?.identities, error: error)
        }
    }

    static func recordDevice(pushToken: String?, completionHandler: RecordDeviceCompletionHandler?) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
            if let loggedInUser = AuthenticationViewController.getLoggedInUser(), deviceUuid = UIDevice.currentDevice().identifierForVendor?.UUIDString {
                let deviceBuilder = Services.User.Containers.DeviceV1.Builder()
                let currentDevice = UIDevice.currentDevice()
                let appVersion = NSBundle.appVersion()
                let appBuild = NSBundle.appBuild()
                deviceBuilder.platform = UIDevice.currentDevice().modelName
                deviceBuilder.osVersion = "\(currentDevice.systemName) \(currentDevice.systemVersion)"
                deviceBuilder.appVersion = "\(appVersion) (\(appBuild))"
                deviceBuilder.deviceUuid = deviceUuid
                deviceBuilder.provider = .Apple
                deviceBuilder.userId = loggedInUser.id
                if let pushToken = pushToken {
                    deviceBuilder.notificationToken = pushToken
                }
                let requestBuilder = Services.User.Actions.RecordDevice.RequestV1.Builder()
                requestBuilder.device = try! deviceBuilder.build()
                
                let client = ServiceClient(serviceName: "user")
                client.callAction(
                    "record_device",
                    extensionField: Services.Registry.Requests.User.recordDevice(),
                    requestBuilder: requestBuilder
                ) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        Services.Registry.Responses.User.recordDevice()
                    ) as? Services.User.Actions.RecordDevice.ResponseV1
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler?(device: response?.device, error: error)
                        return
                    })
                }
            }
        })
    }

    static func requestAccess(completionHandler: RequestAccessCompletionHandler?) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), { () -> Void in
            if let loggedInUser = AuthenticationViewController.getLoggedInUser() {
                let requestBuilder = Services.User.Actions.RequestAccess.RequestV1.Builder()
                requestBuilder.userId = loggedInUser.id
                
                let client = ServiceClient(serviceName: "user")
                client.callAction(
                    "request_access",
                    extensionField: Services.Registry.Requests.User.requestAccess(),
                    requestBuilder: requestBuilder
                ) { (_, _, wrapped, error) -> Void in
                        let response = wrapped?.response?.result.getExtension(
                            Services.Registry.Responses.User.requestAccess()
                        ) as? Services.User.Actions.RequestAccess.ResponseV1
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler?(accessRequest: response?.accessRequest, error: error)
                        return
                    })
                }
            }
        })
    }
    
    static func deleteIdentity(identity: Services.User.Containers.IdentityV1, completionHandler: DeleteIdentityCompletionHandler?) {
        let requestBuilder = Services.User.Actions.DeleteIdentity.RequestV1.Builder()
        requestBuilder.identity = identity
        
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "delete_identity",
            extensionField: Services.Registry.Requests.User.deleteIdentity(),
            requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                wrapped?.response?.result.getExtension(Services.Registry.Responses.User.deleteIdentity())
                completionHandler?(error: error)
        }
    }
    
    static func logout(completionHandler: LogoutCompletionHandler?) {
        let requestBuilder = Services.User.Actions.Logout.RequestV1.Builder()
        requestBuilder.clientType = .Ios
        let client = ServiceClient(serviceName: "user")
        client.callAction(
            "logout",
            extensionField: Services.Registry.Requests.User.logout(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            completionHandler?(error: error)
        }
    }
    
}
