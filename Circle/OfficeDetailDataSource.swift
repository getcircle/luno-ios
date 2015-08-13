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
    var profileCellDelegate: ProfileCollectionViewCellDelegate?

    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var nextProfilesRequest: Soa.ServiceRequestV1?
    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    
    private let defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    private let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self
    
    private var isLoggedInUserPOC = false
    
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
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if canEdit() {
            if let
                card = cardAtSection(indexPath.section),
                cell = cell as? ProfileCollectionViewCell
                where card.subType == .PointsOfContact
            {
                if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile(),
                    content: AnyObject = contentAtIndexPath(indexPath)
                    where (content as! Services.Profile.Containers.ProfileV1).id == loggedInUserProfile.id {
                        cell.supportAddButton(isLoggedInUserPOC)
                        cell.delegate = profileCellDelegate
                }
            }
        }
    }
    
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
    
    override func configureFooter(footer: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        if let footerView = footer as? CardFooterCollectionReusableView {
            footerView.setButtonTitle(
                NSString(
                    format: NSLocalizedString("View all %d People", comment: "Title of the button to see all the people"),
                    location.profileCount
                ) as String
            )
        }
    }

    // MARK: - Helpers
    
    private func addPlaceholderCard() {
        
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        placeholderCard.sectionInset = UIEdgeInsetsZero
        placeholderCard.addHeader(
            headerClass: ProfileHeaderCollectionReusableView.self,
            headerSize: CGSizeMake(
                ProfileHeaderCollectionReusableView.width,
                ProfileHeaderCollectionReusableView.heightWithoutSecondaryInfo
            )
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
        if location.locationDescription?.value.trimWhitespace() != "" || canEdit() {
            var description = NSLocalizedString("Add a description", comment: "Add a description to the location")
            if let value = location.locationDescription?.value where value.trimWhitespace() != "" {
                description = value
            }
            
            let descriptionCard = Card(cardType: .TextValue, title: "Description")
            descriptionCard.sectionInset = defaultSectionInset
            descriptionCard.addContent(content: [
                TextData(type: .LocationDescription, andValue: description)
            ])
            
            if canEdit() {
                descriptionCard.showContentCount = false
                descriptionCard.addHeader(headerClass: sectionHeaderClass)
                descriptionCard.allowEditingContent = true
            }
            
            appendCard(descriptionCard)
        }
    }
    
    private func addPointOfContactCard() {
        
        // Show points of contact section if there is data or user can edit
        // Show existing points of contact with logged in user at the bottom
        // Show checked or unchecked status
        if location.pointsOfContact.count > 0 || canEdit() {
            let pointsOfContactCard = Card(
                cardType: .Profiles,
                subType: .PointsOfContact,
                title: NSString(
                    format: NSLocalizedString(
                        "Points of Contact (%d)",
                        comment: "Section showing points of contact (people) at a location"
                    ),
                    location.pointsOfContact.count
                ) as String
            )
            
            pointsOfContactCard.sectionInset = defaultSectionInset
            if canEdit() {
                pointsOfContactCard.showContentCount = false
                pointsOfContactCard.addHeader(headerClass: sectionHeaderClass)
                
                if let loggedInProfile = AuthViewController.getLoggedInUserProfile() {
                    isLoggedInUserPOC = false
                    var pocsInModifiedOrder = Array<Services.Profile.Containers.ProfileV1>()
                    
                    // Check if logged in user is already a POC or not
                    // Add them to the last position
                    for pocProfile in location.pointsOfContact {
                        if loggedInProfile.id == pocProfile.id {
                            isLoggedInUserPOC = true
                        }
                        else {
                            pocsInModifiedOrder.append(pocProfile)
                        }
                    }
                    
                    pocsInModifiedOrder.append(loggedInProfile)
                    pointsOfContactCard.addContent(content: pocsInModifiedOrder)
                }
            }
            else if location.pointsOfContact.count > 0 {
                pointsOfContactCard.addContent(content: location.pointsOfContact)
            }
            
            appendCard(pointsOfContactCard)
        }
    }
    
    private func addPeopleCard() {
        if profiles.count > 0 {
            let profilesCard = Card(
                cardType: .Profiles,
                subType: .Members,
                title: AppStrings.CardTitlePeople + " (" + String(location.profileCount) + ")",
                contentCount: Int(location.profileCount)
            )
            profilesCard.addContent(content: profiles as [AnyObject], maxVisibleItems: Card.MaxListEntries)
            profilesCard.sectionInset = defaultSectionInset
            profilesCard.addHeader(headerClass: sectionHeaderClass)
            if profiles.count > Card.MaxListEntries {
                profilesCard.addDefaultFooter()
            }
            appendCard(profilesCard)
        }
    }

    private func populateData() {
        resetCards()
        addPlaceholderCard()
        addAddressCard()
        addDescriptionCard()
        addPointOfContactCard()
        addPeopleCard()
    }
    
    private func canEdit() -> Bool {
        if let permissions = self.location.permissions where permissions.canEdit {
            return true
        }

        return false
    }
}
