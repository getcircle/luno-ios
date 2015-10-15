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
    
    var team: Services.Organization.Containers.TeamV1!
    var textDataDelegate: TextValueCollectionViewDelegate?
    
    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?

    private(set) var managerProfile: Services.Profile.Containers.ProfileV1!
    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var profilesNextRequest: Soa.ServiceRequestV1?
    private(set) var teams = Array<Services.Organization.Containers.TeamV1>()
    
    private let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self

    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 60.0, 0.0, 0.0)
    }
    
    override func getTitle() -> String {
        return team.getName()
    }
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        
        if cards.count == 0 {
            addPlaceholderCard()
        }
        
        if AuthenticationViewController.getLoggedInUserProfile() != nil {
            
            var storedError: NSError!
            let actionsGroup = dispatch_group_create()

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
                    if let childTeams = childTeams {
                        self.teams = childTeams
                    }
                    
                    if let manager = manager {
                        self.managerProfile = manager
                    }
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
                    
                    if let nextRequest = nextRequest {
                        self.profilesNextRequest = nextRequest
                    }
                }
                dispatch_group_leave(actionsGroup)
            }
            
            dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
                self.profiles = self.profiles.filter({ (profile) -> Bool in
                    return self.managerProfile.id != profile.id
                })
                self.populateData()
                completionHandler(error: storedError)
            }
        }
    }
    
    override func canEdit() -> Bool {
        if let permissions = self.team.permissions where permissions.canEdit {
            return true
        }
        
        return super.canEdit()
    }
    
    private func addPlaceholderCard() {
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "")
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
        var statusText = ""
        var createdTimestamp = ""
        if let status = team.status {
            statusText = status.value
            createdTimestamp = status.changed
        }
        
        let statusCard = Card(cardType: .TextValue, title: AppStrings.ProfileSectionStatusTitle)
        let textData = TextData(
            type: .TeamStatus,
            andValue: statusText,
            andPlaceholder: NSLocalizedString(
                "Ask me!",
                comment: "Generic text indicating a person should be asked about this info"
            ),
            andTimestamp: createdTimestamp,
            andAuthor: team.status?.byProfile,
            andCanEdit: canEdit()
        )
        
        if canEdit() {
            statusCard.showContentCount = false
            statusCard.allowEditingContent = true
        }
        
        statusCard.addHeader(headerClass: sectionHeaderClass)
        statusCard.addContent(content: [textData])
        appendCard(statusCard)
    }
    
    private func addDescriptionCard() {
        var description = ""
        if let value = team.description_?.value where value.trimWhitespace() != "" {
            description = value
        }
        
        let descriptionCard = Card(cardType: .TextValue, title: "Description")
        descriptionCard.addHeader(headerClass: sectionHeaderClass)
        descriptionCard.showContentCount = false
        descriptionCard.addContent(content: [
            TextData(
                type: .TeamDescription, 
                andValue: description,
                andTimestamp: team.description_?.changed,
                andPlaceholder: NSLocalizedString(
                    "Ask me!",
                    comment: "Generic text indicating a person should be asked about this info"
                ),
                andAuthor: team.description_?.byProfile,
                andCanEdit: canEdit()
            )
        ])

        appendCard(descriptionCard)
    }
    
    private func addManagerCard() {
        if let manager = self.managerProfile {
            let managerCard = Card(cardType: .Profiles, title: "Manager")
            managerCard.showContentCount = false
            managerCard.addHeader(headerClass: sectionHeaderClass)
            managerCard.addContent(content: [manager])
            self.appendCard(managerCard)
        }
    }
    
    private func addSubTeamsCard() {
        if teams.count > 0 {
            let teamsCard = Card(
                cardType: .Profiles,
                subType: .Teams,
                title: AppStrings.TeamSubTeamsSectionTitle + " (" + String(teams.count) + ")"
            )
            teamsCard.showContentCount = false
            teamsCard.addHeader(headerClass: sectionHeaderClass)
            teamsCard.addContent(content: teams, maxVisibleItems: Card.MaxListEntries)
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
                title: membersCardTitle + " (" + String(team.profileCount - 1) + ")"
            )
            membersCard.showContentCount = false
            membersCard.addHeader(headerClass: sectionHeaderClass)
            membersCard.addContent(content: profiles, maxVisibleItems: Card.MaxListEntries)
            if profiles.count > Card.MaxListEntries {
                membersCard.addDefaultFooter()
            }
            appendCard(membersCard)
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
    }

    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(
        header: CircleCollectionReusableView,
        atIndexPath indexPath: NSIndexPath
    ) {
        
        super.configureHeader(header, atIndexPath: indexPath)
        if let teamHeader = header as? ProfileHeaderCollectionReusableView {
            teamHeader.setTeam(team)
            profileHeaderView = teamHeader
        }
        else if let cardHeader = header as? ProfileSectionHeaderCollectionReusableView {
            cardHeader.addBottomBorder = true
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
                        team.profileCount - 1
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
        let cellIsBottomOfSection = cellAtIndexPathIsBottomOfSection(indexPath)
        if cellIsBottomOfSection {
            cell.addRoundCorners([.BottomLeft, .BottomRight], radius: 4.0)
        }
        else {
            cell.removeRoundedCorners()
        }
        
        if (isLastCellAtIndexPath(indexPath)) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        cell.showSeparator = !cellIsBottomOfSection
        
        if let textValueCell = cell as? TextValueCollectionViewCell {
            textValueCell.delegate = textDataDelegate
        }
    }
}
