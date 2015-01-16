//
//  TagDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagDetailDataSource: CardDataSource {
    
    var selectedTag: ProfileService.Containers.Tag!
    
    private var profiles = Array<ProfileService.Containers.Profile>()
    private(set) var profileHeaderView: TagHeaderCollectionReusableView?
    
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
            ProfileService.Actions.getProfiles(tagId: selectedTag!.id) { (profiles, error) -> Void in
                if error == nil {
                    self.profiles.extend(profiles!)
                    let peopleCard = Card(cardType: .People, title: "Direct Reports")
                    peopleCard.content.extend(profiles! as [AnyObject])
                    peopleCard.sectionInset = UIEdgeInsetsZero
                    self.appendCard(peopleCard)
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
            supplementaryView.tagNameLabel.attributedText = NSAttributedString(string: selectedTag.name.uppercaseString, attributes: [NSKernAttributeName: 2.0])
            
            profileHeaderView = supplementaryView
            return supplementaryView
    }
}
