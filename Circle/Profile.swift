//
//  Profile.swift
//  Circle
//
//  Created by Michael Hahn on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

struct ProfileServiceNotifications {
    static let onProfileUpdatedNotification = "com.rhlabs.notification:onProfileUpdatedNotification"
}

typealias GetProfileCompletionHandler = (profile: Services.Profile.Containers.ProfileV1?, error: NSError?) -> Void
typealias GetProfilesCompletionHandler = (profiles: Array<Services.Profile.Containers.ProfileV1>?, nextRequest: Soa.ServiceRequestV1?, error: NSError?) -> Void
typealias GetExtendedProfileCompletionHandler = (
    profile: Services.Profile.Containers.ProfileV1?,
    manager: Services.Profile.Containers.ProfileV1?,
    team: Services.Organization.Containers.TeamV1?,
    address: Services.Organization.Containers.AddressV1?,
    interests: Array<Services.Profile.Containers.TagV1>?,
    skills: Array<Services.Profile.Containers.TagV1>?,
    identities: Array<Services.User.Containers.IdentityV1>?,
    resume: Services.Resume.Containers.ResumeV1?,
    location: Services.Organization.Containers.LocationV1?,
    error: NSError?
) -> Void
typealias GetTagsCompletionHandler = (interests: Array<Services.Profile.Containers.TagV1>?, error: NSError?) -> Void
typealias UpdateProfileCompletionHandler = (profile: Services.Profile.Containers.ProfileV1?, error: NSError?) -> Void
typealias AddTagsCompletionHandler = (error: NSError?) -> Void
typealias RemoveTagsCompletionHandler = (error: NSError?) -> Void

extension Services.Profile.Actions {
        
    private static func getProfile(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfileCompletionHandler?) {
        let client = ServiceClient(serviceName: "profile")
        client.callAction("get_profile", extensionField: Services.Registry.Requests.Profile.getProfile(), requestBuilder: requestBuilder) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Profile.getProfile()
            ) as? Services.Profile.Actions.GetProfile.ResponseV1
            completionHandler?(profile: response?.profile, error: error)
        }
    }
    
    static func getProfile(profileId: String, completionHandler: GetProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetProfile.RequestV1.builder()
        requestBuilder.profileId = profileId
        self.getProfile(requestBuilder, completionHandler: completionHandler)
    }
    
    static func getProfile(#userId: String, completionHandler: GetProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetProfile.RequestV1.builder()
        requestBuilder.userId = userId
        self.getProfile(requestBuilder, completionHandler: completionHandler)
    }
    
    private static func getProfiles(
        requestBuilder: AbstractMessageBuilder,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_profiles",
            extensionField: Services.Registry.Requests.Profile.getProfiles(),
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
        ) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Profile.getProfiles()
            ) as? Services.Profile.Actions.GetProfiles.ResponseV1
            let nextRequest = wrapped?.getNextRequest()
            completionHandler?(profiles: response?.profiles, nextRequest: nextRequest, error: error)
        }
    }
    
    static func getProfiles(
        teamId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.teamId = teamId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        #organizationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        #tagId: String,
        organizationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.tagId = tagId
        requestBuilder.organizationId = organizationId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        #addressId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.addressId = addressId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        #locationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.locationId = locationId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getExtendedProfile(profileId: String, completionHandler: GetExtendedProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetExtendedProfile.RequestV1.builder()
        requestBuilder.profileId = profileId
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_extended_profile",
            extensionField: Services.Registry.Requests.Profile.getExtendedProfile(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in

            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Profile.getExtendedProfile()
            ) as? Services.Profile.Actions.GetExtendedProfile.ResponseV1
            completionHandler?(
                profile: response?.profile,
                manager: response?.manager,
                team: response?.team,
                address: response?.address,
                interests: response?.interests,
                skills: response?.skills,
                identities: response?.identities,
                resume: response?.resume,
                location: response?.location,
                error: error
            )
        }
    }
    
    static func getTags(organizationId: String, tagType: Services.Profile.Containers.TagV1.TagTypeV1?, completionHandler: GetTagsCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetTags.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        if tagType != nil {
            requestBuilder.tagType = tagType!
        }
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_tags",
            extensionField: Services.Registry.Requests.Profile.getTags(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Profile.getTags()
            ) as? Services.Profile.Actions.GetTags.ResponseV1
            completionHandler?(interests: response?.tags, error: error)
        }
    }
    
    static func getActiveTags(organizationId: String, tagType: Services.Profile.Containers.TagV1.TagTypeV1?, paginatorBuilder: Soa.PaginatorV1Builder? = nil, completionHandler: GetTagsCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetActiveTags.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        if tagType != nil {
            requestBuilder.tagType = tagType!
        }
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_active_tags",
            extensionField: Services.Registry.Requests.Profile.getActiveTags(),
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Profile.getActiveTags()
            ) as? Services.Profile.Actions.GetActiveTags.ResponseV1
            completionHandler?(interests: response?.tags, error: error)
        }
    }
    
    static func updateProfile(profile: Services.Profile.Containers.ProfileV1, completionHandler: UpdateProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.UpdateProfile.RequestV1.builder()
        requestBuilder.profile = profile
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "update_profile",
            extensionField: Services.Registry.Requests.Profile.updateProfile(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Profile.updateProfile()
                ) as? Services.Profile.Actions.UpdateProfile.ResponseV1
                ObjectStore.sharedInstance.update(response?.profile, type: .Profile)
                completionHandler?(profile: response?.profile, error: error)
                // DWM - Discuss with Michael
                // TODO: Either check for no errors or pass than along in the userInfo
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        ProfileServiceNotifications.onProfileUpdatedNotification,
                        object: nil
                    )
                })
        }
    }
    
    static func addTags(profileId: String, tags: Array<Services.Profile.Containers.TagV1>, completionHandler: AddTagsCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.AddTags.RequestV1.builder()
        requestBuilder.profileId = profileId
        requestBuilder.tags = tags
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "add_tags",
            extensionField: Services.Registry.Requests.Profile.addTags(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                // DWM - Discuss with Michael
                // TODO: Either check for no errors or pass than along in the userInfo
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        ProfileServiceNotifications.onProfileUpdatedNotification,
                        object: nil
                    )
                })
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Profile.addTags()
                ) as? Services.Profile.Actions.AddTags.ResponseV1
                completionHandler?(error: error)
        }
    }
    
    static func removeTags(profileId: String, tags: Array<Services.Profile.Containers.TagV1>, completionHandler: RemoveTagsCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.RemoveTags.RequestV1.builder()
        requestBuilder.profileId = profileId
        requestBuilder.tags = tags
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "remove_tags",
            extensionField: Services.Registry.Requests.Profile.removeTags(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(
                    ProfileServiceNotifications.onProfileUpdatedNotification,
                    object: nil
                )
            })
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Profile.removeTags()
            ) as? Services.Profile.Actions.RemoveTags.ResponseV1
            completionHandler?(error: error)
        }
    }
}

extension Services.Profile.Containers.ProfileV1 {
    
    func getEmail() -> String? {
        return email
    }
    
    func getCellPhone() -> String? {
        let cellPhones = contactMethods.filter { $0.contactMethodType == .CellPhone }
        if cellPhones.count > 0 {
            return cellPhones[0].value
        }
        return nil
    }
    
}
