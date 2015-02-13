//
//  Tracker.swift
//  Circle
//
//  Created by Michael Hahn on 2/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

enum TrackingEvent: String {
    case UserSession = "User Session"
    case UserLogin = "User Login"
    case UserSignup = "User Signup"
    case MainTabSelected = "Main Tab Selected"
    case HomeViewScrolled = "Home View Scrolled"
    case OrganizationViewScrolled = "Organization View Scrolled"
    case CardHeaderTapped = "Card Header Tapped"
}

enum TrackerSources {
    case MainTabHome
    case MainTabOrganization
    case MainTabProfile
    case MainTabUnknown
    case HomeView
    
    var name: String {
        switch self {
        case .MainTabHome: return "MainTab:Home:SearchViewController"
        case .MainTabProfile: return "MainTab:Profile:ProfileDetailsViewController"
        case .MainTabOrganization: return "MainTab:Organization:OrganizationDetailViewController"
        case .MainTabUnknown: return "MainTab:Unknown"
        case .HomeView: return "HomeView:SearchViewController"
        }
    }
}

enum TrackScrollDirection {
    case Vertical
    case Horizontal
}

class Tracker {
    
    private var majorScrollEvents = [String: CGFloat]()
    
    class var sharedInstance: Tracker {
        struct Singleton {
            static let instance = Tracker()
        }
        return Singleton.instance
    }
    
    func trackSessionStart() {
        Mixpanel.sharedInstance().timeEvent(TrackingEvent.UserSession.rawValue)
    }
    
    func trackSessionEnd() {
        Mixpanel.sharedInstance().track(TrackingEvent.UserSession.rawValue)
    }
    
    func track(event: String, properties: [String: AnyObject]?) {
        Mixpanel.sharedInstance().track(event, properties: properties)
    }
    
    func track(event: String) {
        Mixpanel.sharedInstance().track(event)
    }
    
    func track(event: TrackingEvent) {
        track(event.rawValue)
    }
    
    func track(event: TrackingEvent, properties: [String: AnyObject]?) {
        Mixpanel.sharedInstance().track(event.rawValue, properties: properties)
    }
    
    func trackMajorScrollEvents(
        event: String,
        scrollView: UIScrollView,
        direction: TrackScrollDirection,
        properties withProperties: [String: AnyObject]?
    ) {
        var scrollPercent: CGFloat
        switch direction {
        case .Vertical:
            scrollPercent = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frameHeight) * 100
        case .Horizontal:
            scrollPercent = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frameWidth) * 100
        }
        if floor(scrollPercent % 25) <= 1 {
            if let lastTracked = majorScrollEvents[event] {
                if abs(lastTracked - scrollPercent) < 25 {
                    return
                }
            }
            
            majorScrollEvents[event] = scrollPercent
            var properties = [String: AnyObject]()
            if withProperties != nil {
                properties = withProperties!
            }
            properties["scroll_percent"] = floor(scrollPercent)
            track(event, properties: properties)
        }
    }
    
}