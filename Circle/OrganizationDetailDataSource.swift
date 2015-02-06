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

    var selectedOrgId: String!
    var selectedOrg: OrganizationService.Containers.Organization!

    private(set) var profileHeaderView: OrganizationHeaderCollectionReusableView?

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if cards.count > 0 {
            return
        }
        
        // Get the header early
        let placeholderCard = Card(cardType: .Placeholder, title: "")
        appendCard(placeholderCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            LandingService.Actions.getOrganizationCategories(currentProfile.organization_id) { (categories, error) -> Void in
                if error == nil {
                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        if category.profiles.count > 0 {
                            var profiles = category.profiles
                            switch category.type {
                            case .Executives:
                                categoryCard.showContentCount = false

                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: 3)
                            categoryCard.addDefaultFooter()
                        } else if category.addresses.count > 0 {
                            categoryCard.addContent(content: category.addresses)
                        } else if category.skills.count > 0 {
                            categoryCard.addContent(content: category.skills, maxVisibleItems: 10)
                            categoryCard.addDefaultFooter()
                        } else if category.teams.count > 0 {
                            categoryCard.addContent(content: category.teams)
                        }
                        
                        categoryCard.headerSize = CGSizeMake(CircleCollectionViewCell.width, CardHeaderCollectionReusableView.height)
                        self.appendCard(categoryCard)
                    }
                    completionHandler(error: nil)
                }
            }
        }
    }

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "OrganizationHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: OrganizationHeaderCollectionReusableView.classReuseIdentifier
        )

        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(
        collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath
    ) -> UICollectionReusableView {
        if indexPath.section == 0 && kind == UICollectionElementKindSectionHeader {
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: OrganizationHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as OrganizationHeaderCollectionReusableView
            
            // profileHeaderView?.titleLabel = selectedOrg.name
            profileHeaderView = supplementaryView
            return supplementaryView
        }
        else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
    }
}
