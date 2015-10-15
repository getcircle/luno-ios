//
//  ProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailDataSource: CardDataSource {

    var profile: Services.Profile.Containers.ProfileV1!
    var profileHeaderView: ProfileHeaderCollectionReusableView?
    var textDataDelegate: TextValueCollectionViewDelegate?
    
    private(set) var directReports: Array<Services.Profile.Containers.ProfileV1>?
    private(set) var location: Services.Organization.Containers.LocationV1?
    private(set) var manager: Services.Profile.Containers.ProfileV1?
    private(set) var managesTeam: Services.Organization.Containers.TeamV1?
    private(set) var peers: Array<Services.Profile.Containers.ProfileV1>?
    private(set) var team: Services.Organization.Containers.TeamV1?
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)
    }
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
    }
    
    override func getTitle() -> String {
        return profile.fullName
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        
        // If loading for the first time, add the placeholder card
        if cards.count == 0 {
            addPlaceholderCard()
        }

        var storedError: NSError!
        let actionsGroup = dispatch_group_create()
        
        dispatch_group_enter(actionsGroup)
        Services.Profile.Actions.getExtendedProfile(profile.id) {
            (profile, manager, peers, directReports, team, managesTeam, locations, error) -> Void in
            
            if let error = error {
                storedError = error
            }
            else {
                self.profile = profile
                self.directReports = directReports
                self.location = locations?.first
                self.manager = manager
                self.managesTeam = managesTeam
                self.peers = peers
                self.team = team
            }
            dispatch_group_leave(actionsGroup)
            completionHandler(error: error)
        }
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.populateData()
            completionHandler(error: storedError)
        }
    }

    // MARK: - Populate Data
    
    internal func populateData() {
        resetCards()
        addPlaceholderCard()
        addStatusCard()
        addContactsCard()
        addLocationCard()
        addManagerCard()
        addTeamCard()
        addManagesTeamCard()
        setDataInHeader()
    }
    
    internal func addPlaceholderCard() -> Card? {
        
        // Add placeholder card to load profile header instantly
        let card = Card(cardType: .Placeholder, title: "Info")
        card.addHeader(headerClass: ProfileHeaderCollectionReusableView.self)
        appendCard(card)
        return card
    }
    
    internal func addContactsCard() -> Card? {
        do {
            let card = Card(cardType: .ContactMethods, title: "Contact")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            var contactMethods = Array<Services.Profile.Containers.ContactMethodV1>()
            let emailContactMethod = Services.Profile.Containers.ContactMethodV1.Builder()
            emailContactMethod.contactMethodType = .Email
            emailContactMethod.value = profile.email
            emailContactMethod.label = "Email"
            contactMethods.append(try emailContactMethod.build())
            contactMethods.appendContentsOf(profile.contactMethods)
            
            var profileHasPhoneContactMethod = false
            for contactMethod in contactMethods {
                if contactMethod.contactMethodType == .Phone || contactMethod.contactMethodType == .CellPhone {
                    profileHasPhoneContactMethod = true
                }
            }
            
            if !profileHasPhoneContactMethod {
                let phoneContactMethod = Services.Profile.Containers.ContactMethodV1.Builder()
                phoneContactMethod.contactMethodType = .Phone
                phoneContactMethod.label = "Phone"
                contactMethods.append(try phoneContactMethod.build())
            }
            
            card.addContent(content: contactMethods)
            appendCard(card)
            return card
        }
        catch {
            print("Error: \(error)")
            
            return nil
        }
    }
    
    internal func addStatusCard() -> Card? {
        var statusText = ""
        var createdTimestamp = ""
        if let status = profile.status {
            statusText = status.value
            createdTimestamp = status.changed

        }
        
        let card = Card(
            cardType: .TextValue, 
            title: AppStrings.ProfileSectionStatusTitle
        )
        card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
        card.showContentCount = false
        card.addContent(content: [
            TextData(
                type: .ProfileStatus, 
                andValue: statusText,
                andPlaceholder: NSLocalizedString(
                    "Ask me!",
                    comment: "Generic text indicating a person should be asked about this info"
                ),
                andTimestamp: createdTimestamp,
                andCanEdit: canEdit()
            )
        ])
        appendCard(card)
        return card
    }
    
    internal func addLocationCard() -> Card? {
        if let location = location {
            let card = Card(cardType: .Profiles, title: "Works at")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.addContent(content: [location])
            appendCard(card)
            return card
        }
        
        return nil
    }
    
    internal func addManagerCard() -> Card? {
        var content = [AnyObject]()
        
        if let manager = manager {
            content.append(manager)
        }
        
        if content.count > 0 {
            let card = Card(cardType: .Profiles, title: "Reports to")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.addContent(content: content)
            appendCard(card)
            return card
        }
        
        return nil
    }

    internal func addTeamCard() -> Card? {
        var content = [AnyObject]()

        if let team = team {
            content.append(team)
        }
        
        if content.count > 0 {
            let card = Card(cardType: .Profiles, subType: .Teams, title: "Team")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.addContent(content: content)
            if self.peers?.count ?? 0 > 0 {
                card.addDefaultFooter()
            }
            appendCard(card)
            return card
        }

        return nil
    }
    
    internal func addManagesTeamCard() -> Card? {
        var content = [AnyObject]()
        
        if let managesTeam = managesTeam {
            content.append(managesTeam)
        }
        
        if content.count > 0 {
            let card = Card(cardType: .Profiles, subType: .ManagedTeams, title: "Manages")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.addContent(content: content)
            card.addDefaultFooter()
            appendCard(card)
            return card
        }
        
        return nil
    }

    // MARK: - Cell Type
    
    func typeOfCell(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
           return ContentType(rawValue: (rowDataDictionary["type"] as! Int!))!
        }
        else if let keyValueData = card.content[indexPath.row] as? KeyValueData {
            return keyValueData.type
        }

        return .Other
    }

    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            profileHeaderView = profileHeader
            setDataInHeader()
        }
        else if let cardHeader = header as? ProfileSectionHeaderCollectionReusableView, card = cardAtSection(indexPath.section) {
            if card.type == .ContactMethods {
                cardHeader.cardSubtitleLabel.hidden = false
                cardHeader.cardSubtitleLabel.text = location?.officeCurrentDateAndTimeLabel()
            }
            
            cardHeader.addBottomBorder = true
        }
    }
    
    override func configureFooter(footer: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureFooter(footer, atIndexPath: indexPath)
        
        if let footerView = footer as? CardFooterCollectionReusableView, card = cardAtSection(indexPath.section) {
            
            switch card.subType {
            case .Teams:
                let peerCount = self.peers?.count ?? 0
                var buttonTitle = NSString(format: NSLocalizedString(
                        "Works with %d Peers",
                        comment: "Text indicating number of peers a person works with"
                    ),
                    peerCount
                ) as String

                if peerCount == 1 {
                    buttonTitle = NSLocalizedString(
                        "Works with 1 Peer",
                        comment: "Text indicating one other person works with the user"
                    )
                }
                
                if peerCount == 0 {
                    footerView.setButtonEnabled(false)
                }
                
                footerView.setButtonTitle(buttonTitle)
                
            case .ManagedTeams:
                let directReportsCount = self.directReports?.count ?? 0
                var buttonTitle = NSString(format: NSLocalizedString(
                        "View %d Direct Reports",
                        comment: "Text indicating number of direct reports a person has"
                    ),
                    directReportsCount
                ) as String
                
                if directReportsCount == 1 {
                    buttonTitle = NSLocalizedString(
                        "View 1 Direct Report",
                        comment: "Text indicating this person has one direct report"
                    )
                }
                
                if directReportsCount == 0 {
                    footerView.setButtonEnabled(false)
                }

                footerView.setButtonTitle(buttonTitle)

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
        
        cell.showSeparator = !cellIsBottomOfSection
        
        if let profileCollectionViewCell = cell as? ProfileCollectionViewCell {
            profileCollectionViewCell.separatorInset = UIEdgeInsetsZero
        }
        else if let contactMethodCell = cell as? ContactCollectionViewCell {
            contactMethodCell.contactMethodValueLabel.textColor = UIColor.appPrimaryTextColor()
            contactMethodCell.separatorInset = UIEdgeInsetsMake(0.0, 72.0, 0.0, 0.0)
            
            if let contactMethod = contentAtIndexPath(indexPath) as? Services.Profile.Containers.ContactMethodV1 where contactMethod.value.characters.count == 0 {
                if isProfileLoggedInUserProfile() {
                    contactMethodCell.contactMethodValueLabel.text = AppStrings.ContactPlaceholderAddNumber
                    contactMethodCell.contactMethodValueLabel.textColor = UIColor.appMissingFieldValueColor()
                }
                else {
                    contactMethodCell.contactMethodValueLabel.text = AppStrings.ContactPlaceholderNumberNotAdded
                }
            }
        }
        else if let textDataCell = cell as? TextValueCollectionViewCell {
            textDataCell.delegate = textDataDelegate
        }
    }

    private func isProfileLoggedInUserProfile() -> Bool {
        if let loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile() {
            return loggedInUserProfile.id == profile.id
        }
        
        return false
    }
    
    private func setDataInHeader() {
        profileHeaderView?.setProfile(profile, location: location, team: team)
    }
}
