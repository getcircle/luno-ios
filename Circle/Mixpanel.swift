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
            "environemnt": ServiceHttpRequest.environment.name
        ])
        if let user = AuthViewController.getLoggedInUser() {
            identifyUser(user, newUser: false)
            registerSuperPropertiesForUser(user)
        }
        if let profile = AuthViewController.getLoggedInUserProfile() {
            registerSuperPropertiesForProfile(profile)
        }
    }
    
    class func registerSuperPropertiesForUser(user: UserService.Containers.User) {
        Mixpanel.sharedInstance().registerSuperPropertiesOnce(["user_id": user.id])
    }
    
    class func registerSuperPropertiesForProfile(profile: ProfileService.Containers.Profile) {
        Mixpanel.sharedInstance().registerSuperPropertiesOnce([
            "profile_id": profile.id,
            "organization_id": profile.organization_id,
        ])
    }
    
    class func identifyUser(user: UserService.Containers.User, newUser: Bool) {
        let mixpanel = Mixpanel.sharedInstance()
        if newUser {
            mixpanel.createAlias(user.id, forDistinctID: mixpanel.distinctId)
            mixpanel.identify(mixpanel.distinctId)
        } else {
            mixpanel.identify(user.id)
        }
    }
    
}
