//
//  PostDetailDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-08.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry
import Alamofire

class PostDetailDataSource: CardDataSource {
    
    var post: Services.Post.Containers.PostV1!
    var author: Services.Profile.Containers.ProfileV1?
    var content: NSAttributedString?
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        let actionsGroup = dispatch_group_create()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        let contentAttributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: UIColor.appPrimaryTextColor(),
            NSFontAttributeName: UIFont.mainTextFont(),
        ]
        
        var storedError: NSError?
        var attachmentStrings = [NSAttributedString]()
        
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
                else if let files = files {
                    let sortedFiles = files.sort({ (firstFile, secondFile) -> Bool in
                        if let firstFileDate = NSDateFormatter.dateFromTimestampString(firstFile.created), secondFileDate = NSDateFormatter.dateFromTimestampString(secondFile.created) {
                            return firstFileDate.earlierDate(secondFileDate) == firstFileDate
                        }
                        else {
                            return false
                        }
                    })
                    for file in sortedFiles {
                        if file.contentType.containsString("image/") {
                            dispatch_group_enter(actionsGroup)
                            Alamofire.request(.GET, file.sourceUrl).response(completionHandler: { (request, response, data, error) -> Void in
                                if let error = error {
                                    print("Error: \(error)")
                                    dispatch_group_leave(actionsGroup)
                                }
                                else if let data = data, image = UIImage(data: data) {
                                    let attachment = NSTextAttachment()
                                    let imageWidth = image.size.width
                                    let screenWidth = UIScreen.mainScreen().bounds.size.width - 20.0
                                    attachment.image = UIImage(CGImage: image.CGImage!, scale: (imageWidth / screenWidth), orientation: .Up)
                                    let attachmentString = NSAttributedString(attachment: attachment)
                                    attachmentStrings.insert(attachmentString, atIndex: sortedFiles.indexOf(file)!)
                                    dispatch_group_leave(actionsGroup)
                                }
                            })
                        }
                        else {
                            let attachmentString = NSMutableAttributedString(string: file.name, attributes: contentAttributes)
                            attachmentString.addAttribute(NSLinkAttributeName, value: NSURL(string: file.sourceUrl)!, range: NSMakeRange(0, attachmentString.length))
                            attachmentStrings.insert(attachmentString, atIndex: sortedFiles.indexOf(file)!)
                        }
                    }
                }
                dispatch_group_leave(actionsGroup)
            }
        }
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            let contentString = NSMutableAttributedString(string: self.post.content, attributes: contentAttributes)

            for attachmentString in attachmentStrings {
                contentString.appendAttributedString(NSAttributedString(string: "\n\n"))
                contentString.appendAttributedString(attachmentString)
            }
            
            self.content = contentString
            
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
        if let content = content {
            card.addContent(content: [content])
        }
        appendCard(card)
        return card
    }
    
}
