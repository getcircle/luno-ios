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
    
    func repopulate() {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            ProfileService.Actions.getProfiles(organizationId: currentProfile.organization_id) { (profiles, error) -> Void in
                self.update(profiles: profiles, teams: nil, addresses: nil, tags: nil)
            }
            
            ProfileService.Actions.getTags(currentProfile.organization_id) { (tags, error) -> Void in
                self.update(profiles: nil, teams: nil, addresses: nil, tags: tags)
            }
            
            OrganizationService.Actions.getAddresses(currentProfile.organization_id) { (addresses, error) -> Void in
                self.update(profiles: nil, teams: nil, addresses: addresses, tags: nil)
            }
            
            OrganizationService.Actions.getTeams(currentProfile.organization_id) { (teams, error) -> Void in
                self.update(profiles: nil, teams: teams, addresses: nil, tags: nil)
            }
        }
    }
    
    func update(
        profiles profilesToUpdate: Array<ProfileService.Containers.Profile>?,
        teams teamsToUpdate: Array<OrganizationService.Containers.Team>?,
        addresses addressesToUpdate: Array<OrganizationService.Containers.Address>?,
        tags tagsToUpdate: Array<ProfileService.Containers.Tag>?
    ) {
        if let containers = profilesToUpdate {
            var cache = profiles as [String: GeneratedMessage]
            updateCache(&cache, containers: containers as [GeneratedMessage])
            profiles = cache as [String: ProfileService.Containers.Profile]
        }
        
        if let containers = teamsToUpdate {
            var cache = teams as [String: GeneratedMessage]
            updateCache(&cache, containers: containers as [GeneratedMessage])
            teams = cache as [String: OrganizationService.Containers.Team]
        }
        
        if let containers = addressesToUpdate {
            var cache = addresses as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            addresses = cache as [String: OrganizationService.Containers.Address]
        }
        
        if let containers = tagsToUpdate {
            var cache = tags as [String: GeneratedMessage]
            updateCache(&cache, containers: containers)
            tags = cache as [String: ProfileService.Containers.Tag]
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