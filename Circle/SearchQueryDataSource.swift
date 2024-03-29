//
//  SearchQueryDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SearchQueryDataSource: CardDataSource {
    
    var isQuickAction: Bool = false
    var searchCategory: TrackerProperty.SearchCategory?

    let queryTriggerTimer = 0.2

    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    
    private var searchResults = [AnyObject]()
    private var searchSuggestions = [SearchSuggestion]()
    private var searchCache = Dictionary<String, Array<AnyObject>>()
    private var completionHandler: ((error: NSError?) -> Void)?
    private var searchTriggerTimer: NSTimer?
    private var searchStartTracked = false
    
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
    
    override func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {

        if searchTerm.characters.count < 2 {
            searchStartTracked = false
        }

        if !searchStartTracked && searchTerm.characters.count >= 2 {
            searchStartTracked = true
            Tracker.sharedInstance.trackSearchStart(
                query: searchTerm,
                searchLocation: .Home,
                category: searchCategory,
                attribute: nil, value: nil
            )
        }
        
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
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)        
        clearData()
        searchResults.appendContentsOf(CircleCache.getRecordedSearchResults(Card.MaxListEntries))
        populateDefaultSearchSuggestions()
        addCards()
        completionHandler()
    }
    
    private func isRecentSearchResult() -> Bool {
        // If category isn't set and no query exists, the only way to tap
        // a result is by Recents
        return searchTerm.trimWhitespace() == "" && searchCategory == nil
    }
    
    override func getSearchTrackingSource() -> TrackerProperty.SearchResultSource {
        if isRecentSearchResult() {
            return .Recents
        }
        
        return super.getSearchTrackingSource()
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
                    else if let post = result.post {
                        self.searchResults.append(post)
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
        if let organization = AuthenticationViewController.getLoggedInUserOrganization() {
            let postCount = Int(organization.postCount)
            let postTitle = AppStrings.SearchCategoryPosts
            
            let peopleCount = Int(organization.profileCount)
            let peopleTitle = peopleCount == 1 ? "Person" : "People"
            
            let locationsCount = Int(organization.locationCount)
            let locationsTitle = locationsCount == 1 ? "Office" : "Offices"
            
            let teamsCount = Int(organization.teamCount)
            let teamsTitle = teamsCount == 1 ? "Team" : "Teams"
            
            searchSuggestions.appendContentsOf([
                SearchCategory(
                    categoryTitle: postTitle,
                    ofType: .Posts,
                    withCount: postCount,
                    withImageSource: "searchbar_search"
                ),
                SearchCategory(
                    categoryTitle: peopleTitle,
                    ofType: .People,
                    withCount: peopleCount,
                    withImageSource: "searchbar_search"
                ),
                SearchCategory(
                    categoryTitle: teamsTitle,
                    ofType: .Teams,
                    withCount: teamsCount,
                    withImageSource: "searchbar_search"
                ),
                SearchCategory(
                    categoryTitle: locationsTitle,
                    ofType: .Locations,
                    withCount: locationsCount,
                    withImageSource: "searchbar_search"
                ),
            ])
        }
    }
    
    private func addCards() {
        resetCards()

        let emptySearchTerm = searchTerm.trimWhitespace() == ""
        if searchResults.count > 0 {
            let profilesCardTitle = emptySearchTerm ? NSLocalizedString("Recents", comment: "Title of the section showing recent search results") : NSLocalizedString("Results", comment: "Title of the section showing search results")
            let resultsCard = Card(cardType: .SearchResult, title: profilesCardTitle, showContentCount: false)
            resultsCard.sectionInset = UIEdgeInsetsZero
            resultsCard.addContent(content: searchResults)
            if emptySearchTerm {
                resultsCard.addHeader(headerClass: SearchSectionHeaderCollectionReusableView.self)
            }
            
            appendCard(resultsCard)
            
            // Do not show info cards or search actions when results are presented in Recents
            if !emptySearchTerm {
                addSearchActions()
            }
        }

        if searchSuggestions.count > 0 {
            let searchSuggestionsCard = Card(
                cardType: emptySearchTerm ? .SearchSuggestion : .SearchAction,
                title: NSLocalizedString("Explore",
                    comment: "Title which presents options to explore the content"
                ),
                showContentCount: false
            )
            searchSuggestionsCard.sectionInset = UIEdgeInsetsZero
            
            if emptySearchTerm {
                // Explore options are shown here
                searchSuggestionsCard.addHeader(headerClass: SearchSectionHeaderCollectionReusableView.self)
            }
            
            searchSuggestionsCard.addContent(content: searchSuggestions as [AnyObject])
            appendCard(searchSuggestionsCard)
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
        
        let isLoneProfileCell = (searchResults.count == 1 && cell is SearchResultCollectionViewCell)
        cell.showSeparator = !isLoneProfileCell
    }
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        if let cardHeader = header as? ProfileSectionHeaderCollectionReusableView {
            cardHeader.cardView.backgroundColor = UIColor.appSearchBackgroundColor()
        }
    }
}
