//
//  PostDetailDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-08.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostDetailDataSource: CardDataSource {
    
    var post: Services.Post.Containers.PostV1!
    var author: Services.Profile.Containers.ProfileV1?
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        var storedError: NSError?
        let actionsGroup = dispatch_group_create()
        
        dispatch_group_enter(actionsGroup)
        Services.Profile.Actions.getProfile(post.byProfileId) { (profile, error) -> Void in
            if let error = error {
                storedError = error
            }
            else {
                self.author = profile
            }
            dispatch_group_leave(actionsGroup)
            completionHandler(error: error)
        }
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.populateData()
            completionHandler(error: storedError)
        }
    }
    
    // MARK: - Populate Data
    
    internal func populateData() {
        resetCards()
        addTitleCard()
        addAuthorCard()
        addContentCard()
    }
    
    internal func addTitleCard() -> Card? {
        let card = Card(cardType: .TextValue, title: "")
        card.showContentCount = false
        card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, -10.0, 0.0)
        card.addContent(content:
            [
                TextData(
                    type: .PostContent,
                    andValue: post.title,
                    andTimestamp: post.changed,
                    andCanEdit: canEdit()
                )
            ]
        )
        appendCard(card)
        return card
    }
    
    internal func addAuthorCard() -> Card? {
        let card = Card(cardType: .Profiles, title: "")
        card.showContentCount = false
        card.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        if let author = author {
            card.addContent(content: [author])
        }
        appendCard(card)
        return card
    }
    
    internal func addContentCard() -> Card? {
        let card = Card(cardType: .TextValue, title: "")
        card.showContentCount = false
        card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        card.addContent(content:
            [
                TextData(
                    type: .PostContent,
                    andValue: post.content,
                    andCanEdit: canEdit()
                )
            ]
        )
        appendCard(card)
        return card
    }
    
}
