//
//  Tracker.swift
//  Circle
//
//  Created by Michael Hahn on 2/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

let TrackingPrefix = "c_"

class TrackerProperty {
    
    enum Key: String {
        case SourceViewController = "source_vc"
        case DestinationViewController = "destination_vc"
        case DestinationProfileID = "destination_profile_id"
        case ActiveViewController = "active_vc"
        case OverviewType = "overview_type"
        case DetailType = "detail_type"
    }
    
    private var internalKey: String?
    
    var key: String {
        return addPrefix(internalKey!)
    }
    var value: AnyObject?
    
    init(key: String?, value withValue: AnyObject?) {
        internalKey = key
        value = withValue
    }
    
    func withValue(withValue: AnyObject) -> TrackerProperty {
        value = withValue
        return self
    }
    
    func withSource(source: Tracker.Source) -> TrackerProperty {
        value = source.rawValue
        return self
    }
    
    func withString(withValue: String) -> TrackerProperty {
        value = withValue
        return self
    }
    
    class func withKey(key: Key) -> TrackerProperty {
        return TrackerProperty(key: key.rawValue, value: nil)
    }
    
    class func withKeyString(key: String) -> TrackerProperty {
        return TrackerProperty(key: key, value: nil)
    }
    
    private func addPrefix(value: String) -> String {
        return "\(TrackingPrefix)\(value)"
    }
    
}

class Tracker {
    
    enum Event: String {
        case UserSession = "User Session"
        case UserLogin = "User Login"
        case UserSignup = "User Signup"
        case TabSelected = "Tab Selected"
        case ViewScrolled = "View Scrolled"
        case CardHeaderTapped = "Card Header Tapped"
        case DetailItemTapped = "Detail Item Tapped"
    }
    
    enum Source: String {
        case Home = "Home"
        case Organization = "Organization"
        case UserProfile = "User Profile"
        case Profile = "Profile"
        case Overview = "Overview"
        case Detail = "Detail"
        case Unknown = "Unknown"
    }
    
    enum ScrollDirection {
        case Vertical
        case Horizontal
    }
    
    private var majorScrollEvents = [String: CGFloat]()
    
    class var sharedInstance: Tracker {
        struct Singleton {
            static let instance = Tracker()
        }
        return Singleton.instance
    }
    
    func trackSessionStart() {
        Mixpanel.sharedInstance().timeEvent(Event.UserSession.rawValue)
    }
    
    func trackSessionEnd() {
        Mixpanel.sharedInstance().track(Event.UserSession.rawValue)
    }
    
    func track(event: Event) {
        Mixpanel.sharedInstance().track(event.rawValue)
    }
    
    func track(event: Event, properties withProperties: [TrackerProperty]?) {
        Mixpanel.sharedInstance().track(event.rawValue, properties: trackerPropertiesAsDict(withProperties))
    }
    
    func trackMajorScrollEvents(
        event: Event,
        scrollView: UIScrollView,
        direction: ScrollDirection,
        properties withProperties: [TrackerProperty]?
    ) {
        var scrollPercent: CGFloat
        switch direction {
        case .Vertical:
            scrollPercent = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frameHeight) * 100
        case .Horizontal:
            scrollPercent = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frameWidth) * 100
        }
        if floor(scrollPercent % 25) <= 1 {
            if let lastTracked = majorScrollEvents[event.rawValue] {
                if abs(lastTracked - scrollPercent) < 25 {
                    return
                }
            }
            
            majorScrollEvents[event.rawValue] = scrollPercent
            var properties = [String: AnyObject]()
            if withProperties != nil {
                properties = trackerPropertiesAsDict(withProperties)
            }
            properties["\(TrackingPrefix)scroll_percent"] = floor(scrollPercent)
            Mixpanel.sharedInstance().track(event.rawValue, properties: properties)
        }
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