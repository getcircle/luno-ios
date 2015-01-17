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
    var selectedTeam: OrganizationService.Containers.Team!
    
    private var profiles = Array<ProfileService.Containers.Profile>()
    private var ownerProfile: ProfileService.Containers.Profile!
    private(set) var profileHeaderView: TagHeaderCollectionReusableView!
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        // Add a placeholder card for tag view
        let placeholderTagCard = Card(cardType: .Placeholder, title: "Tag Header")
        placeholderTagCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderTagCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            ProfileService.Actions.getProfiles(selectedTeam!.id) { (profiles, error) -> Void in
                if error == nil {
                    // Add Owner Card
                    var allProfilesExceptOwner = profiles?.filter({ (profile) -> Bool in
                        if profile.user_id == self.selectedTeam.owner_id {
                            self.ownerProfile = profile
                            return false
                        }
                        
                        return true
                    })
                    
                    if let owner = self.ownerProfile {
                        let ownerCard = Card(cardType: .People, title: "Team Lead")
                        ownerCard.content.append(self.ownerProfile)
                        ownerCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
                        self.appendCard(ownerCard)
                    }
                    
                    // Add Members Card
                    if allProfilesExceptOwner?.count > 0 {
                        self.profiles.extend(allProfilesExceptOwner!)
                        let membersCard = Card(cardType: .People, title: "Team Members")
                        membersCard.content.extend(allProfilesExceptOwner! as [AnyObject])
                        membersCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
                        self.appendCard(membersCard)
                    }
                    
                    completionHandler(error: nil)
                }
                else {
                    completionHandler(error: error)
                }
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
        if let profileCell = cell as? ProfileCollectionViewCell {
            profileCell.sizeMode = .Medium
        }
    }
    
    // MARK: - Supplementary View
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "TagHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: TagHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: TagHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
                ) as TagHeaderCollectionReusableView
            supplementaryView.tagNameLabel.attributedText = NSAttributedString(string: selectedTeam.name.uppercaseString, attributes: [NSKernAttributeName: 2.0])
            supplementaryView.tagNameLabel.layer.borderWidth = 0.0
            
            profileHeaderView = supplementaryView
            return supplementaryView
    }
}
