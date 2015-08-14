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

    private(set) var managerProfile: Services.Profile.Containers.ProfileV1!
    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var teams = Array<Services.Organization.Containers.TeamV1>()
    
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

            // Fetch extended team details
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
            
            // Fetch reporting info
            dispatch_group_enter(actionsGroup)
            Services.Organization.Actions.getTeamReportingDetails(team.id) { (members, childTeams, manager, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    // TODO we should safely unwrap these better to handle cases where we don't have data
                    self.teams = childTeams!
                    self.managerProfile = manager!
                }
                dispatch_group_leave(actionsGroup)
            }
            
            // Fetch members
            dispatch_group_enter(actionsGroup)
            Services.Profile.Actions.getProfiles(team.id) { (profiles, nextRequest, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    if let profiles = profiles {
                        // TODO update whatever counts there are of this
                        self.profiles = profiles
                    }
                }
                dispatch_group_leave(actionsGroup)
            }
            
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
            let textData = TextData(
                type: .TeamStatus,
                andValue: team.status?.value ?? "",
                andPlaceholder: NSLocalizedString("Add details",
                    comment: "Generic text asking user to add details"
                ),
                andTimestamp: createdTimestamp,
                andAuthor: team.status?.byProfile
            )

            if canEdit() {
                statusCard.showContentCount = false
                statusCard.addHeader(headerClass: sectionHeaderClass)
                statusCard.allowEditingContent = true
                statusCard.addContent(content: [textData])
            }
            else if let status = team.status where team.status.value.trimWhitespace() != "" {
                statusCard.addContent(content: [textData])
            }
            
            appendCard(statusCard)
        }
    }
    
    private func addDescriptionCard() {
        var description = ""
        if let value = team.description_?.value where value.trimWhitespace() != "" {
            description = value
        }
        
        if description != "" || canEdit() {
            
            let descriptionCard = Card(cardType: .TextValue, title: "Description")
            descriptionCard.addHeader(headerClass: sectionHeaderClass)
            descriptionCard.showContentCount = false
            descriptionCard.sectionInset = self.sectionInset
            descriptionCard.allowEditingContent = canEdit()
            descriptionCard.addContent(content: [
                TextData(
                    type: .TeamDescription, 
                    andValue: description,
                    andTimestamp: team.description_?.changed,
                    andPlaceholder: NSLocalizedString(
                        "Add a description for your team", 
                        comment: "Add a description to the team"
                    ),
                    andAuthor: team.description_?.byProfile
                )
            ])

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
