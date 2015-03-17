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
    
    var selectedOffice: OrganizationService.Containers.Location!

    private(set) var profiles = Array<ProfileService.Containers.Profile>()
    private(set) var nextProfilesRequest: ServiceRequest?
    private(set) var teams = Array<OrganizationService.Containers.Team>()
    private(set) var nextTeamsRequest: ServiceRequest?
    private(set) var profileHeaderView: CircleCollectionReusableView?
    
    private let defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        resetCards()
        
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        placeholderCard.sectionInset = UIEdgeInsetsZero
        placeholderCard.addHeader(
            headerClass: ProfileHeaderCollectionReusableView.self
        )
        appendCard(placeholderCard)
        
        // Fetch data within a dispatch group, calling populateData when all tasks have finished
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        dispatch_group_enter(actionsGroup)
        OrganizationService.Actions.getTeams(locationId: self.selectedOffice.id) { (teams, nextRequest, error) -> Void in
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
        ProfileService.Actions.getProfiles(locationId: self.selectedOffice.id) { (profiles, nextRequest, error) -> Void in
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

    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let profileCell = cell as? ProfileCollectionViewCell {
            let profile = contentAtIndexPath(indexPath) as? ProfileService.Containers.Profile
            profileCell.subTextLabel.text = profile?.title
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            profileHeader.setOffice(selectedOffice)
            profileHeaderView = profileHeader
        }
    }
    
    func typeOfContent(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
            return ContentType(rawValue: (rowDataDictionary["type"] as Int!))!
        }
        
        
        return .Other
    }
    
    // MARK: - Helpers
    private func populateData() {
        
        // Address
        let addressCard = Card(cardType: .OfficeAddress, title: AppStrings.CardTitleAddress)
        addressCard.sectionInset = defaultSectionInset
        addressCard.addContent(content: [selectedOffice.address] as [AnyObject])
        appendCard(addressCard)
        
        
        // People Count
        let keyValueCard = Card(cardType: .KeyValue, title: AppStrings.CardTitlePeople)
        let image = ItemImage.genericNextImage
        var content: [String: AnyObject] = [
            "name": AppStrings.CardTitlePeople,
            "value": String(nextProfilesRequest?.getFirstPaginator().count ?? 0),
            "image": image.name,
            "imageTintColor": image.tint,
            "type": ContentType.PeopleCount.rawValue
        ]
        
        if let imageSize = image.size {
            content["imageSize"] = NSValue(CGSize: imageSize)
        }
        keyValueCard.addContent(content: [content] as [AnyObject])
        keyValueCard.sectionInset = defaultSectionInset
        appendCard(keyValueCard)
        
        // Teams
        if teams.count > 0 {
            let teamsCard = Card(
                cardType: .TeamsGrid,
                title: AppStrings.CardTitleOfficeTeam,
                contentCount: nextTeamsRequest?.getFirstPaginator().countAsInt() ?? 0
            )
            teamsCard.addContent(content: teams as [AnyObject], maxVisibleItems: 6)
            teamsCard.sectionInset = UIEdgeInsetsZero
            teamsCard.addHeader(
                headerClass: ProfileSectionHeaderCollectionReusableView.self
            )
            appendCard(teamsCard)
        }
    }
}
