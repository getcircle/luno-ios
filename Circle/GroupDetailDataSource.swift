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
    
    private(set) var memberProfiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var managerMemberProfiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var nextManagerMembersRequest: Soa.ServiceRequestV1?
    private(set) var nextMembersRequest: Soa.ServiceRequestV1?
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
        
        let groupEmailCard = Card(cardType: .KeyValue, title: "")
        groupEmailCard.sectionInset = UIEdgeInsetsZero
        groupEmailCard.addContent(content: [["name" : AppStrings.QuickActionEmailLabel, "value": selectedGroup.email]])
        appendCard(groupEmailCard)
        
        if selectedGroup.groupDescription.trimWhitespace() != "" {
            // Add a text value card for description
            let groupDescriptionCard = Card(cardType: .TextValue, title: "")
            groupDescriptionCard.sectionInset = sectionInset
            groupDescriptionCard.addContent(content: [selectedGroup.groupDescription])
            appendCard(groupDescriptionCard)
        }
        else {
            groupEmailCard.sectionInset = sectionInset
        }
        
        // Fetch data within a dispatch group, calling populateData when all tasks have finished
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        dispatch_group_enter(actionsGroup)
        
        // Fetch group managers
        Services.Group.Actions.listMembers(selectedGroup.email, role: .Manager) {
            (members, nextRequest, error) -> Void in
            if let members = members {
                self.managerMemberProfiles.extend(members.map({ $0.profile }))
                self.nextManagerMembersRequest = nextRequest
            }
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        }
        dispatch_group_enter(actionsGroup)
        
        Services.Group.Actions.listMembers(selectedGroup.email, role: .Member) {
            (members, nextRequest, error) -> Void in
            if let members = members {
                self.memberProfiles.extend(members.map({ $0.profile }))
                self.nextMembersRequest = nextRequest
            }
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        }
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.populateData()
            completionHandler(error: storedError)
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
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let content = contentAtIndexPath(indexPath) as? [String: AnyObject] where cell is SettingsCollectionViewCell {
            (cell as! SettingsCollectionViewCell).itemLabel.textAlignment = .Center
            if let contentType = content["type"] as? Int where ContentType(rawValue: contentType) == ContentType.LeaveGroup {
                (cell as! SettingsCollectionViewCell).itemLabel.textColor = UIColor.redColor().colorWithAlphaComponent(0.8)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func populateData() {
        
        var cardsAdded = false
        for (title, cardContent, nextRequest) in [
            (AppStrings.GroupManagersSectionTitle, managerMemberProfiles, nextManagerMembersRequest),
            (AppStrings.GroupMembersSectionTitle, memberProfiles, nextMembersRequest)
        ] {
            if cardContent.count > 0 {
                let groupMembersCard = Card(
                    cardType: .Profiles,
                    title: title,
                    addDefaultFooter: false,
                    contentCount: cardContent.count,
                    showContentCount: true
                )
                
                groupMembersCard.addHeader(
                    headerClass: ProfileSectionHeaderCollectionReusableView.self
                )
                
                groupMembersCard.sectionInset = sectionInset
                groupMembersCard.addContent(content: cardContent, maxVisibleItems: 5)
                appendCard(groupMembersCard)
                cardsAdded = true
            }
        }
        
        if cardsAdded && selectedGroup.isMember {
            let groupEmailCard = Card(cardType: .Settings, title: "")
            groupEmailCard.sectionInset = sectionInset
            groupEmailCard.addContent(content: [["text" : AppStrings.GroupLeaveGroupButtonTitle, "type": ContentType.LeaveGroup.rawValue]])
            appendCard(groupEmailCard)
        }
    }
}
