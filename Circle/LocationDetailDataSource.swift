//
//  LocationDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationDetailDataSource: CardDataSource {
    
    var editImageButtonDelegate: EditImageButtonDelegate?
    var location: Services.Organization.Containers.LocationV1!
    var profileCellDelegate: ProfileCollectionViewCellDelegate?

    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var nextProfilesRequest: Soa.ServiceRequestV1?
    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    
    private let sectionHeaderClass = ProfileSectionHeaderCollectionReusableView.self
    
    private var isLoggedInUserPOC = false

    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)
    }
    
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
        if let card = cardAtSection(indexPath.section) {
            let isLastCell = (indexPath.row == card.content.count - 1)
            let isLastViewInSection = (isLastCell && !card.addFooter)
            
            if isLastViewInSection {
                cell.addRoundCorners(corners: .BottomLeft | .BottomRight, radius: 4.0)
            }
            else {
                cell.removeRoundedCorners()
            }
            
            cell.showSeparator = !isLastViewInSection
            
            if canEdit() {
                if let
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
    }
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            profileHeader.setLocation(location)
            profileHeaderView = profileHeader
        }
        else if let cardHeader = header as? ProfileSectionHeaderCollectionReusableView {
            cardHeader.addBottomBorder = true
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
                ProfileHeaderCollectionReusableView.height
            )
        )
        
        appendCard(placeholderCard)
    }
    
    private func addAddressCard() {

        // Address
        let addressCard = Card(cardType: .LocationsAddress, title: AppStrings.CardTitleAddress)
        addressCard.addContent(content: [location] as [AnyObject])
        appendCard(addressCard)
    }
    
    private func addDescriptionCard() {
        var description = ""

        if let value = location.description_?.value where value.trimWhitespace() != "" {
            description = value
        }
        
        if description != "" || canEdit() {
            
            let descriptionCard = Card(cardType: .TextValue, title: "Description")
            descriptionCard.addHeader(headerClass: sectionHeaderClass)
            descriptionCard.showContentCount = false
            descriptionCard.addContent(content: [
                TextData(
                    type: .LocationDescription,
                    andValue: description,
                    andTimestamp: location.description_?.changed,
                    andPlaceholder: NSLocalizedString(
                        "Add a description for your location",
                        comment: "Add a description to the location"
                    ),
                    andAuthor: location.description_?.byProfile
                )
            ])
            
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
            
            pointsOfContactCard.showContentCount = false
            pointsOfContactCard.addHeader(headerClass: sectionHeaderClass)
            
            if canEdit() {
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
    
    override func canEdit() -> Bool {
        if let permissions = self.location.permissions where permissions.canEdit {
            return true
        }

        return super.canEdit()
    }
}
