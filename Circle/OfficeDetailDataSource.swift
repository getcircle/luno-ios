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
    private(set) var profilesPaginator: Paginator?
    private(set) var teams = Array<OrganizationService.Containers.Team>()
    private(set) var profileHeaderView: CircleCollectionReusableView?
    
    private let defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
    private var defaultSectionHeaderSize = CGSizeMake(
        ProfileSectionHeaderCollectionReusableView.width,
        ProfileSectionHeaderCollectionReusableView.height
    )
    
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
        appendCard(placeholderCard)
        
        // Fetch data within a dispatch group, calling populateData when all tasks have finished
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        dispatch_group_enter(actionsGroup)
        OrganizationService.Actions.getTeams(locationId: self.selectedOffice.id) { (teams, error) -> Void in
            if let teams = teams {
                self.teams.extend(teams)
            }
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        }
        dispatch_group_enter(actionsGroup)
        ProfileService.Actions.getProfiles(locationId: self.selectedOffice.id) { (profiles, paginator, error) -> Void in
            if let profiles = profiles {
                self.profiles.extend(profiles)
                self.profilesPaginator = paginator
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
    
    // MARK: - Supplementary View

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )
        
        collectionView.registerNib(
            UINib(nibName: "ProfileSectionHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileHeaderCollectionReusableView
            
            supplementaryView.setOffice(selectedOffice)
            profileHeaderView = supplementaryView
            return supplementaryView
        } else if kind == UICollectionElementKindSectionHeader {
            let card = cardAtSection(indexPath.section)
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileSectionHeaderCollectionReusableView
            supplementaryView.setCard(card!)
            return supplementaryView
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
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
            "value": String(profilesPaginator?.count ?? 0),
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
            let teamsCard = Card(cardType: .TeamsGrid, title: AppStrings.CardTitleOfficeTeam)
            teamsCard.addContent(content: teams as [AnyObject])
            teamsCard.sectionInset = UIEdgeInsetsZero
            teamsCard.headerSize = defaultSectionHeaderSize
            appendCard(teamsCard)
        }
        
    }
}
