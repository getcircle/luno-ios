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
    notes: Array<Services.Note.Containers.NoteV1>?,
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
        
    private class func getProfile(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfileCompletionHandler?) {
        let client = ServiceClient(serviceName: "profile")
        client.callAction("get_profile", extensionField: Services.Registry.Requets.Profile.getProfile(), requestBuilder: requestBuilder) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(Services.Registry.Requets.Profile.getProfile()) as? ProfileService.GetProfile.ResponseV1
            completionHandler?(profile: response?.profile, error: error)
        }
    }
    
    class func getProfile(profileId: String, completionHandler: GetProfileCompletionHandler?) {
        let requestBuilder = ProfileService.GetProfile.RequestV1.builder()
        requestBuilder.profileId = profileId
        self.getProfile(requestBuilder, completionHandler: completionHandler)
    }
    
    class func getProfile(#userId: String, completionHandler: GetProfileCompletionHandler?) {
        let requestBuilder = ProfileService.GetProfile.RequestV1.builder()
        requestBuilder.userId = userId
        self.getProfile(requestBuilder, completionHandler: completionHandler)
    }
    
    private class func getProfiles(
        requestBuilder: AbstractMessageBuilder,
        completionHandler: GetProfilesCompletionHandler?,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil
    ) {
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_profiles",
            extensionField: Services.Registry.Requets.Profile.getProfiles(),
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
        ) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requets.Profile.getProfiles()
            ) as? ProfileService.GetProfiles.ResponseV1
            let nextRequest = wrapped?.getNextRequest()
            completionHandler?(profiles: response?.profiles, nextRequest: nextRequest, error: error)
        }
    }
    
    class func getProfiles(
        teamId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = ProfileService.GetProfiles.RequestV1.builder()
        requestBuilder.team_id = teamId
        self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
    }
    
    class func getProfiles(
        #organizationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = ProfileService.GetProfiles.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
    }
    
    class func getProfiles(
        #tagId: String,
        organizationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = ProfileService.GetProfiles.RequestV1.builder()
        requestBuilder.tagId = tagId
        requestBuilder.organizationId = organizationId
        self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
    }
    
    class func getProfiles(
        #addressId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = ProfileService.GetProfiles.RequestV1.builder()
        requestBuilder.addressId = addressId
        self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
    }
    
    class func getProfiles(
        #locationId: String,
        paginatorBuilder: Soa.PaginatorV1Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = ProfileService.GetProfiles.RequestV1.builder()
        requestBuilder.locationId = locationId
        self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
    }
    
    class func getExtendedProfile(profileId: String, completionHandler: GetExtendedProfileCompletionHandler?) {
        let requestBuilder = ProfileService.GetExtendedProfile.RequestV1.builder()
        requestBuilder.profileId = profileId
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_extended_profile",
            extensionField: Services.Registry.Requets.Profile.getExtendedProfile(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requets.Profile.getExtendedProfile()
            ) as? ProfileService.GetExtendedProfile.ResponseV1
            completionHandler?(
                profile: response?.profile,
                manager: response?.manager,
                team: response?.team,
                address: response?.address,
                interests: response?.tags,
                notes: response?.notes,
                identities: response?.identities,
                resume: response?.resume,
                location: response?.location,
                error: error
            )
        }
    }
    
    class func getTags(organizationId: String, tagType: ProfileService.TagType?, completionHandler: GetTagsCompletionHandler?) {
        let requestBuilder = ProfileService.GetTags.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        if tagType != nil {
            requestBuilder.tag_type = tagType!
        }
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_tags",
            extensionField: Services.Registry.Requets.Profile.getTags(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(Services.Registry.Requets.Profile.getTags()) as? ProfileService.GetTags.ResponseV1
            completionHandler?(interests: response?.tags, error: error)
        }
    }
    
    class func getActiveTags(organizationId: String, tagType: ProfileService.TagType?, paginatorBuilder: Soa.PaginatorV1Builder? = nil, completionHandler: GetTagsCompletionHandler?) {
        let requestBuilder = ProfileService.GetActiveTags.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        if tagType != nil {
            requestBuilder.tag_type = tagType!
        }
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "get_active_tags",
            extensionField: Services.Registry.Requets.Profile.getActiveTags(),
            requestBuilder: requestBuilder,
            paginatorBuilder: paginatorBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requets.Profile.getActiveTags()
            ) as? ProfileService.GetActiveTags.ResponseV1
            completionHandler?(interests: response?.tags, error: error)
        }
    }
    
    class func updateProfile(profile: Services.Profile.Containers.ProfileV1, completionHandler: UpdateProfileCompletionHandler?) {
        let requestBuilder = ProfileService.UpdateProfile.RequestV1.builder()
        requestBuilder.profile = profile
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "update_profile",
            extensionField: Services.Registry.Requets.Profile.updateProfile(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Requets.Profile.updateProfile()
                ) as? ProfileService.UpdateProfile.ResponseV1
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
    
    class func addTags(profileId: String, tags: Array<Services.Profile.Containers.TagV1>, completionHandler: AddTagsCompletionHandler?) {
        let requestBuilder = ProfileService.AddTags.RequestV1.builder()
        requestBuilder.profileId = profileId
        requestBuilder.tags = tags
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "add_tags",
            extensionField: Services.Registry.Requets.Profile.addTags(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                // DWM - Discuss with Michael
                // TODO: Either check for no errors or pass than along in the userInfo
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        ProfileServiceNotifications.onProfileUpdatedNotification,
                        object: nil
                    )
                })
                let response = wrapped?.response?.result.getExtension(Services.Registry.Requets.Profile.addTags()) as? ProfileService.AddTags.ResponseV1
                completionHandler?(error: error)
        }
    }
    
    class func removeTags(profileId: String, tags: Array<Services.Profile.Containers.TagV1>, completionHandler: RemoveTagsCompletionHandler?) {
        let requestBuilder = ProfileService.RemoveTags.RequestV1.builder()
        requestBuilder.profileId = profileId
        requestBuilder.tags = tags
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "remove_tags",
            extensionField: Services.Registry.Requets.Profile.removeTags(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(
                    ProfileServiceNotifications.onProfileUpdatedNotification,
                    object: nil
                )
            })
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requets.Profile.removeTags()
            ) as? ProfileService.RemoveTags.ResponseV1
            completionHandler?(error: error)
        }
    }
}

extension Services.Profile.Containers.ProfileV1 {
    
    func getEmail() -> String? {
        return email
    }
    
    func getCellPhone() -> String? {
        let cellPhones = contact_methods.filter { $0.type == .CellPhone }
        if cellPhones.count > 0 {
            return cellPhones[0].value
        }
        return nil
    }
    
}
