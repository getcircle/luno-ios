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
    
    private(set) var address: Services.Organization.Containers.AddressV1?
    private(set) var groups: Array<Services.Group.Containers.GroupV1>?
    private(set) var location: Services.Organization.Containers.LocationV1?
    private(set) var manager: Services.Profile.Containers.ProfileV1?
    private(set) var team: Services.Organization.Containers.TeamV1?

    private var supportGoogleGroups = false
    
    internal let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
    internal let sectionInsetWithLargerBootomMargin = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        
        // If loading for the first time, add the placeholder card
        if cards.count == 0 {
            addPlaceholderCard()
        }

        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        
        dispatch_group_enter(actionsGroup)
        Services.Profile.Actions.getExtendedProfile(profile.id) {
            (profile, manager, team, address, location,  error) -> Void in
            
            if let error = error {
                storedError = error
            }
            else {
                self.manager = manager
                self.team = team
                self.address = address
                self.location = location
            }
            dispatch_group_leave(actionsGroup)
            completionHandler(error: error)
        }
        
        dispatch_group_enter(actionsGroup)
        Services.Organization.Actions.getIntegrationStatus(.GoogleGroups, completionHandler: { (status, error) -> Void in
            
            if let error = error {
                storedError = error
            }
            else if status {
                self.supportGoogleGroups = status
            }
            dispatch_group_leave(actionsGroup)
        })
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.populateData()
            completionHandler(error: storedError)
        }
    }

    // MARK: - Populate Data
    
    internal func populateData() {
        resetCards()
        addPlaceholderCard()
        addContactsCard()
        addStatusCard()
        addLocationCard()
        addManagerCard()
        addTeamCard()
        addGroupsCard()
        setDataInHeader()
    }
    
    internal func addPlaceholderCard() -> Card? {
        
        // Add placeholder card to load profile header instantly
        var card = Card(cardType: .Placeholder, title: "Info")
        card.addHeader(headerClass: ProfileHeaderCollectionReusableView.self)
        card.sectionInset = UIEdgeInsetsZero
        appendCard(card)
        return card
    }

    internal func addContactsCard() -> Card? {
        let card = Card(cardType: .QuickActions, title: "")
        card.sectionInset = sectionInset
        card.addContent(content: [["profile": profile]], maxVisibleItems: 0)
        appendCard(card)
        return card
    }
    
    internal func addStatusCard() -> Card? {
        var statusText = "I am working on.."
        if let status = profile.status {
            statusText = status.value
        }
        
        let card = Card(cardType: .TextValue, title: "Status")
        card.sectionInset = sectionInsetWithLargerBootomMargin
        card.addContent(content: [
            TextData(type: .ProfileStatus, andValue: statusText)
        ])
        appendCard(card)
        return card
    }
    
    internal func addLocationCard() -> Card? {
        //TODO: Add seating info and timezone
        if let location = location {
            let card = Card(cardType: .Profiles, title: "Works at")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.sectionInset = sectionInsetWithLargerBootomMargin
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
            card.sectionInset = sectionInsetWithLargerBootomMargin
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
            let card = Card(cardType: .Profiles, title: "Team")
            card.showContentCount = false
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.sectionInset = sectionInsetWithLargerBootomMargin
            card.addContent(content: content)
            appendCard(card)
            return card
        }
        
        return nil
    }

    internal func addGroupsCard() {
        if supportGoogleGroups {
            //TODO: Add groups card
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is QuickActionsCollectionViewCell {
            let quickActionsCell = cell as! QuickActionsCollectionViewCell
            quickActionsCell.backgroundColor = UIColor.whiteColor()
            quickActionsCell.quickActions = [.Phone, .Message, .Email, .MoreInfo]
        }
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
    }

    private func isProfileLoggedInUserProfile() -> Bool {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            return loggedInUserProfile.id == profile.id
        }
        
        return false
    }
    
    private func setDataInHeader() {
        profileHeaderView?.setProfile(profile, location: location)
    }
}
