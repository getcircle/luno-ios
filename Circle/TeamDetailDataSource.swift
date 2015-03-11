//
//  TeamDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamDetailDataSource: CardDataSource {
    var selectedTeam: OrganizationService.Containers.Team!
    
    private var profiles = Array<ProfileService.Containers.Profile>()
    private var ownerProfile: ProfileService.Containers.Profile!
    private(set) var profileHeaderView: TeamHeaderCollectionReusableView!
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "Team Header")
        placeholderHeaderCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderHeaderCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            ProfileService.Actions.getProfiles(selectedTeam!.id) { (profiles, _, error) -> Void in
                if error == nil {
                    // Add Owner Card
                    var allProfilesExceptOwner = profiles?.filter({ (profile) -> Bool in
                        if profile.user_id == self.selectedTeam.owner_id {
                            self.ownerProfile = profile
                            return false
                        }
                        
                        return true
                    })
                    
                    if let owner = self.ownerProfile {
                        let ownerCard = Card(cardType: .People, title: "Team Lead")
                        ownerCard.addContent(content: [self.ownerProfile])
                        ownerCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
                        self.appendCard(ownerCard)
                    }
                    
                    // Add Members Card
                    if allProfilesExceptOwner?.count > 0 {
                        self.profiles.extend(allProfilesExceptOwner!)
                        let membersCardTitle = NSLocalizedString(
                            "Members",
                            comment: "Title for list of team members"
                        ).uppercaseStringWithLocale(NSLocale.currentLocale())
                        let membersCard = Card(cardType: .People, title: membersCardTitle)
                        membersCard.addContent(content: allProfilesExceptOwner! as [AnyObject])
                        membersCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
                        self.appendCard(membersCard)
                    }
                    
                    // Fetch subteams
                    // TODO: we should support sending multiple actions with a single service request.
                    OrganizationService.Actions.getTeamChildren(self.selectedTeam!.id) { (teams, error) -> Void in
                        if let teams = teams {
                            // TODO we need to fix this
                            var teamsCard = Card(cardType: .TeamsGrid, title: "")
                            teamsCard.addContent(content: teams)
                            teamsCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
                            self.appendCard(teamsCard)
                        }
                        completionHandler(error: error)
                    }
                }
                else {
                    completionHandler(error: error)
                }
            }
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
        if cell is TeamsCollectionViewCell {
            (cell as TeamsCollectionViewCell).showTeamsLabel = true
        }
    }
    
    // MARK: - Supplementary View
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "TeamHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: TeamHeaderCollectionReusableView.classReuseIdentifier
        )
        
        collectionView.registerNib(
            UINib(nibName: "SearchResultsCardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier
        )

        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
            if indexPath.section == 0 {
                let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                    kind,
                    withReuseIdentifier: TeamHeaderCollectionReusableView.classReuseIdentifier,
                    forIndexPath: indexPath
                ) as TeamHeaderCollectionReusableView
                
                supplementaryView.setData(selectedTeam)
                profileHeaderView = supplementaryView
                return supplementaryView
            }
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as SearchResultsCardHeaderCollectionReusableView
            supplementaryView.setCard(cards[indexPath.section])
            supplementaryView.backgroundColor = UIColor.clearColor()
            return supplementaryView
    }
}
