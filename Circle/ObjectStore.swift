//
//  Store.swift
//  Circle
//
//  Created by Michael Hahn on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class ObjectStore {
    
    enum ObjectType {
        case Profile
        case Team
        case Address
        case Interest
        case Skill
        case ActiveInterest
        case ActiveSkill
    }
    
    class Objects {
        var profiles: Array<Services.Profile.Containers.ProfileV1>?
        var teams: Array<Services.Organization.Containers.TeamV1>?
        var addresses: Array<Services.Organization.Containers.AddressV1>?
        var interests: Array<Services.Profile.Containers.TagV1>?
        var skills: Array<Services.Profile.Containers.TagV1>?
        var activeInterests: Array<Services.Profile.Containers.TagV1>?
        var activeSkills: Array<Services.Profile.Containers.TagV1>?
        var locations: Array<Services.Organization.Containers.LocationV1>?
    }
    
    class var sharedInstance: ObjectStore {
        struct Static {
            static let instance = ObjectStore()
        }
        return Static.instance
    }
    
    private(set) var profiles = Dictionary<String, Services.Profile.Containers.ProfileV1>()
    private(set) var teams = Dictionary<String, Services.Organization.Containers.TeamV1>()
    private(set) var addresses = Dictionary<String, Services.Organization.Containers.AddressV1>()
    private(set) var locations = Dictionary<String, Services.Organization.Containers.LocationV1>()
    private(set) var interests = Dictionary<String, Services.Profile.Containers.TagV1>()
    private(set) var skills = Dictionary<String, Services.Profile.Containers.TagV1>()
    private(set) var activeInterests = Dictionary<String, Services.Profile.Containers.TagV1>()
    private(set) var activeSkills = Dictionary<String, Services.Profile.Containers.TagV1>()
    
    func repopulate() {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            dispatch_async(GlobalUserInitiatedQueue, { () -> Void in
                self.repopulate(currentProfile)
            })
        }
    }
    
    private func repopulate(profile: Services.Profile.Containers.ProfileV1) {
        let objects = Objects()
        let paginatorBuilder = Soa.PaginatorV1.builder()
        paginatorBuilder.pageSize = 5000
        
        Services.Profile.Actions.getProfiles(
            organizationId: profile.organizationId,
            paginatorBuilder: paginatorBuilder
            ) { (profiles, _, error) -> Void in
                objects.profiles = profiles
                self.update(objects)
        }
        
        // Get and categorize tags
        Services.Profile.Actions.getTags(profile.organizationId, tagType: nil) { (tags, error) -> Void in
            objects.interests = tags?.filter { $0.tagType == .Interest }
            objects.skills = tags?.filter { $0.tagType == .Skill }
            self.update(objects)
        }
        Services.Profile.Actions.getActiveTags(
            profile.organizationId,
            tagType: nil,
            paginatorBuilder: paginatorBuilder,
            completionHandler: { (tags, error) -> Void in
                objects.activeInterests = tags?.filter { $0.tagType == .Interest }
                objects.activeSkills = tags?.filter { $0.tagType == .Skill }
                self.update(objects)
            }
        )
        
        Services.Organization.Actions.getAddresses(profile.organizationId) { (addresses, error) -> Void in
            objects.addresses = addresses
            self.update(objects)
        }
        
        Services.Organization.Actions.getTeams(profile.organizationId, paginatorBuilder: paginatorBuilder) { (teams, _, error) -> Void in
            objects.teams = teams
            self.update(objects)
        }
        
        Services.Organization.Actions.getLocations(profile.organizationId) { (locations, error) -> Void in
            objects.locations = locations
            self.update(objects)
        }
    }
    
    func update(objects: Objects) {
        if let containers = objects.profiles {
            var cache = profiles as [String: GeneratedMessage]
            updateCache(&cache, containers: (containers as [GeneratedMessage]))
            profiles = cache as! [String: Services.Profile.Containers.ProfileV1]
        }
        
        if let containers = objects.teams {
            var cache = teams as [String: GeneratedMessage]
            updateCache(&cache, containers: containers as [GeneratedMessage])
            teams = cache as! [String: Services.Organization.Containers.TeamV1]
        }
        
        if let containers = objects.addresses {
            var cache = addresses as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            addresses = cache as! [String: Services.Organization.Containers.AddressV1]
        }
        
        if let containers = objects.locations {
            var cache = locations as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            locations = cache as! [String: Services.Organization.Containers.LocationV1]
        }
        
        if let containers = objects.interests {
            var cache = interests as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            interests = cache as! [String: Services.Profile.Containers.TagV1]
        }
        
        if let containers = objects.skills {
            var cache = skills as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            skills = cache as! [String: Services.Profile.Containers.TagV1]
        }
        
        if let containers = objects.activeInterests {
            var cache = activeInterests as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            activeInterests = cache as! [String: Services.Profile.Containers.TagV1]
        }
        
        if let containers = objects.activeSkills {
            var cache = activeSkills as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            activeSkills = cache as! [String: Services.Profile.Containers.TagV1]
        }
    }
    
    func update(object: AnyObject?, type: ObjectType) {
        let objects = Objects()
        switch type {
        case .Profile:
            if let profile = object as? Services.Profile.Containers.ProfileV1 {
                objects.profiles = [profile]
            }
        case .Team:
            if let team = object as? Services.Organization.Containers.TeamV1 {
                objects.teams = [team]
            }
        case .Address:
            if let address = object as? Services.Organization.Containers.AddressV1 {
                objects.addresses = [address]
            }
        case .Interest:
            if let interest = object as? Services.Profile.Containers.TagV1 {
                objects.interests = [interest]
            }
        case .Skill:
            if let skill = object as? Services.Profile.Containers.TagV1 {
                objects.skills = [skill]
            }
        case .ActiveInterest:
            if let interest = object as? Services.Profile.Containers.TagV1 {
                objects.activeInterests = [interest]
            }
        case .ActiveSkill:
            if let skill = object as? Services.Profile.Containers.TagV1 {
                objects.activeSkills = [skill]
            }
        }
        update(objects)
    }
    
    func reset(sender: AnyObject!) {
        profiles.removeAll(keepCapacity: false)
        addresses.removeAll(keepCapacity: false)
        teams.removeAll(keepCapacity: false)
        interests.removeAll(keepCapacity: false)
        skills.removeAll(keepCapacity: false)
        activeInterests.removeAll(keepCapacity: false)
        activeSkills.removeAll(keepCapacity: false)
        locations.removeAll(keepCapacity: false)
    }
    
    func getProfilesForAttribute(attribute: Services.Search.Containers.Search.AttributeV1, value: AnyObject) -> Array<Services.Profile.Containers.ProfileV1> {
        return ObjectStore.sharedInstance.profiles.values.array.filter {
            switch attribute {
            case .LocationId:
                if let locationId = value as? String {
                    return $0.locationId == locationId
                }
                return false
            case .OrganizationId:
                if let organizationId = value as? String {
                    return $0.organizationId == organizationId
                }
                return false
            default: return false
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateCache(inout cache: [String: GeneratedMessage], containers: Array<GeneratedMessage>) {
        for container in containers {
            var identifier = container["id"] as! String
            cache[identifier] = container
        }
    }

}
