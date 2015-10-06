//
//  Tracker.swift
//  Luno
//
//  Created by Ravi Rani on 10/5/2015.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import Foundation
import UIKit
import Mixpanel

struct TrackerProperty {
    
    enum PageType: String {
        // Global
        case Home = "Home"
        case Settings = "Settings"
        case SettingsPasscodeTouchId = "Settings - Passcode & Touch ID"
        
        // Detail
        case LocationDetail = "Location Detail"
        case ProfileDetail = "Profile Detail"
        case TeamDetail = "Team Detail"
        
        // Lists
        case DirectReports = "Direct Reports"
        case LocationMembers = "Location Members"
        case LocationPointOfContact = "Location Points of Contact"
        case Peers = "Peers"
        case TeamMembers = "Team Members"
        case TeamSubTeams = "Team Sub-Teams"
        
        // Editable forms
        case EditProfile = "Edit Profile"
        case EditTeam = "Edit Team"
    }
}

/*
   This class acts as a wrapper for our mixpanel implementation.
   It is named generically such that there are no conflicts with the libraries.

   ASSUMPTION: It assumes the needed libraries (Mixpanel in this case) has been globally
   instantiated and will be present before any call to this class is made.

   CONVENTIIONS:
   - All event tracking methods are named as track{Event in present tense}.
     Its best to imagine a suffix Event when trying to name these.

   NOTE:
   The entire implementation here SHOULD be keept in sync with the spec.
   @see https://docs.google.com/a/lunohq.com/spreadsheets/d/1_UrLo5KccI9pcJ8p5K--9URwOmcZwE4W2uVc5F3B5sA/edit?usp=sharing
*/
class Tracker {
    
    enum Event: String {
        case ContactTap = "Contact Tap"
        case PageView = "Page View"
        case ProfileUpdate = "Profile Update"
        case SearchResultTap = "Search Result Tap"
        case SearchStart = "Search Start"
        case TeamUpdate = "Team Update"
    }

    class var sharedInstance: Tracker {
        struct Singleton {
            static let instance = Tracker()
        }
        return Singleton.instance
    }

    var sessionInitialized = false
    
    // Call when the app comes to foreground and
    // when a user logs in
    func initSession() {
        if let  profile = AuthenticationViewController.getLoggedInUserProfile(),
                organization = AuthenticationViewController.getLoggedInUserOrganization(),
                mixpanel = Mixpanel.sharedInstance() {

            // Set the session ID
            mixpanel.identify(profile.userId)

            // Init properties for the user
            mixpanel.people.set([
                "$first_name": profile.firstName,
                "Organization ID": profile.organizationId,
                "Organization Domain": organization.domain.lowercaseString,
                "Profile ID": profile.id,
                "Title": profile.title,
                "User ID": profile.userId,
            ])

            // Register super properties
            mixpanel.registerSuperProperties([
                "Organization ID": profile.organizationId,
                "Organization Domain": organization.domain.lowercaseString,
                "Profile ID": profile.id,
                "User ID": profile.userId,
            ])
            
            sessionInitialized = true
        }
    }
    
    // Call on logout
    func clearSession() {
        if sessionInitialized {
            Mixpanel.sharedInstance().clearSuperProperties()
            Mixpanel.sharedInstance().reset()
        }
    }

    private func track(event: Event, properties withProperties: [String: AnyObject]) {
        if sessionInitialized {
            Mixpanel.sharedInstance().track(
                event.rawValue,
                properties: withProperties
            )
            
            if event == .PageView {
                Mixpanel.sharedInstance().people.increment("Mobile Page Views", by: NSNumber(integer: 1))
            }
        }
    }

    // Track Page View
    /*
        Page views is the event name we are using to keep things consistent with the web.
        A page view is defined as a distinct section of content that is loaded separately and
        for which a user has to take some action like a tap to see it.
        
        We also need to ensure we use the right signals from each platform. For e.g., iOS
        by its design is hierarchial and users have to go back to start on a new action. To account
        for this and to be as close to the web as possible, page views would be triggered typically
        from the viewDidLoad method of view controllers or at the entry points when a navigation
        is being explicitly triggered.
        
        For views that are always in the memory, for e.g., the views that are part of the tab
        bar controller, we can track the explicit action user takes to visit them.
        
        For our implementation, we are explicitly only tracking taps to the Search or Home 
        view and ignoring user's own profile visit. That is to not inflate profile detail
        views overall across web and mobile. In comparison, Home is the default view and
        is likely to get ignored anyways, but tracking it at the tab level allows us
        to track funnels correctly.
    */
    func trackPageView(pageType pageType: TrackerProperty.PageType, pageId: String? = nil) {
        var properties = [
            "Page Type": pageType.rawValue,
        ]
        
        if let pageId = pageId {
            properties["Page ID"] = pageId
        }

        track(.PageView, properties: properties)
    }
}
