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
import ProtobufRegistry

struct TrackerProperty {
    
    enum PageType: String {
        // Global
        case Home = "Home"
        case Settings = "Settings"
        case SettingsPasscodeTouchId = "Settings - Passcode & Touch ID"
        
        // Detail
        case LocationDetail = "Location Detail"
        case ProfileDetail = "Profile Detail"
        case ProfileStatusDetail = "Profile Status Detail"
        case TeamDetail = "Team Detail"
        case LocationAddressMap = "Location Address Map"
        
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
    
    enum ContactLocation: String {
        case ProfileDetail = "Profile Detail"
        case ProfileDetailStatus = "Profile Detail Status"
        case TeamDetailStatus = "Team Detail Status"
        case TeamDetailDescription = "Team Detail Description"
        case SearchSmartAction = "Search Smart Action"
    }
    
    // This is repeated from Protobuf values
    // Ideally we would use the backend values but we expect
    // these to be strings and they are integers right now.
    enum ContactMethod: String {
        // All caps to keep it consistent with the web
        case Email = "EMAIL"
        case Message = "MESSAGE"
        case Call = "CELLPHONE"
    }
    
    enum SearchLocation: String {
        case Home = "Home"
        // Modal should be used for search from list views. It is called "modal"
        // to keep it consistent with the web.
        case Modal = "Modal"
    }

    enum SearchResultSource: String {
        case Explore = "Explore"
        case Recents = "Recents"
        case SmartAction = "Smart Action"
        case Suggestion = "Suggestion"
    }
    
    enum SearchResultType: String {
        // Results
        case Profile = "Profile"
        case Team = "Team"
        case Location = "Location"
        case ProfileStatus = "Profile Status"
        
        // Smart Actions
        case EmailPerson = "Email Person"
        case CallPerson = "Call Person"
        case MessagePerson = "Message Person"

        case AddressOfLocation = "Location Address"
        case LocalTimeAtLocation = "Location Local Time"
        
        // Extended Results
        case ContactsOfLocation = "Location Points of Contact"
        case ReportsTo = "Direct Reports"
        case TeamMembers = "Team Members"
        case LocationMembers = "Location Members"
        case TeamSubTeams = "Team Sub-Teams"
    }
    
    // This is repeated from Protobuf values
    // Ideally we would use the backend values but we expect
    // these to be strings and they are integers right now.
    enum SearchCategory: String {
        // All caps to keep it consistent with the web
        case Profiles = "PROFILES"
        case Teams = "TEAMS"
        case Locations = "LOCATIONS"
    }
    
    // This is repeated from Protobuf values
    // Ideally we would use the backend values but we expect
    // these to be strings and they are integers right now.
    enum SearchAttribute: String {
        // All caps to keep it consistent with the web
        case LocationId = "LOCATION_ID"
        case TeamId = "TEAM_ID"
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
    
    // Track Search Start
    /*
        Tracks the start of a search.
    
        Given the nature of real time search and auto-focus through specific gestures,
        there are multiple ways to indicate search was started.
        For e.g., a user can focus on search and immediately tap a recent search result,
        which can be tracked as a person started on search but the Recents feature helped
        take them to the result immediately. Same applies for Explore options as well.
        
        To simplify, we define search started when a user has typed at least two characters.
        A flag is maintained to track whether this event was recorded and it is reset when
        the character count reaches zero.
    */
    
    func trackSearchStart(
        query query: String,
        searchLocation: TrackerProperty.SearchLocation,
        category: TrackerProperty.SearchCategory?,
        attribute: TrackerProperty.SearchAttribute?,
        value: String?
    ) {
        var properties = [
            "Search Query": query,
            "Search Location": searchLocation.rawValue
        ]

        if let category = category {
            properties["Search Category"] = category.rawValue
        }
        
        if let attribute = attribute {
            properties["Search Attribute"] = attribute.rawValue
        }
        
        if let value = value {
            properties["Search Attribute Value"] = value
        }

        track(.SearchStart, properties: properties)
    }
    
    func trackSearchResultTap(
        query query: String?,
        searchSource: TrackerProperty.SearchResultSource,
        searchLocation: TrackerProperty.SearchLocation,
        searchResultType: TrackerProperty.SearchResultType,
        searchResultIndex: Int?,
        searchResultId: String?,
        category: TrackerProperty.SearchCategory?,
        attribute: TrackerProperty.SearchAttribute?,
        value: String?
    ) {
        var properties = [
            "Search Source": searchSource.rawValue,
            "Search Location": searchLocation.rawValue,
            "Search Result Type": searchResultType.rawValue,
        ] as [String: AnyObject]
        
        if let query = query where query.trimWhitespace() != "" {
            properties["Search Query"] = query
        }
        
        if let searchResultIndex = searchResultIndex {
            properties["Search Result Index"] = searchResultIndex
        }
        
        if let searchResultId = searchResultId {
            properties["Search Result ID"] = searchResultId
        }
        
        if let category = category {
            properties["Search Category"] = category.rawValue
        }
        
        if let attribute = attribute {
            properties["Search Attribute"] = attribute.rawValue
        }
        
        if let value = value {
            properties["Search Attribute Value"] = value
        }
        
        track(.SearchResultTap, properties: properties)
    }
    
    func trackContactTap(
        contactMethod: TrackerProperty.ContactMethod,
        contactId: String, 
        contactLocation: TrackerProperty.ContactLocation
    ) {
        if let loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile()
            where loggedInUserProfile.id == contactId
        {
            // do not track contact methods that user is tapping on his/her own profile
            return;
        }
        
        let properties = [
            "Contact Method": contactMethod.rawValue,
            "Contact ID": contactId,
            "Contact Location": contactLocation.rawValue,
        ]
        
        track(.ContactTap, properties: properties)
    }
    
    func trackProfileUpdate(profileId: String, fields: [String]) {
        track(.ProfileUpdate, properties: [
            "Object ID": profileId,
            "Fields": fields
        ])
    }

    func trackTeamUpdate(teamId: String, fields: [String]) {
        track(.TeamUpdate, properties: [
            "Team ID": teamId,
            "Fields": fields
        ])
    }
}
