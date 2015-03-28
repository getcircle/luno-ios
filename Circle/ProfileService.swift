//
//  ProfileService.swift
//  Circle
//
//  Created by Michael Hahn on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

struct ProfileServiceNotifications {
    static let onProfileUpdatedNotification = "com.ravcode.notification:onProfileUpdatedNotification"
}

typealias GetProfileCompletionHandler = (profile: ProfileService.Containers.Profile?, error: NSError?) -> Void
typealias GetProfilesCompletionHandler = (profiles: Array<ProfileService.Containers.Profile>?, nextRequest: ServiceRequest?, error: NSError?) -> Void
typealias GetExtendedProfileCompletionHandler = (
    profile: ProfileService.Containers.Profile?,
    manager: ProfileService.Containers.Profile?,
    team: OrganizationService.Containers.Team?,
    address: OrganizationService.Containers.Address?,
    interests: Array<ProfileService.Containers.Tag>?,
    notes: Array<NoteService.Containers.Note>?,
    identities: Array<UserService.Containers.Identity>?,
    resume: ResumeService.Containers.Resume?,
    location: OrganizationService.Containers.Location?,
    error: NSError?
) -> Void
typealias GetTagsCompletionHandler = (interests: Array<ProfileService.Containers.Tag>?, error: NSError?) -> Void
typealias UpdateProfileCompletionHandler = (profile: ProfileService.Containers.Profile?, error: NSError?) -> Void
typealias AddTagsCompletionHandler = (error: NSError?) -> Void

extension ProfileService {
    class Actions {
        
        private class func getProfile(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfileCompletionHandler?) {
            let client = ServiceClient(serviceName: "profile")
            client.callAction("get_profile", extensionField: ProfileServiceRequests_get_profile, requestBuilder: requestBuilder) {
                (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(ProfileServiceRequests_get_profile) as? ProfileService.GetProfile.Response
                completionHandler?(profile: response?.profile, error: error)
            }
        }
        
        class func getProfile(profileId: String, completionHandler: GetProfileCompletionHandler?) {
            let requestBuilder = ProfileService.GetProfile.Request.builder()
            requestBuilder.profile_id = profileId
            self.getProfile(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getProfile(#userId: String, completionHandler: GetProfileCompletionHandler?) {
            let requestBuilder = ProfileService.GetProfile.Request.builder()
            requestBuilder.user_id = userId
            self.getProfile(requestBuilder, completionHandler: completionHandler)
        }
        
        private class func getProfiles(
            requestBuilder: AbstractMessageBuilder,
            completionHandler: GetProfilesCompletionHandler?,
            paginatorBuilder: PaginatorBuilder? = nil
        ) {
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_profiles",
                extensionField: ProfileServiceRequests_get_profiles,
                requestBuilder: requestBuilder,
                paginatorBuilder: paginatorBuilder
            ) {
                (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    ProfileServiceRequests_get_profiles
                ) as? ProfileService.GetProfiles.Response
                let nextRequest = wrapped?.getNextRequest()
                completionHandler?(profiles: response?.profiles, nextRequest: nextRequest, error: error)
            }
        }
        
        class func getProfiles(
            teamId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetProfilesCompletionHandler?
        ) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.team_id = teamId
            self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
        }
        
        class func getProfiles(
            #organizationId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetProfilesCompletionHandler?
        ) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.organization_id = organizationId
            self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
        }
        
        class func getProfiles(
            #interestId: String,
            organizationId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetProfilesCompletionHandler?
        ) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.tag_id = interestId
            requestBuilder.organization_id = organizationId
            self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
        }
        
        class func getProfiles(
            #addressId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetProfilesCompletionHandler?
        ) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.address_id = addressId
            self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
        }
        
        class func getProfiles(
            #locationId: String,
            paginatorBuilder: PaginatorBuilder? = nil,
            completionHandler: GetProfilesCompletionHandler?
        ) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.location_id = locationId
            self.getProfiles(requestBuilder, completionHandler: completionHandler, paginatorBuilder: paginatorBuilder)
        }
        
        class func getExtendedProfile(profileId: String, completionHandler: GetExtendedProfileCompletionHandler?) {
            let requestBuilder = ProfileService.GetExtendedProfile.Request.builder()
            requestBuilder.profile_id = profileId
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_extended_profile",
                extensionField: ProfileServiceRequests_get_extended_profile,
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    ProfileServiceRequests_get_extended_profile
                ) as? ProfileService.GetExtendedProfile.Response
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
        
        class func getTags(organizationId: String, completionHandler: GetTagsCompletionHandler?) {
            let requestBuilder = ProfileService.GetTags.Request.builder()
            requestBuilder.organization_id = organizationId
            requestBuilder.tag_type = .Interest
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_tags",
                extensionField: ProfileServiceRequests_get_tags,
                requestBuilder: requestBuilder
            ) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(ProfileServiceRequests_get_tags) as? ProfileService.GetTags.Response
                completionHandler?(interests: response?.tags, error: error)
            }
        }
        
        class func getActiveTags(organizationId: String, completionHandler: GetTagsCompletionHandler?) {
            let requestBuilder = ProfileService.GetActiveTags.Request.builder()
            requestBuilder.organization_id = organizationId
            requestBuilder.tag_type = .Interest
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_active_tags",
                extensionField: ProfileServiceRequests_get_active_tags,
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        ProfileServiceRequests_get_active_tags
                    ) as? ProfileService.GetActiveTags.Response
                    completionHandler?(interests: response?.tags, error: error)
            }
        }
        
        class func updateProfile(profile: ProfileService.Containers.Profile, completionHandler: UpdateProfileCompletionHandler?) {
            let requestBuilder = ProfileService.UpdateProfile.Request.builder()
            requestBuilder.profile = profile
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "update_profile",
                extensionField: ProfileServiceRequests_update_profile,
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    let response = wrapped?.response?.result.getExtension(
                        ProfileServiceRequests_update_profile
                    ) as? ProfileService.UpdateProfile.Response
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
        
        class func addTags(profileId: String, interests: Array<ProfileService.Containers.Tag>, completionHandler: AddTagsCompletionHandler?) {
            let requestBuilder = ProfileService.AddTags.Request.builder()
            requestBuilder.profile_id = profileId
            requestBuilder.tags = interests
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "add_tags",
                extensionField: ProfileServiceRequests_add_tags,
                requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                    // DWM - Discuss with Michael
                    // TODO: Either check for no errors or pass than along in the userInfo
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(
                            ProfileServiceNotifications.onProfileUpdatedNotification,
                            object: nil
                        )
                    })
                    let response = wrapped?.response?.result.getExtension(ProfileServiceRequests_add_tags) as? ProfileService.AddTags.Response
                    completionHandler?(error: error)
            }
        }
    }
}
