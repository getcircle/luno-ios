//
//  HomeFeedDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class HomeFeedDataSource: CardDataSource {

    var groupRequestDelegate: GroupRequestDelegate?

    private var groupsAssociatedWithGroupRequests = Dictionary<String, Services.Group.Containers.GroupV1>()
    private var profilesAssociatedWithGroupRequests = Dictionary<String, Services.Profile.Containers.ProfileV1>()
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if (state == .Loading) {
            return;
        }
        
        state = .Loading
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            Services.Feed.Actions.getProfileFeed(currentProfile.id) { (categories, error) -> Void in
                if error == nil {
                    self.resetCards()
                    
                    // Add quick actions to the top
                    let quickActionsCard = Card(cardType: .QuickActions, title: "Quick Actions", addDefaultFooter: false)
                    quickActionsCard.addContent(content: [["placeholder": true]], maxVisibleItems: 0)
                    quickActionsCard.sectionInset = UIEdgeInsetsMake(15.0, 10.0, 25.0, 10.0)
                    self.appendCard(quickActionsCard)

                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        categoryCard.addDefaultHeader()
                        if category.groupMembershipRequests.count > 0 {
                            categoryCard.showContentCount = false
                            categoryCard.addContent(content: category.groupMembershipRequests)
                            for profile in category.profiles {
                                self.profilesAssociatedWithGroupRequests[profile.id] = profile
                            }
                            
                            for group in category.groups {
                                self.groupsAssociatedWithGroupRequests[group.id] = group
                            }
                        }
                        else if category.profiles.count > 0 {
                            var profiles = category.profiles
                            var maxVisibleItems = 0
                            switch category.categoryType {
                            case .Birthdays, .Anniversaries, .NewHires:
                                // HACK: limit the number of results in a card to 3 until we can get smarter about displaying them on the detail view
                                maxVisibleItems = 3
                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: maxVisibleItems)
                        }
                        else if category.addresses.count > 0 {
                            // don't display offices on the search landing page
                            continue
                        }
                        else if category.tags.count > 0 {
                            categoryCard.addContent(content: category.tags, maxVisibleItems: 10)
                        }
                        
                        self.appendCard(categoryCard)
                    }
                }
                completionHandler(error: error)
                self.state == .Loaded
            }
        } else {
            state = .Loaded
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
        if cell is GroupRequestCollectionViewCell {
            (cell as! GroupRequestCollectionViewCell).groupRequestDelegate = groupRequestDelegate
            (cell as! GroupRequestCollectionViewCell).setProfilesAndGroups(profiles: profilesAssociatedWithGroupRequests, groups: groupsAssociatedWithGroupRequests)
        }
    }
    
    func removeMembershipRequestAtIndexPath(indexPath: NSIndexPath) -> Bool {
        if let card = cardAtSection(indexPath.section) where card.type == .GroupRequest {
            var requests = card.content as! Array<Services.Group.Containers.MembershipRequestV1>
            if indexPath.row < requests.count {
                requests.removeAtIndex(indexPath.row)
                card.resetContent()
                card.addContent(content: requests)
                if requests.count == 0 {
                    removeCard(card)
                }
                return true
            }
        }
        
        return false
    }
}
