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
        placeholderSkillCard.addHeader(
            headerClass: SkillHeaderCollectionReusableView.self, 
            headerClassName: "SkillHeaderCollectionReusableView"
        )
        appendCard(placeholderSkillCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            let profile = AuthViewController.getLoggedInUserProfile()!
            ProfileService.Actions.getProfiles(skillId: selectedSkill!.id, organizationId: profile.organization_id) { (profiles, _, error) -> Void in
                if let profiles = profiles {
                    self.profiles.extend(profiles)
                    let peopleCard = Card(cardType: .Profiles, title: "People by Skill")
                    peopleCard.addContent(content: profiles as [AnyObject])
                    peopleCard.sectionInset = UIEdgeInsetsZero
                    self.appendCard(peopleCard)
                    completionHandler(error: nil)
                } else {
                    completionHandler(error: error)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let skillsHeader = header as? SkillHeaderCollectionReusableView {
            skillsHeader.setSkill(selectedSkill)
            profileHeaderView = skillsHeader
        }
    }
}
