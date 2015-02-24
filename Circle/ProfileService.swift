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
    skills: Array<ProfileService.Containers.Skill>?,
    notes: Array<NoteService.Containers.Note>?,
    identities: Array<UserService.Containers.Identity>?,
    resume: ResumeService.Containers.Resume?,
    error: NSError?
) -> Void
typealias GetSkillsCompletionHandler = (skills: Array<ProfileService.Containers.Skill>?, error: NSError?) -> Void
typealias UpdateProfileCompletionHandler = (profile: ProfileService.Containers.Profile?, error: NSError?) -> Void
typealias AddSkillsCompletionHandler = (error: NSError?) -> Void

extension ProfileService {
    class Actions {
        
        private class func getProfile(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfileCompletionHandler?) {
            let client = ServiceClient(serviceName: "profile")
            client.callAction("get_profile", extensionField: ProfileServiceRequests_get_profile, requestBuilder: requestBuilder) {
                (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(ProfileServiceRequests_get_profile) as? ProfileService.GetProfile.Response
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
        
        private class func getProfiles(requestBuilder: AbstractMessageBuilder, completionHandler: GetProfilesCompletionHandler?) {
            let client = ServiceClient(serviceName: "profile")
            client.callAction("get_profiles", extensionField: ProfileServiceRequests_get_profiles, requestBuilder: requestBuilder) {
                (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(ProfileServiceRequests_get_profiles) as? ProfileService.GetProfiles.Response
                completionHandler?(profiles: response?.profiles, error: error)
            }
        }
        
        class func getProfiles(teamId: String, completionHandler: GetProfilesCompletionHandler?) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.team_id = teamId
            self.getProfiles(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getProfiles(#organizationId: String, completionHandler: GetProfilesCompletionHandler?) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.organization_id = organizationId
            self.getProfiles(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getProfiles(#skillId: String, organizationId: String, completionHandler: GetProfilesCompletionHandler?) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.skill_id = skillId
            requestBuilder.organization_id = organizationId
            self.getProfiles(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getProfiles(#addressId: String, completionHandler: GetProfilesCompletionHandler?) {
            let requestBuilder = ProfileService.GetProfiles.Request.builder()
            requestBuilder.address_id = addressId
            self.getProfiles(requestBuilder, completionHandler: completionHandler)
        }
        
        class func getExtendedProfile(profileId: String, completionHandler: GetExtendedProfileCompletionHandler?) {
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
                completionHandler?(
                    profile: response?.profile,
                    manager: response?.manager,
                    team: response?.team,
                    address: response?.address,
                    skills: response?.skills,
                    notes: response?.notes,
                    identities: response?.identities,
                    resume: response?.resume,
                    error: error
                )
            }
        }
        
        class func getSkills(organizationId: String, completionHandler: GetSkillsCompletionHandler?) {
            let requestBuilder = ProfileService.GetSkills.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_skills",
                extensionField: ProfileServiceRequests_get_skills,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(ProfileServiceRequests_get_skills) as? ProfileService.GetSkills.Response
                completionHandler?(skills: response?.skills, error: error)
            }
        }
        
        class func getActiveSkills(organizationId: String, completionHandler: GetSkillsCompletionHandler?) {
            let requestBuilder = ProfileService.GetActiveSkills.Request.builder()
            requestBuilder.organization_id = organizationId
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "get_active_skills",
                extensionField: ProfileServiceRequests_get_active_skills,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        ProfileServiceRequests_get_active_skills
                    ) as? ProfileService.GetActiveSkills.Response
                    completionHandler?(skills: response?.skills, error: error)
            }
        }
        
        class func updateProfile(profile: ProfileService.Containers.Profile, completionHandler: UpdateProfileCompletionHandler?) {
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
                    ObjectStore.sharedInstance.update(response?.profile, type: .Profile)
                    completionHandler?(profile: response?.profile, error: error)
            }
        }
        
        class func addSkills(profileId: String, skills: Array<ProfileService.Containers.Skill>, completionHandler: AddSkillsCompletionHandler?) {
            let requestBuilder = ProfileService.AddSkills.Request.builder()
            requestBuilder.profile_id = profileId
            requestBuilder.skills = skills
            
            let client = ServiceClient(serviceName: "profile")
            client.callAction(
                "add_skills",
                extensionField: ProfileServiceRequests_add_skills,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(ProfileServiceRequests_add_skills) as? ProfileService.AddSkills.Response
                    completionHandler?(error: error)
            }
        }
        
    }
}
