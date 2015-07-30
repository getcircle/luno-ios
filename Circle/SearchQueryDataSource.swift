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
        Services.Search.Actions.search(string, completionHandler: { (results, error) -> Void in
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
    
    private func updateVisibleCards() {
        resetCards()
        let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        let headerClass = ProfileSectionHeaderCollectionReusableView.self

        // TODO these should be sorted by relevancy
        if visibleProfiles.count > 0 {
            
            // Don't show title if there is no search string implying those
            // are straight up suggestions without any search term
            
            let maxVisibleItems = 3
            let profilesCardTitle = searchTerm.trimWhitespace() == "" ? "Recent" : "People"
            var peopleShowContentCount = searchTerm.trimWhitespace() == "" ? false : true
            if visibleProfiles.count <= maxVisibleItems {
                peopleShowContentCount = false
            }
            let peopleCard = Card(cardType: .Profiles, title: profilesCardTitle, showContentCount: peopleShowContentCount)
            peopleCard.addHeader(headerClass: headerClass)
            peopleCard.addContent(content: visibleProfiles as [AnyObject], maxVisibleItems: 3)
            peopleCard.contentCount = visibleProfiles.count
            peopleCard.sectionInset = sectionInset
            appendCard(peopleCard)
        }

        if visibleTeams.count > 0 {
            let maxVisibleItems = 3
            var teamsShowContentCount = true
            if visibleTeams.count <= maxVisibleItems {
                teamsShowContentCount = false
            }
            
            let teamsCard = Card(cardType: .Profiles, title: "Teams", showContentCount: teamsShowContentCount)
            teamsCard.addHeader(headerClass: headerClass)
            teamsCard.addContent(content: visibleTeams as [AnyObject], maxVisibleItems: 3)
            teamsCard.contentCount = visibleTeams.count
            teamsCard.sectionInset = sectionInset
            appendCard(teamsCard)
        }

        if visibleLocations.count > 0 {
            let maxVisibleItems = 3
            var locationsShowContentCount = true
            if visibleLocations.count <= maxVisibleItems {
                locationsShowContentCount = false
            }
            
            let locationsCard = Card(cardType: .Offices, title: "Offices", showContentCount: locationsShowContentCount)
            locationsCard.addHeader(headerClass: headerClass)
            locationsCard.addContent(content: visibleLocations as [AnyObject], maxVisibleItems: 3)
            locationsCard.contentCount = visibleLocations.count
            locationsCard.sectionInset = sectionInset
            appendCard(locationsCard)
        }

        if searchTerm == "" && !isQuickAction {
            let statsCard = Card(cardType: .StatTile, title: "Categories", showContentCount: false)
            statsCard.addHeader(headerClass: headerClass)
            
            let peopleCount = ObjectStore.sharedInstance.profiles.values.array.count
            let peopleTitle = peopleCount == 1 ? "Person" : "People"

            let officeCount = ObjectStore.sharedInstance.locations.values.array.count
            let officeTitle = officeCount == 1 ? "Office" : "Offices"
            
            let teamsCount = ObjectStore.sharedInstance.teams.values.array.count
            let teamsTitle = teamsCount == 1 ? "Team" : "Teams"

            let skillsCount = ObjectStore.sharedInstance.activeSkills.values.array.count
            let skillsTitle = skillsCount == 1 ? "Skill" : "Skills"
            
            let stats = [
                [
                    "title": peopleTitle,
                    "value": peopleCount,
                    "type": StatTileCollectionViewCell.TileType.People.rawValue
                ],
                [
                    "title": officeTitle,
                    "value": officeCount,
                    "type": StatTileCollectionViewCell.TileType.Offices.rawValue
                ],
                [
                    "title": teamsTitle,
                    "value": teamsCount,
                    "type": StatTileCollectionViewCell.TileType.Teams.rawValue
                ],
                [
                    "title": skillsTitle,
                    "value": skillsCount,
                    "type": StatTileCollectionViewCell.TileType.Skills.rawValue
                ]
            ] as [AnyObject]
            statsCard.addContent(content: stats)
            
            statsCard.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 20.0, 10.0)
            appendCard(statsCard)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is TeamGridItemCollectionViewCell {
            (cell as! TeamGridItemCollectionViewCell).sizeMode = .Compact
        } else if cell is ProfileCollectionViewCell {
            cell.backgroundColor = UIColor.clearColor()
        } else if cell is StatTileCollectionViewCell {
            cell.backgroundColor = UIColor.whiteColor()
            cell.addRoundCorners(radius: 5.0)
        } else if cell is TagScrollingCollectionViewCell {
            cell.backgroundColor = UIColor.clearColor()
        }
    }
    
}
