//
//  Tracker.swift
//  Circle
//
//  Created by Michael Hahn on 2/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

let UserSessionTrackingKey = "User Session"
let UserLoginTrackingKey = "User Login"
let UserSignupTrackingKey = "User Signup"

let MainTabSelectedTrackingKey = "Main Tab Selected"

enum TrackerSources {
    case MainTabHome
    case MainTabOrganization
    case MainTabProfile
    case MainTabUnknown
    
    var name: String {
        switch self {
        case .MainTabHome: return "MainTab:Home:SearchViewController"
        case .MainTabProfile: return "MainTab:Profile:ProfileDetailsViewController"
        case .MainTabOrganization: return "MainTab:Organization:OrganizationDetailViewController"
        case .MainTabUnknown: return "MainTab:Unknown"
        }
    }
}

class Tracker {
    
    class var sharedInstance: Tracker {
        struct Singleton {
            static let instance = Tracker()
        }
        return Singleton.instance
    }
    
    func trackSessionStart() {
        Mixpanel.sharedInstance().timeEvent(UserSessionTrackingKey)
    }
    
    func trackSessionEnd() {
        Mixpanel.sharedInstance().track(UserSessionTrackingKey)
    }
    
    func track(event: String, properties: [String: AnyObject]) {
        Mixpanel.sharedInstance().track(event, properties: properties)
    }
    
    func track(event: String) {
        Mixpanel.sharedInstance().track(event)
    }
    
}