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
    private let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "Team Header")
        placeholderHeaderCard.sectionInset = UIEdgeInsetsZero
        placeholderHeaderCard.addHeader(
            headerClass: TeamHeaderCollectionReusableView.self
        )
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
                        let ownerCard = Card(cardType: .Profiles, title: "Team Lead")
                        ownerCard.addContent(content: [self.ownerProfile])
                        ownerCard.sectionInset = self.sectionInset
                        self.appendCard(ownerCard)
                    }
                    
                    let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self
                    
                    // Add Members Card
                    if allProfilesExceptOwner?.count > 0 {
                        self.profiles.extend(allProfilesExceptOwner!)
                        let membersCardTitle = NSLocalizedString(
                            "Members",
                            comment: "Title for list of team members"
                        ).localizedUppercaseString()
                        let membersCard = Card(cardType: .Profiles, title: membersCardTitle)
                        membersCard.showContentCount = false
                        membersCard.addHeader(headerClass: sectionHeaderClass)
                        membersCard.addContent(content: allProfilesExceptOwner! as [AnyObject])
                        membersCard.sectionInset = self.sectionInset
                        self.appendCard(membersCard)
                    }
                    
                    // Fetch subteams
                    // TODO: we should support sending multiple actions with a single service request.
                    OrganizationService.Actions.getTeamDescendants(self.selectedTeam!.id, depth: 1, completionHandler: { (teams, error) -> Void in
                        if let teams = teams {
                            if teams.count > 0 {
                                var teamsCard = Card(cardType: .TeamsGrid, title: "Teams")
                                teamsCard.showContentCount = false
                                teamsCard.addHeader(headerClass: sectionHeaderClass)
                                teamsCard.addContent(content: teams)
                                teamsCard.sectionInset = self.sectionInset
                                self.appendCard(teamsCard)
                            }
                        }
                        completionHandler(error: error)
                    })
                }
                else {
                    completionHandler(error: error)
                }
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let teamHeader = header as? TeamHeaderCollectionReusableView {
            teamHeader.setData(selectedTeam)
            profileHeaderView = teamHeader
        }
    }
}
