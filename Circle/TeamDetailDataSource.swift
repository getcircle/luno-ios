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
    var selectedTeam: Services.Organization.Containers.TeamV1!
    
    private(set) var profileHeaderView: TeamHeaderCollectionReusableView!

    private var ownerProfile: Services.Profile.Containers.ProfileV1!
    private var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    private var teams = Array<Services.Organization.Containers.TeamV1>()
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        
        if cards.count == 0 {
            addPlaceholderCard()
        }
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            
            var storedError: NSError!
            var actionsGroup = dispatch_group_create()
            
            // Fetch owners and members
            dispatch_group_enter(actionsGroup)
            Services.Profile.Actions.getProfiles(selectedTeam!.id) { (profiles, _, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    var allProfilesExceptOwner = profiles?.filter({ (profile) -> Bool in
                        if profile.userId == self.selectedTeam.ownerId {
                            self.ownerProfile = profile
                            return false
                        }
                        return true
                    })
                }
                dispatch_group_leave(actionsGroup)
            }
            
            // Fetch sub-teams
            dispatch_group_enter(actionsGroup)
            Services.Organization.Actions.getTeamDescendants(self.selectedTeam!.id, depth: 1, completionHandler: { (teams, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else if let teams = teams where teams.count > 0 {
                }
                dispatch_group_leave(actionsGroup)
            })
        
            dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
                self.populateData()
                completionHandler(error: storedError)
            }
        }
    }

    private func addTeamActionsCard() {

        // Add team actions card
        if let permissions = self.selectedTeam.permissions where permissions.canEdit {
            let teamActionsCard = Card(cardType: .Settings, title: "")
            teamActionsCard.sectionInset = UIEdgeInsetsMake(25.0, 0.0, 40.0, 0.0)
            teamActionsCard.addContent(content: [[
                "text" : AppStrings.TeamEditButtonTitle,
                "type": ContentType.EditTeam.rawValue
            ]])
            appendCard(teamActionsCard)
        }
    }
    
    private func addPlaceholderCard() {
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "")
        placeholderHeaderCard.sectionInset = UIEdgeInsetsZero
        placeholderHeaderCard.addHeader(
            headerClass: TeamHeaderCollectionReusableView.self
        )
        appendCard(placeholderHeaderCard)
    }
    
    private func populateData() {
        resetCards()
        addPlaceholderCard()
        
        if let owner = self.ownerProfile {
            let ownerCard = Card(cardType: .Profiles, title: "")
            ownerCard.addContent(content: [self.ownerProfile])
            ownerCard.sectionInset = self.sectionInset
            self.appendCard(ownerCard)
        }
        
        let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self
        if profiles.count > 0 {
            let membersCardTitle = AppStrings.GroupMembersSectionTitle.localizedUppercaseString()
            let membersCard = Card(cardType: .Profiles, title: membersCardTitle)
            membersCard.showContentCount = false
            membersCard.addHeader(headerClass: sectionHeaderClass)
            membersCard.addContent(content: profiles)
            membersCard.sectionInset = self.sectionInset
            appendCard(membersCard)
        }
        
        if teams.count > 0 {
            var teamsCard = Card(cardType: .TeamsGrid, title: AppStrings.TeamSubTeamsSectionTitle)
            teamsCard.showContentCount = false
            teamsCard.addHeader(headerClass: sectionHeaderClass)
            teamsCard.addContent(content: teams)
            teamsCard.sectionInset = sectionInset
            appendCard(teamsCard)
        }
        
        addTeamActionsCard()
    }

    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(
        header: CircleCollectionReusableView,
        atIndexPath indexPath: NSIndexPath
    ) {
        
        super.configureHeader(header, atIndexPath: indexPath)
        if let teamHeader = header as? TeamHeaderCollectionReusableView {
            teamHeader.setData(selectedTeam)
            profileHeaderView = teamHeader
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let content = contentAtIndexPath(indexPath) as? [String: AnyObject], settingsCell = cell as? SettingsCollectionViewCell {
            settingsCell.itemLabel.textAlignment = .Center
            settingsCell.itemLabel.textColor = UIColor.appTintColor()
        }
    }
}
