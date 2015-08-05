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
    
    var selectedOffice: Services.Organization.Containers.LocationV1!

    private(set) var profiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var nextProfilesRequest: Soa.ServiceRequestV1?
    private(set) var teams = Array<Services.Organization.Containers.TeamV1>()
    private(set) var nextTeamsRequest: Soa.ServiceRequestV1?
    private(set) var profileHeaderView: CircleCollectionReusableView?
    
    private let defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        addPlaceholderCard()
        
        // Fetch data within a dispatch group, calling populateData when all tasks have finished
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        
        if selectedOffice.address == nil { 
            dispatch_group_enter(actionsGroup)
            Services.Organization.Actions.getLocation(locationId: selectedOffice.id, completionHandler: { (location, error) -> Void in
                if let location = location {
                    self.selectedOffice = location
                }
                
                if let error = error {
                    storedError = error
                }
                dispatch_group_leave(actionsGroup)
            })
        }

        dispatch_group_enter(actionsGroup)
        Services.Organization.Actions.getTeams(locationId: self.selectedOffice.id) { (teams, nextRequest, error) -> Void in
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
        Services.Profile.Actions.getProfiles(locationId: self.selectedOffice.id) { (profiles, nextRequest, error) -> Void in
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
            profileHeader.setOffice(selectedOffice)
            profileHeaderView = profileHeader
        }
    }
    
    func typeOfContent(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
            return ContentType(rawValue: (rowDataDictionary["type"] as! Int!))!
        }
        
        
        return .Other
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

    private func populateData() {
        
        resetCards()
        addPlaceholderCard()
        
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
            "value": String(selectedOffice.profileCount),
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
                cardType: .Profiles,
                title: AppStrings.CardTitleOfficeTeam,
                contentCount: nextTeamsRequest?.getPaginator().countAsInt() ?? teams.count
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
