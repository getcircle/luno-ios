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
    
    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    
    private var searchTerm = ""
    private var visibleProfiles = Array<ProfileService.Containers.Profile>()
    private var visibleTeams = Array<OrganizationService.Containers.Team>()
    private var visibleAddresses = Array<OrganizationService.Containers.Address>()
    private var visibleSkills = Array<ProfileService.Containers.Skill>()
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
    }
    
    override func filter(string: String, completionHandler: (error: NSError?) -> Void) {
        searchTerm = string
        SearchService.Actions.search(string, completionHandler: { (results, error) -> Void in
            if let results = results {
                if let profiles = results.profiles {
                    self.visibleProfiles = profiles
                }
                if let teams = results.teams {
                    self.visibleTeams = teams
                }
                if let addresses = results.addresses {
                    self.visibleAddresses = addresses
                }
                if let skills = results.skills {
                    self.visibleSkills = skills
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
        let headerClassName = "ProfileSectionHeaderCollectionReusableView"

        // TODO these should be sorted by relevancy
        if visibleProfiles.count > 0 {
            
            // Don't show title if there is no search string implying those
            // are straight up suggestions without any search term
            
            let profilesCardTitle = searchTerm.trimWhitespace() == "" ? "Recent" : "People"
            let peopleCard = Card(cardType: .Profiles, title: profilesCardTitle, showContentCount: false)
            peopleCard.addHeader(headerClass: headerClass, headerClassName: headerClassName)
            peopleCard.addContent(content: visibleProfiles as [AnyObject])
            peopleCard.contentCount = visibleProfiles.count
            peopleCard.sectionInset = sectionInset
            appendCard(peopleCard)
        }

        if visibleTeams.count > 0 {
            let teamsCard = Card(cardType: .Team, title: "Teams", showContentCount: false)
            teamsCard.addHeader(headerClass: headerClass, headerClassName: headerClassName)
            teamsCard.addContent(content: visibleTeams as [AnyObject])
            teamsCard.contentCount = visibleTeams.count
            teamsCard.sectionInset = sectionInset
            appendCard(teamsCard)
        }
        
        if visibleSkills.count > 0 {
            let skillsCard = Card(cardType: .Skills, title: "Skills", showContentCount: false)
            skillsCard.addHeader(headerClass: headerClass, headerClassName: headerClassName)
            skillsCard.addContent(content: visibleSkills as [AnyObject])
            skillsCard.contentCount = visibleSkills.count
            skillsCard.sectionInset = sectionInset
            appendCard(skillsCard)
        }
        
        if searchTerm == "" {
            let statsCard = Card(cardType: .StatTile, title: "Categories", showContentCount: false)
            statsCard.addHeader(headerClass: headerClass, headerClassName: headerClassName)
            let stats = [
                ["title": "People", "value": ObjectStore.sharedInstance.profiles.values.array.count],
                ["title": "Teams", "value": ObjectStore.sharedInstance.teams.values.array.count],
                ["title": "Skills", "value": ObjectStore.sharedInstance.activeSkills.values.array.count],
                ["title": "Offices", "value": ObjectStore.sharedInstance.locations.values.array.count]
            ] as [AnyObject]
            statsCard.addContent(content: stats)
            
            statsCard.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 20.0, 10.0)
            appendCard(statsCard)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is TeamGridItemCollectionViewCell {
            (cell as TeamGridItemCollectionViewCell).sizeMode = .Compact
        } else if cell is ProfileCollectionViewCell {
            cell.backgroundColor = UIColor.clearColor()
        } else if cell is StatTileCollectionViewCell {
            cell.backgroundColor = UIColor.whiteColor()
            cell.addRoundCorners(radius: 5.0)
        }
    }
    
}
