//
//  GroupDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class GroupDetailDataSource: CardDataSource {
    var selectedGroup: Services.Group.Containers.GroupV1!
    
    private var members = Array<Services.Group.Containers.GroupV1>()
    private var adminMembers = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var groupHeaderView: GroupHeaderCollectionReusableView!
    private let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "Team Header")
        placeholderHeaderCard.sectionInset = UIEdgeInsetsZero
        placeholderHeaderCard.addHeader(
            headerClass: GroupHeaderCollectionReusableView.self
        )
        appendCard(placeholderHeaderCard)
        
        // Add a text value card for description
        let groupDescriptionCard = Card(cardType: .TextValue, title: "")
        groupDescriptionCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
        groupDescriptionCard.addContent(content: [selectedGroup.description_])
        appendCard(groupDescriptionCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            completionHandler(error: nil)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let groupHeader = header as? GroupHeaderCollectionReusableView {
            groupHeader.setData(selectedGroup)
            groupHeaderView = groupHeader
        }
    }
}
