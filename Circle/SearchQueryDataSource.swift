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
    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    
    private var searchTerm = ""
    private var searchResults = [AnyObject]()
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
            updateVisibleCards()
            completionHandler(error: nil)
        }
        else {
            if let results = searchCache[searchTerm] {
                self.clearData()
                searchResults.extend(results)
                self.updateVisibleCards()
                completionHandler(error: nil)
            }
            else {
                self.completionHandler = completionHandler
                if let timer = searchTriggerTimer {
                    timer.invalidate()
                }
                
                searchTriggerTimer = NSTimer.scheduledTimerWithTimeInterval(
                    0.3, 
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
                self.updateVisibleCards()
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
    }
    
    private func updateVisibleCards() {
        resetCards()
        
        let sectionInset = UIEdgeInsetsZero
        if searchResults.count > 0 {
            let maxVisibleItems = 3
            let profilesCardTitle = searchTerm.trimWhitespace() == "" ? "Recent" : "People"
            let resultsCard = Card(cardType: .Profiles, title: profilesCardTitle, showContentCount: false)
            resultsCard.addContent(content: searchResults)
            resultsCard.sectionInset = sectionInset
            appendCard(resultsCard)
        }

        if searchTerm == "" && !isQuickAction {
            let searchCategoriesCard = Card(cardType: .SearchCategory, title: "", showContentCount: false)
            
            let peopleCount = ObjectStore.sharedInstance.profilesCount
            let peopleTitle = peopleCount == 1 ? "Person" : "People"

            let officeCount = ObjectStore.sharedInstance.locationsCount
            let officeTitle = officeCount == 1 ? "Office" : "Offices"
            
            let teamsCount = ObjectStore.sharedInstance.teamsCount
            let teamsTitle = teamsCount == 1 ? "Team" : "Teams"

            let stats = [
                SearchCategory(
                    categoryTitle: peopleTitle,
                    ofType: .People,
                    withCount: peopleCount,
                    withImageSource: "FeedPeers"
                ),
                SearchCategory(
                    categoryTitle: officeTitle,
                    ofType: .Offices,
                    withCount: officeCount,
                    withImageSource: "FeedLocation"
                ),
                SearchCategory(
                    categoryTitle: teamsTitle,
                    ofType: .Teams,
                    withCount: teamsCount,
                    withImageSource: "FeedReports"
                )
            ]
            searchCategoriesCard.addContent(content: stats as [AnyObject])
            searchCategoriesCard.sectionInset = sectionInset
            appendCard(searchCategoriesCard)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }
    
}
