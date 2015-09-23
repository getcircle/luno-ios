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
    peers: Array<Services.Profile.Containers.ProfileV1>?,
    directReports: Array<Services.Profile.Containers.ProfileV1>?,
    team: Services.Organization.Containers.TeamV1?,
    managesTeam: Services.Organization.Containers.TeamV1?,
    locations: Array<Services.Organization.Containers.LocationV1>?,
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
        let requestBuilder = Services.Profile.Actions.GetProfile.RequestV1.Builder()
        requestBuilder.profileId = profileId
        self.getProfile(requestBuilder, completionHandler: completionHandler)
    }
    
    static func getProfile(completionHandler: GetProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetProfile.RequestV1.Builder()
        self.getProfile(requestBuilder, completionHandler: completionHandler)
    }
    
    private static func getProfiles(
        requestBuilder: AbstractMessageBuilder,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
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
        managerId managerId: String,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
        requestBuilder.managerId = managerId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }

    static func getProfiles(
        teamId: String,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
        requestBuilder.teamId = teamId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        organizationId organizationId: String,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        tagId tagId: String,
        organizationId: String,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
        requestBuilder.tagId = tagId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getProfiles(
        locationId locationId: String,
        paginatorBuilder: Soa.PaginatorV1.Builder? = nil,
        completionHandler: GetProfilesCompletionHandler?
    ) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
        requestBuilder.locationId = locationId
        self.getProfiles(requestBuilder, paginatorBuilder: paginatorBuilder, completionHandler: completionHandler)
    }
    
    static func getExtendedProfile(profileId: String, completionHandler: GetExtendedProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetExtendedProfile.RequestV1.Builder()
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
                peers: response?.peers,
                directReports: response?.directReports,
                team: response?.team,
                managesTeam: response?.managesTeam,
                locations: response?.locations,
                error: error
            )
        }
    }
    
    static func getTags(organizationId: String, tagType: Services.Profile.Containers.TagV1.TagTypeV1?, completionHandler: GetTagsCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.GetTags.RequestV1.Builder()
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
    

    static func updateProfile(profile: Services.Profile.Containers.ProfileV1, completionHandler: UpdateProfileCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.UpdateProfile.RequestV1.Builder()
        requestBuilder.profile = profile
        
        let client = ServiceClient(serviceName: "profile")
        client.callAction(
            "update_profile",
            extensionField: Services.Registry.Requests.Profile.updateProfile(),
            requestBuilder: requestBuilder) { (_, _, wrapped, error) -> Void in
                let response = wrapped?.response?.result.getExtension(
                    Services.Registry.Responses.Profile.updateProfile()
                ) as? Services.Profile.Actions.UpdateProfile.ResponseV1
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
        let requestBuilder = Services.Profile.Actions.AddTags.RequestV1.Builder()
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
                wrapped?.response?.result.getExtension(Services.Registry.Responses.Profile.addTags())
                completionHandler?(error: error)
        }
    }
    
    static func removeTags(profileId: String, tags: Array<Services.Profile.Containers.TagV1>, completionHandler: RemoveTagsCompletionHandler?) {
        let requestBuilder = Services.Profile.Actions.RemoveTags.RequestV1.Builder()
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
                wrapped?.response?.result.getExtension(Services.Registry.Responses.Profile.removeTags())
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
    
    func getFormattedHireDate() -> String? {
        if hasHireDate && hireDate.trimWhitespace() != "" {
            if let hireDate = hireDate.toDate(), organization = AuthViewController.getLoggedInUserOrganization() {

                // Hyphen
                var formattedHireDate = ["\u{2013} at " + organization.name + " for"]
                
                let today = NSDate()
                if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
                    let unitFlags = [.Day, .Year, .Month] as NSCalendarUnit
                    let diffComponents = calendar.components(
                        unitFlags,
                        fromDate: hireDate,
                        toDate: today,
                        options: []
                    )
                    
                    // Only show year if its greater than a month
                    if diffComponents.year == 1 {
                        formattedHireDate.append(
                            NSLocalizedString("1 year", comment: "String indicating duration of 1 year")
                        )
                    }
                    else if diffComponents.year > 1 {
                        formattedHireDate.append(NSString(
                                format: NSLocalizedString("%d years", comment: "String indicating duration of %d years"),
                                diffComponents.year
                            ) as String
                        )
                    }
                    
                    // Show months between 1 to 3 years
                    if (diffComponents.year == 0 || diffComponents.year < 3) && diffComponents.month > 0 {
                        if diffComponents.month == 1 {
                            formattedHireDate.append(
                                NSLocalizedString("1 month", comment: "String indicating duration of 1 month")
                            )
                        }
                        else if diffComponents.month < 12 {
                            formattedHireDate.append(NSString(
                                    format: NSLocalizedString("%d months", comment: "String indicating duration of %d months"),
                                    diffComponents.month
                                ) as String
                            )
                        }
                    }
                    
                    // Show "New at company. Say hi!" for seven days 
                    // and then duration in weeks
                    if diffComponents.month == 0 && diffComponents.year == 0 {
                        print(diffComponents.day)
                        if diffComponents.day < 7 {
                            formattedHireDate = ["\u{2B50} New at " + organization.name + ". Say hi!"]
                        }
                        else if diffComponents.day / 7 == 1 {
                            formattedHireDate.append(
                                NSLocalizedString("1 week", comment: "String indicating duration of 1 week")
                            )
                        }
                        else {
                            formattedHireDate.append(NSString(
                                    format: NSLocalizedString("%d weeks", comment: "String indicating duration of %d weeks"),
                                    diffComponents.day / 7
                                ) as String
                            )
                        }
                    }
                    
                    return formattedHireDate.joinWithSeparator(" ")
                }
            }
        }
        
        return nil
    }    
}
