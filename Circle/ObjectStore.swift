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
        case Tag
        case ActiveTag
    }
    
    class Objects {
        var profiles: Array<ProfileService.Containers.Profile>?
        var teams: Array<OrganizationService.Containers.Team>?
        var addresses: Array<OrganizationService.Containers.Address>?
        var tags: Array<ProfileService.Containers.Tag>?
        var activeTags: Array<ProfileService.Containers.Tag>?
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
    private(set) var tags = Dictionary<String, ProfileService.Containers.Tag>()
    private(set) var activeTags = Dictionary<String, ProfileService.Containers.Tag>()
    
    func repopulate() {
        let objects = Objects()
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            ProfileService.Actions.getProfiles(organizationId: currentProfile.organization_id) { (profiles, error) -> Void in
                objects.profiles = profiles
                self.update(objects)
            }
            
            ProfileService.Actions.getTags(currentProfile.organization_id) { (tags, error) -> Void in
                objects.tags = tags
                self.update(objects)
            }
            
            OrganizationService.Actions.getAddresses(currentProfile.organization_id) { (addresses, error) -> Void in
                objects.addresses = addresses
                self.update(objects)
            }
            
            OrganizationService.Actions.getTeams(currentProfile.organization_id) { (teams, error) -> Void in
                objects.teams = teams
                self.update(objects)
            }
            
            ProfileService.Actions.getActiveTags(currentProfile.organization_id) { (tags, error) -> Void in
                objects.tags = tags
                objects.activeTags = tags
                self.update(objects)
            }
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
        
        if let containers = objects.tags {
            var cache = tags as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            tags = cache as [String: ProfileService.Containers.Tag]
        }
        
        if let containers = objects.activeTags {
            var cache = activeTags as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            activeTags = cache as [String: ProfileService.Containers.Tag]
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
        case .Tag:
            if let tag = object as? ProfileService.Containers.Tag {
                objects.tags = [tag]
            }
        case .ActiveTag:
            if let tag = object as? ProfileService.Containers.Tag {
                objects.tags = [tag]
                objects.activeTags = [tag]
            }
        }
        update(objects)
    }
    
    func reset(sender: AnyObject!) {
        profiles.removeAll(keepCapacity: false)
        addresses.removeAll(keepCapacity: false)
        teams.removeAll(keepCapacity: false)
        tags.removeAll(keepCapacity: false)
        activeTags.removeAll(keepCapacity: false)
    }
    
    // MARK: - Helpers
    
    private func updateCache(inout cache: [String: GeneratedMessage], containers: Array<GeneratedMessage>) {
        for container in containers {
            var identifier = container["id"] as String
            cache[identifier] = container
        }
    }

}