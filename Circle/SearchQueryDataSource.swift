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
    
    let queryTriggerTimer = 0.2
    var isQuickAction: Bool = false
    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    
    private var searchTerm = ""
    private var searchResults = [AnyObject]()
    private var searchSuggestions = [SearchSuggestion]()
    private var searchCache = Dictionary<String, Array<AnyObject>>()
    private var completionHandler: ((error: NSError?) -> Void)?
    private var searchTriggerTimer: NSTimer?
    
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
            searchResults.extend(CircleCache.getRecordedSearchResults(Card.MaxListEntries))
            populateDefaultSearchSuggestions()
            addCards()
            completionHandler(error: nil)
        }
        else {
            if let results = searchCache[searchTerm] {
                self.clearData()
                searchResults.extend(results)
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
        let peopleCount = ObjectStore.sharedInstance.profilesCount
        let peopleTitle = peopleCount == 1 ? "Person" : "People"
        
        let officeCount = ObjectStore.sharedInstance.locationsCount
        let officeTitle = officeCount == 1 ? "Office" : "Offices"
        
        let teamsCount = ObjectStore.sharedInstance.teamsCount
        let teamsTitle = teamsCount == 1 ? "Team" : "Teams"
        
        searchSuggestions.extend([
            SearchCategory(
                categoryTitle: peopleTitle,
                ofType: .People,
                withCount: peopleCount,
                withImageSource: "FeedPeers"
            ),
            SearchCategory(
                categoryTitle: officeTitle,
                ofType: .Locations,
                withCount: officeCount,
                withImageSource: "FeedLocation"
            ),
            SearchCategory(
                categoryTitle: teamsTitle,
                ofType: .Teams,
                withCount: teamsCount,
                withImageSource: "FeedReports"
            )
        ])
    }
    
    private func addCards() {
        resetCards()

        let emptySearchTerm = searchTerm.trimWhitespace() == ""
        let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
        if searchResults.count > 0 {
            let maxVisibleItems = 3
            let profilesCardTitle = emptySearchTerm ? NSLocalizedString("Recent", comment: "Title of the section showing recent search results") : NSLocalizedString("Results", comment: "Title of the section showing search results")
            let resultsCard = Card(cardType: .Profiles, title: profilesCardTitle, showContentCount: false)
            resultsCard.addContent(content: searchResults)
            resultsCard.sectionInset = sectionInset
            if emptySearchTerm {
                resultsCard.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            }
            appendCard(resultsCard)
            addSearchActions()
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
            searchSuggestionsCard.sectionInset = sectionInset
            appendCard(searchSuggestionsCard)
        }
    }
    
    private func addSearchActions() {
        if searchResults.count == 1 {
            if let profile = searchResults.first as? Services.Profile.Containers.ProfileV1 {
                searchSuggestions.extend(SearchAction.searchActionsForProfile(profile) as [SearchSuggestion])
            }
            else if let location = searchResults.first as? Services.Organization.Containers.LocationV1 {
                searchSuggestions.extend(SearchAction.searchActionsForLocation(location) as [SearchSuggestion])
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
}
