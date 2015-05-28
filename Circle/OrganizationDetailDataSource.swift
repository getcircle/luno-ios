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

    private var supportGoogleGroups = false
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        
        // Get the header early
        let placeholderCard = Card(cardType: .Placeholder, title: "")
        placeholderCard.addHeader(headerClass: OrganizationHeaderCollectionReusableView.self)
        placeholderCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            var storedError: NSError!
            var actionsGroup = dispatch_group_create()
            
            dispatch_group_enter(actionsGroup)
            Services.Feed.Actions.getOrganizationFeed(currentProfile.organizationId) { (categories, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        categoryCard.addDefaultHeader()
                        if category.profiles.count > 0 {
                            var profiles = category.profiles
                            switch category.categoryType {
                            case .Executives:
                                categoryCard.showContentCount = false

                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: 3)
                            categoryCard.addDefaultFooter()
                        } else if category.locations.count > 0 {
                            categoryCard.addContent(content: category.locations)
                        } else if category.tags.count > 0 {
                            categoryCard.addContent(content: category.tags, maxVisibleItems: 10)
                        } else if category.teams.count > 0 {
                            categoryCard.addContent(content: category.teams, maxVisibleItems: 6)
                        }
                        
                        self.appendCard(categoryCard)
                    }
                }
                
                dispatch_group_leave(actionsGroup)
            }
            
            dispatch_group_enter(actionsGroup)
            Services.Organization.Actions.getIntegrationStatus(.GoogleGroups, completionHandler: { (status, error) -> Void in
                
                if let error = error {
                    storedError = error
                }
                else if status {
                    self.supportGoogleGroups = true
                }
                dispatch_group_leave(actionsGroup)
            })
            
            dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
                self.addGroupsCard()
                completionHandler(error: storedError)
            }
        }
    }
    
    private func addGroupsCard() {
        if supportGoogleGroups {
            let groupsCard = Card(cardType: .KeyValue, title: AppStrings.ProfileSectionGroupsTitle)
            var dataDict: [String: AnyObject] = [
                "name": AppStrings.ProfileSectionGroupsTitle,
                "value": " ",
                "image": ItemImage.genericNextImage.name,
                "imageTintColor": ItemImage.genericNextImage.tint,
                "imageSize": NSValue(CGSize: ItemImage.genericNextImage.size!)
            ]
            
            groupsCard.addContent(content: [dataDict])
            appendCard(groupsCard)
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
