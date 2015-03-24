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
        case Skill
        case ActiveSkill
    }
    
    class Objects {
        var profiles: Array<ProfileService.Containers.Profile>?
        var teams: Array<OrganizationService.Containers.Team>?
        var addresses: Array<OrganizationService.Containers.Address>?
        var skills: Array<ProfileService.Containers.Skill>?
        var activeSkills: Array<ProfileService.Containers.Skill>?
        var locations: Array<OrganizationService.Containers.Location>?
    }
    
    class var sharedInstance: ObjectStore {
        struct Static {
            static let instance = ObjectStore()
        }
        return Static.instance
    }
    
    private(set) var profiles = Dictionary<String, ProfileService.Containers.Profile>()
    private(set) var teams = Dictionary<String, OrganizationService.Containers.Team>()
    private(set) var addresses = Dictionary<String, OrganizationService.Containers.Address>()
    private(set) var locations = Dictionary<String, OrganizationService.Containers.Location>()
    private(set) var skills = Dictionary<String, ProfileService.Containers.Skill>()
    private(set) var activeSkills = Dictionary<String, ProfileService.Containers.Skill>()
    
    func repopulate() {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            dispatch_async(GlobalUserInitiatedQueue, { () -> Void in
                self.repopulate(currentProfile)
            })
        }
    }
    
    private func repopulate(profile: ProfileService.Containers.Profile) {
        let objects = Objects()
        let paginatorBuilder = Paginator.builder()
        paginatorBuilder.page_size = 5000
        
        ProfileService.Actions.getProfiles(
            organizationId: profile.organization_id,
            paginatorBuilder: paginatorBuilder
            ) { (profiles, _, error) -> Void in
                objects.profiles = profiles
                self.update(objects)
        }
        
        ProfileService.Actions.getSkills(profile.organization_id) { (skills, error) -> Void in
            objects.skills = skills
            self.update(objects)
        }
        
        OrganizationService.Actions.getAddresses(profile.organization_id) { (addresses, error) -> Void in
            objects.addresses = addresses
            self.update(objects)
        }
        
        OrganizationService.Actions.getTeams(profile.organization_id, paginatorBuilder: paginatorBuilder) { (teams, _, error) -> Void in
            objects.teams = teams
            self.update(objects)
        }
        
        ProfileService.Actions.getActiveSkills(profile.organization_id) { (skills, error) -> Void in
            objects.skills = skills
            objects.activeSkills = skills
            self.update(objects)
        }
        
        OrganizationService.Actions.getLocations(profile.organization_id) { (locations, error) -> Void in
            objects.locations = locations
            self.update(objects)
        }
    }
    
    func update(objects: Objects) {
        if let containers = objects.profiles {
            var cache = profiles as [String: GeneratedMessage]
            updateCache(&cache, containers: (containers as [GeneratedMessage]))
            profiles = cache as [String: ProfileService.Containers.Profile]
        }
        
        if let containers = objects.teams {
            var cache = teams as [String: GeneratedMessage]
            updateCache(&cache, containers: containers as [GeneratedMessage])
            teams = cache as [String: OrganizationService.Containers.Team]
        }
        
        if let containers = objects.addresses {
            var cache = addresses as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            addresses = cache as [String: OrganizationService.Containers.Address]
        }
        
        if let containers = objects.locations {
            var cache = locations as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            locations = cache as [String: OrganizationService.Containers.Location]
        }
        
        if let containers = objects.skills {
            var cache = skills as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            skills = cache as [String: ProfileService.Containers.Skill]
        }
        
        if let containers = objects.activeSkills {
            var cache = activeSkills as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            activeSkills = cache as [String: ProfileService.Containers.Skill]
        }
    }
    
    func update(object: AnyObject?, type: ObjectType) {
        let objects = Objects()
        switch type {
        case .Profile:
            if let profile = object as? ProfileService.Containers.Profile {
                objects.profiles = [profile]
            }
        case .Team:
            if let team = object as? OrganizationService.Containers.Team {
                objects.teams = [team]
            }
        case .Address:
            if let address = object as? OrganizationService.Containers.Address {
                objects.addresses = [address]
            }
        case .Skill:
            if let skill = object as? ProfileService.Containers.Skill {
                objects.skills = [skill]
            }
        case .ActiveSkill:
            if let skill = object as? ProfileService.Containers.Skill {
                objects.skills = [skill]
                objects.activeSkills = [skill]
            }
        }
        update(objects)
    }
    
    func reset(sender: AnyObject!) {
        profiles.removeAll(keepCapacity: false)
        addresses.removeAll(keepCapacity: false)
        teams.removeAll(keepCapacity: false)
        skills.removeAll(keepCapacity: false)
        activeSkills.removeAll(keepCapacity: false)
        locations.removeAll(keepCapacity: false)
    }
    
    func getProfilesForAttribute(attribute: SearchService.Attribute, value: AnyObject) -> Array<ProfileService.Containers.Profile> {
        return ObjectStore.sharedInstance.profiles.values.array.filter {
            switch attribute {
            case .LocationId:
                if let location_id = value as? String {
                    return $0.location_id == location_id
                }
                return false
            case .OrganizationId:
                if let organization_id = value as? String {
                    return $0.organization_id == organization_id
                }
                return false
            default: return false
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateCache(inout cache: [String: GeneratedMessage], containers: Array<GeneratedMessage>) {
        for container in containers {
            var identifier = container["id"] as String
            cache[identifier] = container
        }
    }

}
