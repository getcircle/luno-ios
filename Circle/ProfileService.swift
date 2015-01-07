//
//  ProfileService.swift
//  Circle
//
//  Created by Michael Hahn on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension ProfileService {
    enum Requests: ServiceRequestConvertible {
        
        case GetProfile(String)
        case GetProfileForUserId(String)
        case GetExtendedProfile(String)
        case GetProfiles(String)
        
        var builder: GeneratedMessageBuilder {
            switch self {
            case .GetProfile(let profileId):
                let requestBuilder = ProfileService.GetProfile.Request.builder()
                requestBuilder.profile_id = profileId
                return requestBuilder
            case .GetProfileForUserId(let userId):
                let requestBuilder = ProfileService.GetProfile.Request.builder()
                requestBuilder.user_id = userId
                return requestBuilder
            case .GetExtendedProfile(let profileId):
                let requestBuilder = ProfileService.GetExtendedProfile.Request.builder()
                requestBuilder.profile_id = profileId
                return requestBuilder
            case .GetProfiles(let teamId):
                let requestBuilder = ProfileService.GetProfiles.Request.builder()
                requestBuilder.team_id = teamId
                return requestBuilder
            }
        }
        
        var actionName: String {
            switch self {
            case .GetProfile:
                return "get_profile"
            case .GetProfileForUserId:
                return "get_profile"
            case .GetExtendedProfile:
                return "get_extended_profile"
            case .GetProfiles:
                return "get_profiles"
            }
        }
        
        var extensionField: ConcreateExtensionField {
            switch self {
            case .GetProfile:
                return ProfileServiceRequests_get_profile
            case .GetProfileForUserId:
                return ProfileServiceRequests_get_profile
            case .GetExtendedProfile:
                return ProfileServiceRequests_get_extended_profile
            case .GetProfiles:
                return ProfileServiceRequests_get_profiles
            }
        }
    }
    
    enum Responses: ServiceResponseConvertible {
        
        case GetProfile(ActionResponse)
        case GetExtendedProfile(ActionResponse)
        case GetProfiles(ActionResponse)
        
        var success: Bool {
            switch self {
            case .GetProfile(let response):
                return response.result.success
            case .GetExtendedProfile(let response):
                return response.result.success
            case .GetProfiles(let response):
                return response.result.success
            }
        }
        
        var result: GeneratedMessage {
            switch self {
            case .GetProfile(let response):
                return response.result.getExtension(ProfileServiceRequests_get_profile) as GeneratedMessage
            case .GetExtendedProfile(let response):
                return response.result.getExtension(ProfileServiceRequests_get_extended_profile) as GeneratedMessage
            case .GetProfiles(let response):
                return response.result.getExtension(ProfileServiceRequests_get_profiles) as GeneratedMessage
            }
        }
    }

}
