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
    
    private(set) var profilesCount: Int = 0
    private(set) var teamsCount: Int = 0
    private(set) var locationsCount: Int = 0
    
    func repopulate() {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            dispatch_async(GlobalUserInitiatedQueue, { () -> Void in
                self.repopulate(currentProfile)
            })
        }
    }
    
    private func repopulate(profile: Services.Profile.Containers.ProfileV1) {
        let paginatorBuilder = Soa.PaginatorV1.builder()
        paginatorBuilder.pageSize = 10
        
        Services.Profile.Actions.getProfiles(
            organizationId: profile.organizationId,
            paginatorBuilder: paginatorBuilder
        ) { (profiles, nextRequest, error) -> Void in
            if let nextRequest = nextRequest {
                self.profilesCount = Int(nextRequest.getPaginator().count)
            }
            else {
                self.profilesCount = profiles?.count ?? 0
            }
        }
        
        Services.Organization.Actions.getTeams(
            profile.organizationId,
            paginatorBuilder: paginatorBuilder
        ) { (teams, nextRequest, error) -> Void in
            if let nextRequest = nextRequest {
                self.teamsCount = Int(nextRequest.getPaginator().count)
            }
            else {
                self.teamsCount = teams?.count ?? 0
            }
        }
        
        Services.Organization.Actions.getLocations(profile.organizationId) { (locations, error) -> Void in
            self.locationsCount = locations?.count ?? 0
        }
    }
    
    func reset(sender: AnyObject!) {
       profilesCount = 0
       teamsCount = 0
       locationsCount = 0
    }
}
