//
//  Tracker.swift
//  Circle
//
//  Created by Michael Hahn on 2/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import Mixpanel

class TrackerProperty {
    
    enum Key: String {
        case Source = "source"
        case Destination = "destination"
        case ActiveViewController = "active_vc"
        case SourceOverviewType = "source_overview_type"
        case SourceDetailType = "source_detail_type"
        case DestinationOverviewType = "destination_overview_type"
        case DestinationDetailType = "destination_detail_type"
    }
    
    enum OverviewType: String {
        case Groups = "Groups"
        case Locations = "Locations"
        case Profiles = "Profiles"
        case Teams = "Teams"
        case Tags = "Tags"
    }
    
    enum DetailType: String {
        case Group = "Group"
        case Location = "Location"
        case Profile = "Profile"
        case Team = "Team"
        case Tag = "Tag"
    }
    
    var key: String
    var value: AnyObject?
    
    init(key: String?, value withValue: AnyObject?) {
        self.key = key!
        value = withValue
    }
    
    func withValue(withValue: AnyObject) -> TrackerProperty {
        value = withValue
        return self
    }

    func withString(withValue: String) -> TrackerProperty {
        value = withValue
        return self
    }
    
    static func withKey(key: Key) -> TrackerProperty {
        return TrackerProperty(key: key.rawValue, value: nil)
    }
    
    static func withKeyString(key: String) -> TrackerProperty {
        return TrackerProperty(key: key, value: nil)
    }
    
    static func withDestinationId(key: String) -> TrackerProperty {
        return TrackerProperty(key: "destination_\(key)", value: nil)
    }
}

class Tracker {
    
    enum Event: String {
        case PageView = "PageView"
    }

    class var sharedInstance: Tracker {
        struct Singleton {
            static let instance = Tracker()
        }
        return Singleton.instance
    }
    
    func trackSessionStart() {
    }
    
    func trackSessionEnd() {
    }
    
    func track(event: Event) {
        Mixpanel.sharedInstance().track(event.rawValue)
    }
    
    func track(event: Event, properties withProperties: [TrackerProperty]?) {
        Mixpanel.sharedInstance().track(event.rawValue, properties: trackerPropertiesAsDict(withProperties))
    }

    private func trackerPropertiesAsDict(properties: [TrackerProperty]?) -> [String: AnyObject] {
        var output = [String: AnyObject]()
        if let properties = properties {
            for property in properties {
                output[property.key] = property.value
            }
        }
        return output
    }
    
}
