//
//  Mixpanel.swift
//  Circle
//
//  Created by Michael Hahn on 2/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Mixpanel {
    
    class func setup() {
        Mixpanel.sharedInstanceWithToken("3086517890dd4df6da6e25ef8873d4e5")
        Mixpanel.sharedInstance().registerSuperPropertiesOnce([
            "\(TrackingPrefix)environemnt": ServiceHttpRequest.environment.name
        ])
        if let user = AuthViewController.getLoggedInUser() {
            identifyUser(user, newUser: false)
            registerSuperPropertiesForUser(user)
        }
        if let profile = AuthViewController.getLoggedInUserProfile() {
            registerSuperPropertiesForProfile(profile)
        }
    }
    
    class func registerSuperPropertiesForUser(user: Services.User.Containers.UserV1) {
        Mixpanel.sharedInstance().registerSuperPropertiesOnce(["\(TrackingPrefix)userId": user.id])
    }
    
    class func registerSuperPropertiesForProfile(profile: Services.Profile.Containers.ProfileV1) {
        let mixpanel = Mixpanel.sharedInstance()
        mixpanel.registerSuperPropertiesOnce([
            "\(TrackingPrefix)profileId": profile.id,
            "\(TrackingPrefix)organizationId": profile.organizationId,
        ])
        mixpanel.people.set([
            "profileId": profile.id,
            "organizationId": profile.organizationId,
            "title": profile.title
        ])
    }
    
    class func identifyUser(user: Services.User.Containers.UserV1, newUser: Bool) {
        let mixpanel = Mixpanel.sharedInstance()
        if newUser {
            mixpanel.createAlias(user.id, forDistinctID: mixpanel.distinctId)
            mixpanel.identify(mixpanel.distinctId)
        } else {
            mixpanel.identify(user.id)
        }
        mixpanel.people.set(["userId": user.id])
    }
    
}
