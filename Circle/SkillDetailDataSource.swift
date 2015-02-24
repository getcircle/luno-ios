//
//  SkillDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SkillDetailDataSource: CardDataSource {
    
    var selectedSkill: ProfileService.Containers.Skill!
    
    private var profiles = Array<ProfileService.Containers.Profile>()
    private(set) var profileHeaderView: SkillHeaderCollectionReusableView?
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        // Add a placeholder card for skill view
        let placeholderSkillCard = Card(cardType: .Placeholder, title: "Skill Header")
        placeholderSkillCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderSkillCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            let profile = AuthViewController.getLoggedInUserProfile()!
            ProfileService.Actions.getProfiles(skillId: selectedSkill!.id, organizationId: profile.organization_id) { (profiles, error) -> Void in
                if error == nil {
                    self.profiles.extend(profiles!)
                    let peopleCard = Card(cardType: .People, title: "People by Skill")
                    peopleCard.addContent(content: profiles! as [AnyObject])
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
        }
    }
    
    // MARK: - Supplementary View
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "SkillHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SkillHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: SkillHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as SkillHeaderCollectionReusableView
            supplementaryView.skillNameLabel.attributedText = NSAttributedString(string: selectedSkill.name.uppercaseString, attributes: [NSKernAttributeName: 2.0])
            
            profileHeaderView = supplementaryView
            return supplementaryView
    }
}
