//
//  OfficeDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficeDetailDataSource: CardDataSource {
    
    var editImageButtonDelegate: EditImageButtonDelegate?
    var location: Services.Organization.Containers.LocationV1!

    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var nextProfilesRequest: Soa.ServiceRequestV1?
    private(set) var teams = Array<Services.Organization.Containers.TeamV1>()
    private(set) var nextTeamsRequest: Soa.ServiceRequestV1?
    private(set) var profileHeaderView: CircleCollectionReusableView?
    
    private let defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    private let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        addPlaceholderCard()
        
        // Fetch data within a dispatch group, calling populateData when all tasks have finished
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        
        dispatch_group_enter(actionsGroup)
        Services.Organization.Actions.getLocation(locationId: location.id, completionHandler: { (location, error) -> Void in
            if let location = location {
                self.location = location
            }
            
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        })

        dispatch_group_enter(actionsGroup)
        Services.Organization.Actions.getTeams(locationId: self.location.id) { (teams, nextRequest, error) -> Void in
            if let teams = teams {
                self.teams.extend(teams)
                self.nextTeamsRequest = nextRequest
            }
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        }
        
        dispatch_group_enter(actionsGroup)
        Services.Profile.Actions.getProfiles(locationId: self.location.id) { (profiles, nextRequest, error) -> Void in
            if let profiles = profiles {
                self.profiles.extend(profiles)
                self.nextProfilesRequest = nextRequest
            }
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        }
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.populateData()
            completionHandler(error: storedError)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            if canEdit() {
                profileHeader.editImageButtonDelegate = editImageButtonDelegate
                profileHeader.setEditImageButtonHidden(false)
            }
            profileHeader.setOffice(location)
            profileHeaderView = profileHeader
        }
        
        if let headerView = header as? ProfileSectionHeaderCollectionReusableView,
            card = cardAtSection(indexPath.section) where card.allowEditingContent && canEdit() {
                headerView.showAddEditButton = true
        }        
    }

    // MARK: - Helpers
    
    private func addPlaceholderCard() {
        
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        placeholderCard.sectionInset = UIEdgeInsetsZero
        placeholderCard.addHeader(
            headerClass: ProfileHeaderCollectionReusableView.self
        )
        
        appendCard(placeholderCard)
    }
    
    private func addAddressCard() {
        // Address
        let addressCard = Card(cardType: .OfficeAddress, title: AppStrings.CardTitleAddress)
        addressCard.sectionInset = defaultSectionInset
        addressCard.addContent(content: [location.address] as [AnyObject])
        appendCard(addressCard)
    }
    
    private func addDescriptionCard() {
        if location.description_.trimWhitespace() != "" || canEdit() {
            
            let descriptionCard = Card(cardType: .TextValue, title: "Description")
            descriptionCard.sectionInset = defaultSectionInset
            descriptionCard.addContent(content: [
                TextData(type: .LocationDescription, andValue: location.description_)
            ])
            
            if canEdit() {
                descriptionCard.showContentCount = false
                descriptionCard.addHeader(headerClass: sectionHeaderClass)
                descriptionCard.allowEditingContent = true
            }
            
            appendCard(descriptionCard)
        }
    }
    
    private func addPeopleCard() {
        if profiles.count > 0 {
            let profilesCard = Card(
                cardType: .Profiles, 
                title: AppStrings.CardTitlePeople, 
                contentCount: Int(location.profileCount)
            )
            profilesCard.addContent(content: profiles as [AnyObject], maxVisibleItems: 3)
            profilesCard.sectionInset = defaultSectionInset
            profilesCard.addHeader(headerClass: sectionHeaderClass)
            appendCard(profilesCard)
        }
    }

    private func addTeamsCard() {
        // Teams
        if teams.count > 0 {
            let teamsCard = Card(
                cardType: .Profiles,
                title: AppStrings.CardTitleOfficeTeam,
                contentCount: nextTeamsRequest?.getPaginator().countAsInt() ?? teams.count
            )
            teamsCard.addContent(content: teams as [AnyObject], maxVisibleItems: 3)
            teamsCard.sectionInset = defaultSectionInset
            teamsCard.addHeader(headerClass: sectionHeaderClass)
            appendCard(teamsCard)
        }
    }

    private func populateData() {
        resetCards()
        addPlaceholderCard()
        addAddressCard()
        addDescriptionCard()
        addPeopleCard()
        addTeamsCard()
    }
    
    private func canEdit() -> Bool {
        if let permissions = self.location.permissions where permissions.canEdit {
            return true
        }

        // TODO: Set to false once persmissions are being returned
        return true
    }
}
