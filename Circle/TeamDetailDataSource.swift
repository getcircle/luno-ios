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
    
    var editImageButtonDelegate: EditImageButtonDelegate?
    var team: Services.Organization.Containers.TeamV1!
    
    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?

    private var managerProfile: Services.Profile.Containers.ProfileV1!
    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var teams = Array<Services.Organization.Containers.TeamV1>()
    private(set) var statusProfile: Services.Profile.Containers.ProfileV1?
    
    private let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    private let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self

    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        
        if cards.count == 0 {
            addPlaceholderCard()
        }
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            
            var storedError: NSError!
            var actionsGroup = dispatch_group_create()
            
            // TODO: Remove after profiles come back inflated
            if team.hasStatus && team.status != nil {
                dispatch_group_enter(actionsGroup)
                Services.Profile.Actions.getProfile(team.status.byProfileId, completionHandler: { (profile, error) -> Void in
                    if let error = error {
                        storedError = error
                    }
                    else  if let profile = profile {
                        self.statusProfile = profile
                    }
                    dispatch_group_leave(actionsGroup)
                })
            }
            
            // Fetch managers and members
            dispatch_group_enter(actionsGroup)
            Services.Organization.Actions.getTeam(team.id) { (team, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    self.team = team
                }
                dispatch_group_leave(actionsGroup)
            }

            dispatch_group_enter(actionsGroup)
            Services.Profile.Actions.getProfiles(team!.id) { (profiles, _, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    var allProfilesExceptManager = profiles?.filter({ (profile) -> Bool in
                        if profile.userId == self.team.ownerId {
                            self.managerProfile = profile
                            return false
                        }
                        return true
                    })
                    
                    self.profiles = allProfilesExceptManager!
                }
                dispatch_group_leave(actionsGroup)
            }
            
            // Fetch sub-teams
            dispatch_group_enter(actionsGroup)
            Services.Organization.Actions.getTeamDescendants(self.team!.id, depth: 1, completionHandler: { (teams, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else if let teams = teams {
                    self.teams.extend(teams)
                }
                dispatch_group_leave(actionsGroup)
            })
        
            dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
                self.populateData()
                completionHandler(error: storedError)
            }
        }
    }
    
    private func canEdit() -> Bool {
        if let permissions = self.team.permissions where permissions.canEdit {
            return true
        }
        
        return false
    }
    
    private func addPlaceholderCard() {
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "")
        placeholderHeaderCard.sectionInset = self.sectionInset
        placeholderHeaderCard.addHeader(
            headerClass: ProfileHeaderCollectionReusableView.self,
            headerSize: CGSizeMake(
                ProfileHeaderCollectionReusableView.width,
                ProfileHeaderCollectionReusableView.heightWithoutSecondaryInfo
            )            
        )
        appendCard(placeholderHeaderCard)
    }
    
    private func addStatusCard() {
        // hasStatus on the object is not returning correct value
        var hasStatus = false
        var createdTimestamp = ""
        if let status = team.status {
            hasStatus = true
            createdTimestamp = status.created
        }
        
        if hasStatus || canEdit() {
            
            let statusCard = Card(cardType: .TextValue, title: "Currently working on")
            statusCard.sectionInset = self.sectionInset
            if let status = team.status where team.status.value.trimWhitespace() != "" {
                statusCard.addContent(content: [
                    TextData(
                        type: .TeamStatus, 
                        andValue: status.value, 
                        andTimestamp: createdTimestamp,
                        andAuthor: statusProfile
                    )
                ])
            }
            
            if canEdit() {
                statusCard.showContentCount = false
                statusCard.addHeader(headerClass: sectionHeaderClass)
                statusCard.allowEditingContent = true
            }
            
            appendCard(statusCard)
        }
    }
    
    private func addDescriptionCard() {
        if team.teamDescription?.value.trimWhitespace() != "" || canEdit() {
            var description = NSLocalizedString("Add a description", comment: "Add a description to the team")
            if let value = team.teamDescription?.value where value.trimWhitespace() != "" {
                description = value
            }
            
            let descriptionCard = Card(cardType: .TextValue, title: "Description")
            descriptionCard.sectionInset = self.sectionInset
            descriptionCard.addContent(content: [
                TextData(type: .TeamDescription, andValue: description)
            ])

            if canEdit() {
                descriptionCard.showContentCount = false
                descriptionCard.addHeader(headerClass: sectionHeaderClass)
                descriptionCard.allowEditingContent = true
            }
            
            appendCard(descriptionCard)
        }
    }
    
    private func addManagerCard() {
        if let manager = self.managerProfile {
            let managerCard = Card(cardType: .Profiles, title: "Manager")
            managerCard.showContentCount = false
            managerCard.addHeader(headerClass: sectionHeaderClass)
            managerCard.addContent(content: [self.managerProfile])
            managerCard.sectionInset = self.sectionInset
            self.appendCard(managerCard)
        }
    }
    
    private func addSubTeamsCard() {
        if teams.count > 0 {
            var teamsCard = Card(
                cardType: .Profiles,
                subType: .Teams,
                title: AppStrings.TeamSubTeamsSectionTitle + " (" + String(teams.count) + ")"
            )
            teamsCard.showContentCount = false
            teamsCard.addHeader(headerClass: sectionHeaderClass)
            teamsCard.addContent(content: teams, maxVisibleItems: Card.MaxListEntries)
            teamsCard.sectionInset = sectionInset
            if teams.count > Card.MaxListEntries {
                teamsCard.addDefaultFooter()
            }
            appendCard(teamsCard)
        }
    }
    
    private func addMembersCard() {
        if profiles.count > 0 {
            let membersCardTitle = AppStrings.CardTitlePeople.localizedUppercaseString()
            let membersCard = Card(
                cardType: .Profiles,
                subType: .Members,
                title: membersCardTitle + " (" + String(profiles.count) + ")"
            )
            membersCard.showContentCount = false
            membersCard.addHeader(headerClass: sectionHeaderClass)
            membersCard.addContent(content: profiles, maxVisibleItems: Card.MaxListEntries)
            membersCard.sectionInset = self.sectionInset
            if profiles.count > Card.MaxListEntries {
                membersCard.addDefaultFooter()
            }
            appendCard(membersCard)
        }
    }
    
    private func addTeamActionsCard() {
        
        // Add team actions card
        if canEdit() {
            let teamActionsCard = Card(cardType: .Settings, title: "")
            teamActionsCard.sectionInset = UIEdgeInsetsMake(25.0, 0.0, 25.0, 0.0)
            teamActionsCard.addContent(content: [[
                "text" : AppStrings.TeamEditButtonTitle,
                "type": ContentType.EditTeam.rawValue
            ]])
            appendCard(teamActionsCard)
        }
    }
    
    private func populateData() {
        resetCards()
        addPlaceholderCard()
        addStatusCard()
        addDescriptionCard()
        addManagerCard()
        addSubTeamsCard()
        addMembersCard()
        addTeamActionsCard()
    }

    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(
        header: CircleCollectionReusableView,
        atIndexPath indexPath: NSIndexPath
    ) {
        
        super.configureHeader(header, atIndexPath: indexPath)
        if let teamHeader = header as? ProfileHeaderCollectionReusableView {
            if canEdit() {
                teamHeader.editImageButtonDelegate = editImageButtonDelegate
                teamHeader.setEditImageButtonHidden(false)
            }
            teamHeader.setTeam(team)
            profileHeaderView = teamHeader
        }
        
        if let headerView = header as? ProfileSectionHeaderCollectionReusableView,
            card = cardAtSection(indexPath.section) where card.allowEditingContent && canEdit() {
            headerView.showAddEditButton = true
        }
    }
    
    override func configureFooter(footer: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        if let footerView = footer as? CardFooterCollectionReusableView, card = cardAtSection(indexPath.section) {
            switch card.subType {
            case .Members:
                footerView.setButtonTitle(
                    NSString(
                        format: NSLocalizedString(
                            "View all %d People",
                            comment: "Title of the button to see all the people"
                        ),
                        profiles.count
                    ) as String
                )

            case .Teams:
                footerView.setButtonTitle(
                    NSString(
                        format: NSLocalizedString(
                            "View all %d Teams",
                            comment: "Title of the button to see all the teams"
                        ),
                        teams.count
                    ) as String
                )
                
            default:
                break
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let content = contentAtIndexPath(indexPath) as? [String: AnyObject], settingsCell = cell as? SettingsCollectionViewCell {
            settingsCell.itemLabel.textAlignment = .Center
            settingsCell.itemLabel.textColor = UIColor.appTintColor()
        }
    }
}
