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
    
    var selectedOffice: OrganizationService.Containers.Address!

    private(set) var profiles = Array<ProfileService.Containers.Profile>()
    private(set) var profileHeaderView: CircleCollectionReusableView?
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        // Add a Placeholder card for the map view
        let placeholderMapCard = Card(cardType: .Placeholder, title: "Map Header")
        placeholderMapCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderMapCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
            let sectionHeaderSize = CGSizeMake(
                ProfileSectionHeaderCollectionReusableView.width, 
                ProfileSectionHeaderCollectionReusableView.height
            )
            ProfileService.Actions.getProfiles(addressId: selectedOffice.id) { (profiles, error) -> Void in
                if error == nil && profiles != nil {
                    self.profiles.extend(profiles!)
                    
                    // Address
                    let addressCard = Card(cardType: .OfficeAddress, title: "Address")
                    addressCard.sectionInset = sectionInset
                    addressCard.addContent(content: [self.selectedOffice] as [AnyObject])
                    self.appendCard(addressCard)
                    
                    // People Count
                    let keyValueCard = Card(cardType: .KeyValue, title: "People")
                    let image = ItemImage.genericNextImage
                    var content: [String: AnyObject] = [
                        "name": AppStrings.CardTitlePeople,
                        "value": String(profiles!.count),
                        "image": image.name,
                        "imageTintColor": image.tint,
                        "type": ContentType.PeopleCount.rawValue
                    ]
    
                    if let imageSize = image.size {
                        content["imageSize"] = NSValue(CGSize: imageSize)
                    }
                    keyValueCard.addContent(content: [content] as [AnyObject])
                    keyValueCard.sectionInset = sectionInset
                    self.appendCard(keyValueCard)

                    // Teams
                    var teams = Array<OrganizationService.Containers.Team>()
                    for i in 0..<4 {
                        var team = OrganizationService.Containers.Team.builder()
                        team.name = "Product Development"
                        teams.append(team.build())
                    }
                    
                    let teamsCard = Card(cardType: .TeamsGrid, title: AppStrings.CardTitleOfficeTeam)
                    teamsCard.addContent(content: teams as [AnyObject])
                    teamsCard.sectionInset = sectionInset
                    teamsCard.headerSize = sectionHeaderSize
                    self.appendCard(teamsCard)

                    completionHandler(error: nil)
                } else {
                    completionHandler(error: error)
                }
            }
        }
    }

    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let profileCell = cell as? ProfileCollectionViewCell {
            profileCell.sizeMode = .Medium
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
            }
            else {
                let card = cardAtSection(indexPath.section)
                let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                    kind,
                    withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier,
                    forIndexPath: indexPath
                ) as ProfileSectionHeaderCollectionReusableView
                supplementaryView.setCard(card!)
                return supplementaryView
            }
    }
    
    func typeOfContent(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
            return ContentType(rawValue: (rowDataDictionary["type"] as Int!))!
        }
        
        return .Other
    }
}
