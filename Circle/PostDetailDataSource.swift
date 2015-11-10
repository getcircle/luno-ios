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
    var files: [Services.File.Containers.FileV1]?
    
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
        }
        
        if post.fileIds.count > 0 {
            dispatch_group_enter(actionsGroup)
            Services.File.Actions.getFiles(post.fileIds) { (files, error) -> Void in
                if let error = error {
                    storedError = error
                }
                else {
                    self.files = files
                }
                dispatch_group_leave(actionsGroup)
            }
        }
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.populateData()
            completionHandler(error: storedError)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let authorCell = cell as? ProfileCollectionViewCell {
            authorCell.disclosureIndicatorView.hidden = false
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
        let card = Card(cardType: .PostTitle, title: "")
        card.showContentCount = false
        card.sectionInset = UIEdgeInsetsMake(15.0, 10.0, 10.0, 10.0)
        card.addContent(content: [post])
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
        let card = Card(cardType: .PostContent, title: "")
        card.showContentCount = false
        card.addContent(content: [post])
        appendCard(card)
        return card
    }
    
}
