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
    private var visibleProfiles = Array<Services.Profile.Containers.ProfileV1>()
    private var visibleTeams = Array<Services.Organization.Containers.TeamV1>()
    private var visibleLocations = Array<Services.Organization.Containers.LocationV1>()
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
    }
    
    override func filter(string: String, completionHandler: (error: NSError?) -> Void) {
        searchTerm = string
        
        if searchTerm.trimWhitespace() == "" {
            clearData()
            updateVisibleCards()
            completionHandler(error: nil)
        }
        else {
            Services.Search.Actions.search(string, completionHandler: { (results, error) -> Void in
                self.clearData()
                if let results = results {
                    for result in results {
                        switch result.category {
                        case .Profiles:
                            self.visibleProfiles = result.profiles

                        case .Locations:
                            self.visibleLocations = result.locations

                        case .Teams:
                            self.visibleTeams = result.teams
                            
                        default:
                            break
                        }
                    }
                    
                    self.updateVisibleCards()
                }
                completionHandler(error: error)
            })
        }
    }
    
    private func clearData() {
        visibleProfiles.removeAll(keepCapacity: true)
        visibleTeams.removeAll(keepCapacity: true)
        visibleLocations.removeAll(keepCapacity: true)
    }
    
    private func updateVisibleCards() {
        resetCards()
        
        let sectionInset = UIEdgeInsetsZero
        var content = [AnyObject]()
        for data in [visibleProfiles, visibleTeams, visibleLocations] {
            if data.count > 0 {
                content.extend(data as! [AnyObject])
            }
        }
        
        if content.count > 0 {
            let maxVisibleItems = 3
            let profilesCardTitle = searchTerm.trimWhitespace() == "" ? "Recent" : "People"
            var peopleShowContentCount = searchTerm.trimWhitespace() == "" ? false : true
            if visibleProfiles.count <= maxVisibleItems {
                peopleShowContentCount = false
            }
            let resultsCard = Card(cardType: .Profiles, title: profilesCardTitle, showContentCount: peopleShowContentCount)
            resultsCard.addContent(content: content)
            resultsCard.sectionInset = sectionInset
            appendCard(resultsCard)
        }

        if searchTerm == "" && !isQuickAction {
            let searchCategoriesCard = Card(cardType: .SearchCategory, title: "", showContentCount: false)
            
            let peopleCount = ObjectStore.sharedInstance.profiles.values.array.count
            let peopleTitle = peopleCount == 1 ? "Person" : "People"

            let officeCount = ObjectStore.sharedInstance.locations.values.array.count
            let officeTitle = officeCount == 1 ? "Office" : "Offices"
            
            let teamsCount = ObjectStore.sharedInstance.teams.values.array.count
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
