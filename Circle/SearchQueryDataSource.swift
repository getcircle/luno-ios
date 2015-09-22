//
//  SearchQueryDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class SearchQueryDataSource: CardDataSource {
    
    var isQuickAction: Bool = false

    let queryTriggerTimer = 0.2

    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    
    private var searchTerm = ""
    private var searchResults = [AnyObject]()
    private var searchSuggestions = [SearchSuggestion]()
    private var searchCache = Dictionary<String, Array<AnyObject>>()
    private var completionHandler: ((error: NSError?) -> Void)?
    private var searchTriggerTimer: NSTimer?
    
    override class var cardSeparatorColor: UIColor {
        return UIColor.appSearchCardSeparatorViewColor()
    }
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 70.0, 0.0, 20.0)
    }
    
    override init() {
        super.init()
        
        // Currently purge all memory
        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "clearCache", 
            name:UIApplicationDidReceiveMemoryWarningNotification, 
            object: nil
        )
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func filter(string: String, completionHandler: (error: NSError?) -> Void) {
        if string == searchTerm && searchTerm.trimWhitespace() != "" {
            return
        }
        
        searchTerm = string.trimWhitespace()
        if searchTerm == "" {
            clearData()
            searchResults.appendContentsOf(CircleCache.getRecordedSearchResults(Card.MaxListEntries))
            populateDefaultSearchSuggestions()
            addCards()
            completionHandler(error: nil)
        }
        else {
            if let results = searchCache[searchTerm] {
                self.clearData()
                searchResults.appendContentsOf(results)
                self.addCards()
                completionHandler(error: nil)
            }
            else {
                self.completionHandler = completionHandler
                if let timer = searchTriggerTimer {
                    timer.invalidate()
                }
                
                searchTriggerTimer = NSTimer.scheduledTimerWithTimeInterval(
                    queryTriggerTimer,
                    target: self, 
                    selector: "search", 
                    userInfo: nil, 
                    repeats: false
                )
            }
        }
    }
    
    func search() {
        Services.Search.Actions.search(searchTerm, completionHandler: { (query, results, error) -> Void in
            self.clearData()
            if let results = results where self.searchTerm != "" {
                for result in results {
                    if let profile = result.profile {
                        self.searchResults.append(profile)
                    }
                    else if let team = result.team {
                        self.searchResults.append(team)
                    }
                    else if let location = result.location {
                        self.searchResults.append(location)
                    }
                }
                
                self.searchCache[query] = self.searchResults
                self.addCards()
            }
            
            self.completionHandler?(error: error)
            return
        })
    }
    
    func clearCache() {
        self.searchCache.removeAll(keepCapacity: true)
    }
    
    private func clearData() {
        searchResults.removeAll(keepCapacity: true)
        searchSuggestions.removeAll(keepCapacity: true)
    }
    
    private func populateDefaultSearchSuggestions() {
        if let organization = AuthViewController.getLoggedInUserOrganization() {
            let peopleCount = Int(organization.profileCount)
            let peopleTitle = peopleCount == 1 ? "Person" : "People"
            
            let locationsCount = Int(organization.locationCount)
            let locationsTitle = locationsCount == 1 ? "Office" : "Offices"
            
            let teamsCount = Int(organization.teamCount)
            let teamsTitle = teamsCount == 1 ? "Team" : "Teams"
            
            searchSuggestions.appendContentsOf([
                SearchCategory(
                    categoryTitle: peopleTitle,
                    ofType: .People,
                    withCount: peopleCount,
                    withImageSource: "results_search"
                ),
                SearchCategory(
                    categoryTitle: locationsTitle,
                    ofType: .Locations,
                    withCount: locationsCount,
                    withImageSource: "results_search"
                ),
                SearchCategory(
                    categoryTitle: teamsTitle,
                    ofType: .Teams,
                    withCount: teamsCount,
                    withImageSource: "results_search"
                )
            ])
        }
    }
    
    private func addCards() {
        resetCards()

        let emptySearchTerm = searchTerm.trimWhitespace() == ""
        if searchResults.count > 0 {
            let maxVisibleItems = 3
            let profilesCardTitle = emptySearchTerm ? NSLocalizedString("Recent", comment: "Title of the section showing recent search results") : NSLocalizedString("Results", comment: "Title of the section showing search results")
            let resultsCard = Card(cardType: .Profiles, title: profilesCardTitle, showContentCount: false)
            resultsCard.addContent(content: searchResults)
            if emptySearchTerm {
                resultsCard.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            }
            
            appendCard(resultsCard)
            
            // Do not show info cards or search actions when results are presented in Recents
            if !emptySearchTerm {
                addInfoCards()
                addSearchActions()
            }
        }

        if searchSuggestions.count > 0 {
            let searchSuggestionsCard = Card(
                cardType: .SearchSuggestion, 
                title: NSLocalizedString("Explore",
                    comment: "Title which presents options to explore the content"
                ),
                showContentCount: false
            )
            
            if emptySearchTerm {
                // Explore options are shown here
                searchSuggestionsCard.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            }
            
            searchSuggestionsCard.addContent(content: searchSuggestions as [AnyObject])
            appendCard(searchSuggestionsCard)
        }
    }
    
    private func addInfoCards() {
        if searchResults.count == 1 {
            if let profile = searchResults.first as? Services.Profile.Containers.ProfileV1 {
               addStatusCard(profile)
            }
            else if let team = searchResults.first as? Services.Organization.Containers.TeamV1 {
                addStatusCard(team)
            }
        }
    }
    
    private func addSearchActions() {
        if searchResults.count == 1 {
            if let profile = searchResults.first as? Services.Profile.Containers.ProfileV1 {
                searchSuggestions.appendContentsOf(SearchAction.searchActionsForProfile(profile) as [SearchSuggestion])
            }
            else if let team = searchResults.first as? Services.Organization.Containers.TeamV1 {
                searchSuggestions.appendContentsOf(SearchAction.searchActionsForTeam(team) as [SearchSuggestion])
            }
            else if let location = searchResults.first as? Services.Organization.Containers.LocationV1 {
                searchSuggestions.appendContentsOf(SearchAction.searchActionsForLocation(location) as [SearchSuggestion])
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.appSearchBackgroundColor()
        cell.showSeparator = true
    }
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        if let cardHeader = header as? ProfileSectionHeaderCollectionReusableView {
            cardHeader.cardView.backgroundColor = UIColor.appSearchBackgroundColor()
        }
    }
    
    private func addStatusCard(profile: Services.Profile.Containers.ProfileV1) {
        if let status = profile.status where status.value.trimWhitespace() != "" {
            let statusCard = Card(cardType: .TextValue, title: "")
            statusCard.addContent(content: [
                TextData(
                    type: .ProfileStatus,
                    andValue: "I'm currently working on " + status.value,
                    andTimestamp: status.created
                )
                ])
            appendCard(statusCard)
        }
    }

    private func addStatusCard(team: Services.Organization.Containers.TeamV1) {
        if let status = team.status where status.value.trimWhitespace() != "" {
            let statusCard = Card(cardType: .TextValue, title: "")
            statusCard.addContent(content: [
                TextData(
                    type: .TeamStatus,
                    andValue: "We are currently working on " + status.value,
                    andTimestamp: status.created,
                    andAuthor: status.byProfile
                )
            ])
            appendCard(statusCard)
        }
    }
}
