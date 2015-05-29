//
//  GroupsDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class GroupsDataSource: CardDataSource {

    var profile: Services.Profile.Containers.ProfileV1?
    
    var groupJoinRequestDelegate: GroupJoinRequestDelegate?
    var groups = Array<Services.Group.Containers.GroupV1>()
    
    private var card: Card!
    private var cardType: Card.CardType = .Group
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
//        registerNextRequestHandler()
//        let paginatorBuilder = Soa.PaginatorV1.builder()
//        paginatorBuilder.pageSize = 2

        Services.Group.Actions.getGroups(profile?.id ?? nil, paginatorBuilder: nil) { (groups, nextRequest, error) -> Void in
            if error == nil {
                self.resetCards()
                
                self.card = Card(cardType: self.cardType, title: "")
                self.card.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0)
                if let groups = groups {
                    self.groups.extend(groups)
                    self.card.addContent(content: groups)
                }
                self.appendCard(self.card)
                
//                if let nextRequest = nextRequest {
//                    self.registerNextRequest(nextRequest: nextRequest)
//                }
            }
            
            completionHandler(error: error)
        }
    }
    
    private func registerNextRequestHandler() {
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Group.getGroups()
            ) as? Services.Group.Actions.GetGroups.ResponseV1
            
            if let groups = response?.groups {
                self.groups.extend(groups)
                self.card.addContent(content: groups)
                self.handleNewContentAddedToCard(self.card, newContent: groups)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let group = contentAtIndexPath(indexPath) as? Services.Group.Containers.GroupV1, cell = cell as? GroupCollectionViewCell {
            cell.groupJoinRequestDelegate = groupJoinRequestDelegate
        }
    }

    func replaceLocalGroup(group: Services.Group.Containers.GroupV1, atIndex index: Int) {
        var groups = self.card.content as! Array<Services.Group.Containers.GroupV1>
        groups[index] = group
        self.card.resetContent()
        self.card.addContent(content: groups)
    }
}