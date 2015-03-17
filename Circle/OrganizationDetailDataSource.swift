//
//  OrganizationDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OrganizationDetailDataSource: CardDataSource {

    private(set) var profileHeaderView: OrganizationHeaderCollectionReusableView?

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if cards.count > 0 {
            return
        }
        
        // Get the header early
        let placeholderCard = Card(cardType: .Placeholder, title: "")
        placeholderCard.addHeader(headerClass: OrganizationHeaderCollectionReusableView.self)
        placeholderCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            LandingService.Actions.getOrganizationCategories(currentProfile.organization_id) { (categories, error) -> Void in
                if error == nil {
                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        categoryCard.addDefaultHeader()
                        if category.profiles.count > 0 {
                            var profiles = category.profiles
                            switch category.type {
                            case .Executives:
                                categoryCard.showContentCount = false

                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: 3)
                            categoryCard.addDefaultFooter()
                        } else if category.locations.count > 0 {
                            categoryCard.addContent(content: category.locations)
                        } else if category.skills.count > 0 {
                            categoryCard.addContent(content: category.skills, maxVisibleItems: 10)
                        } else if category.teams.count > 0 {
                            categoryCard.addContent(content: category.teams, maxVisibleItems: 6)
                        }
                        
                        self.appendCard(categoryCard)
                    }
                    completionHandler(error: nil)
                }
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let orgHeader = header as? OrganizationHeaderCollectionReusableView {
            profileHeaderView = orgHeader
            if let currentOrganization = AuthViewController.getLoggedInUserOrganization() {
                orgHeader.setOrganization(currentOrganization)
            }
        }
    }
}
