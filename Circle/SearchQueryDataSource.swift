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
        
        // TODO these should be sorted by relevancy
        if visibleProfiles.count > 0 {
            
            // Don't show title if there is no search string implying those
            // are straight up suggestions without any search term
            
            let profilesCardTitle = searchTerm.trimWhitespace() == "" ? "Recent" : "People"
            let peopleCard = Card(cardType: .Profiles, title: profilesCardTitle)
            peopleCard.addContent(content: visibleProfiles as [AnyObject])
            peopleCard.contentCount = visibleProfiles.count
            peopleCard.sectionInset = sectionInset
            appendCard(peopleCard)
        }

        if visibleTeams.count > 0 {
            let teamsCard = Card(cardType: .Team, title: "Teams")
            teamsCard.addContent(content: visibleTeams as [AnyObject])
            teamsCard.contentCount = visibleTeams.count
            teamsCard.sectionInset = sectionInset
            appendCard(teamsCard)
        }
        
        if visibleSkills.count > 0 {
            let skillsCard = Card(cardType: .Skills, title: "Skills")
            skillsCard.addContent(content: visibleSkills as [AnyObject])
            skillsCard.contentCount = visibleSkills.count
            skillsCard.sectionInset = sectionInset
            appendCard(skillsCard)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        if cell is TeamGridItemCollectionViewCell {
            (cell as TeamGridItemCollectionViewCell).sizeMode = .Compact
        }
    }

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "SearchResultsCardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SearchResultsCardHeaderCollectionReusableView
        
        headerView.addBottomBorder = true
        headerView.setCard(cards[indexPath.section])
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
}
