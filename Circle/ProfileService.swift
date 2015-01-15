//
//  ProfileService.swift
//  Circle
//
//  Created by Michael Hahn on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetProfileCompletionHandler = (profile: ProfileService.Containers.Profile?, error: NSError?) -> Void
typealias GetProfilesCompletionHandler = (profiles: Array<ProfileService.Containers.Profile>?, error: NSError?) -> Void
typealias GetExtendedProfileCompletionHandler = (
    profile: ProfileService.Containers.Profile?,
    manager: ProfileService.Containers.Profile?,
    team: OrganizationService.Containers.Team?,
    address: OrganizationService.Containers.Address?,
    error: NSError?
) -> Void
typealias GetTagsCompletionHandler = (tags: Array<ProfileService.Containers.Tag>?, error: NSError?) -> Void
typealias UpdateProfileCompletionHandler = (profile: ProfileService.Containers.Profile?, error: NSError?) -> Void

extension ProfileService {
    class Actions {
        
        private class func getProfile(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfileCompletionHandler) {
            let client = ServiceClient(serviceName: "profile")
            client.callAction("get_profile", extensionField: ProfileServiceRequests_get_profile, requestBuilder: requestBuilder) {
                (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(ProfileServiceRequests_get_profile) as? ProfileService.GetProfile.Response
                completionHandler(profile: response?.profile, error: error)
            }
        }
        
        class func getProfile(profileId: String, completionHandler: GetProfileCompletionHandler) {
            let requestBuilder = ProfileService.GetProfile.Request.builder()
            requestBuilder.profile_id = profileId
            self.getProfile(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getProfile(#userId: String, completionHandler: GetProfileCompletionHandler) {
            let requestBuilder = ProfileService.GetProfile.Request.builder()
            requestBuilder.user_id = userId
            self.getProfile(requestBuilder, completionHandler: completionHandler)
        }
        
        private class func getProfiles(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfilesCompletionHandler) {
            let client = ServiceClient(serviceName: "profile")
            client.callAction("get_profiles", extensionField: ProfileServiceRequests_get_profiles, requestBuilder: requestBuilder) {
                (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(ProfileServiceRequests_get_profiles) as? ProfileService.GetProfiles.Response
                completionHandler(profiles: response?.profiles, error: error)
            }
        }
        
        class func getProfiles(teamId: String, completionHandler: GetProfilesCompletionHandler) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.team_id = teamId
            self.getProfiles(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getProfiles(#organizationId: String, completionHandler: GetProfilesCompletionHandler) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.organization_id = organizationId
            self.getProfiles(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getExtendedProfile(profileId: String, completionHandler: GetExtendedProfileCompletionHandler) {
            let requestBuilder = ProfileService.GetExtendedProfile.Request.builder()
            requestBuilder.profile_id = profileId
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_extended_profile",
                extensionField: ProfileServiceRequests_get_extended_profile,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    ProfileServiceRequests_get_extended_profile
                ) as? ProfileService.GetExtendedProfile.Response
                completionHandler(
                    profile: response?.profile,
                    manager: response?.manager,
                    team: response?.team,
                    address: response?.address,
                    error: error
                )
            }
        }
        
        class func getTags(organizationId: String, completionHandler: GetTagsCompletionHandler) {
            let requestBuilder = ProfileService.GetTags.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_tags",
                extensionField: ProfileServiceRequests_get_tags,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(ProfileServiceRequests_get_tags) as? ProfileService.GetTags.Response
                completionHandler(tags: response?.tags, error: error)
            }
        }
        
        class func updateProfile(profile: ProfileService.Containers.Profile, completionHandler: UpdateProfileCompletionHandler) {
            let requestBuilder = ProfileService.UpdateProfile.Request.builder()
            requestBuilder.profile = profile
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "update_profile",
                extensionField: ProfileServiceRequests_update_profile,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        ProfileServiceRequests_update_profile
                    ) as? ProfileService.UpdateProfile.Response
                    completionHandler(profile: response?.profile, error: error)
            }
        }
        
    }
}
