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
    private(set) var ownerProfiles = Array<Services.Profile.Containers.ProfileV1>()
    private(set) var nextManagerMembersRequest: Soa.ServiceRequestV1?
    private(set) var nextMembersRequest: Soa.ServiceRequestV1?
    private(set) var nextOwnersRequest: Soa.ServiceRequestV1?
    private(set) var groupHeaderView: GroupHeaderCollectionReusableView!
    private let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        
        memberProfiles.removeAll(keepCapacity: true)
        managerMemberProfiles.removeAll(keepCapacity: true)
        ownerProfiles.removeAll(keepCapacity: true)
        
        // Add a placeholder card for header view
        let placeholderHeaderCard = Card(cardType: .Placeholder, title: "Team Header")
        placeholderHeaderCard.sectionInset = UIEdgeInsetsZero
        placeholderHeaderCard.addHeader(
            headerClass: GroupHeaderCollectionReusableView.self
        )
        appendCard(placeholderHeaderCard)
        
        fetchAllMembers(completionHandler)
    }
    
    func updateGroup(completionHandler: ((error: NSError?) -> Void)?) {
        Services.Group.Actions.getGroup(selectedGroup.id, completionHandler: { (group, error) -> Void in
            if let error = error {
                // Handle case where view controller needs to pop out
                // TODO: look for DOES NOT EXIST error
                completionHandler?(error: error)
            }
            else {
                self.selectedGroup = group
                completionHandler?(error: nil)
            }
        })
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
            else {
                (cell as! SettingsCollectionViewCell).itemLabel.textColor = UIColor.appTintColor()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func addGroupMetaDataCards() {
        let groupEmailCard = Card(cardType: .KeyValue, title: "")
        groupEmailCard.sectionInset = sectionInset
        groupEmailCard.addContent(content: [["name" : AppStrings.QuickActionEmailLabel, "value": selectedGroup.email]])
        appendCard(groupEmailCard)
        
        if selectedGroup.groupDescription.trimWhitespace() != "" {
            // Add a text value card for description
            let groupDescriptionCard = Card(cardType: .TextValue, title: AppStrings.GroupDescriptionSectionTitle)
            groupDescriptionCard.sectionInset = sectionInset
            groupDescriptionCard.showContentCount = false
            groupDescriptionCard.addContent(content: [selectedGroup.groupDescription])
            groupDescriptionCard.addHeader(
                headerClass: ProfileSectionHeaderCollectionReusableView.self
            )
            appendCard(groupDescriptionCard)
        }
    }
    
    private func fetchAllMembers(completionHandler: (error: NSError?) -> Void) {
        // Fetch data within a dispatch group, calling populateData when all tasks have finished
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()

        // Fetch owners
        dispatch_group_enter(actionsGroup)
        Services.Group.Actions.getMembers(selectedGroup.id, role: .Owner) {
            (members, nextRequest, error) -> Void in
            if let members = members {
                self.ownerProfiles.extend(members.map({ $0.profile }))
                self.nextOwnersRequest = nextRequest
            }
            if let error = error {
                storedError = error
            }
            dispatch_group_leave(actionsGroup)
        }
        
        // Fetch group managers
        dispatch_group_enter(actionsGroup)
        Services.Group.Actions.getMembers(selectedGroup.id, role: .Manager) {
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
        
        // Fetch Members
        dispatch_group_enter(actionsGroup)
        Services.Group.Actions.getMembers(selectedGroup.id, role: .Member) {
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

    private func populateData() {
        
        addGroupMetaDataCards()

        // Add Manager/Member cards
        var cardsAdded = false
        for (title, cardContent, nextRequest) in [
            (AppStrings.GroupOwnersSectionTitle, ownerProfiles, nextOwnersRequest),
            (AppStrings.GroupManagersSectionTitle, managerMemberProfiles, nextManagerMembersRequest),
            (AppStrings.GroupMembersSectionTitle, memberProfiles, nextMembersRequest)
        ] {
            if cardContent.count > 0 {
                let groupMembersCard = Card(
                    cardType: .Profiles,
                    title: title,
                    contentCount: nextRequest?.getPaginator().countAsInt() ?? cardContent.count,
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
        
        // Add group actions card
        if cardsAdded {
            let groupActionCard = Card(cardType: .Settings, title: "")
            groupActionCard.sectionInset = UIEdgeInsetsMake(25.0, 0.0, 40.0, 0.0)
            
            var contentType: ContentType?
            var cellTitle: String?
            if selectedGroup.isMember {
                cellTitle = AppStrings.GroupLeaveGroupButtonTitle
                contentType = .LeaveGroup
            }
            else if !selectedGroup.hasPendingRequest {
                if selectedGroup.canJoin {
                    cellTitle = AppStrings.GroupJoinGroupButtonTitle
                    contentType = .JoinGroup
                }
                else if selectedGroup.canRequest {
                    cellTitle = AppStrings.GroupRequestToJoinGroupButtonTitle
                    contentType = .RequestGroup
                }
            }
            
            if let cellTitle = cellTitle, contentType = contentType {
                groupActionCard.addContent(content: [["text" : cellTitle, "type": contentType.rawValue]])
                appendCard(groupActionCard)
            }
        }
    }
}
