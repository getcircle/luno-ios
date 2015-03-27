//
//  InterestDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class InterestDetailDataSource: CardDataSource {
    
    var selectedInterest: ProfileService.Containers.Tag!
    
    private var profiles = Array<ProfileService.Containers.Profile>()
    private(set) var profileHeaderView: InterestHeaderCollectionReusableView?
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        // Add a placeholder card for interest view
        let placeholderInterestCard = Card(cardType: .Placeholder, title: "Interest Header")
        placeholderInterestCard.sectionInset = UIEdgeInsetsZero
        placeholderInterestCard.addHeader(headerClass: InterestHeaderCollectionReusableView.self)
        appendCard(placeholderInterestCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            let profile = AuthViewController.getLoggedInUserProfile()!
            ProfileService.Actions.getProfiles(interestId: selectedInterest!.id, organizationId: profile.organization_id) { (profiles, _, error) -> Void in
                if let profiles = profiles {
                    self.profiles.extend(profiles)
                    let peopleCard = Card(cardType: .Profiles, title: "People by Interest")
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
        
        if let interestsHeader = header as? InterestHeaderCollectionReusableView {
            interestsHeader.setInterest(selectedInterest)
            profileHeaderView = interestsHeader
        }
    }
}
