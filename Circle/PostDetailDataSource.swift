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
    
    struct PostAttachment {
        var name: String
        var data: NSData
    }
    
    private var attachments = [NSTextAttachment: PostAttachment]()
    
    var post: Services.Post.Containers.PostV1!
    var content: NSAttributedString?
    var textViewDelegate: UITextViewDelegate?
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        let actionsGroup = dispatch_group_create()
        
        var storedError: NSError?
        var filesData = [String: NSData]()
        
        dispatch_group_enter(actionsGroup)
        Services.Post.Actions.getPost(post.id) { (post, error) -> Void in
            if let error = error {
                storedError = error
            }
            else if let post = post {
                // Download all attached images
                for file in post.files {
                    if file.isImage() {
                        dispatch_group_enter(actionsGroup)
                        Alamofire.request(.GET, file.sourceUrl).response(completionHandler: { (request, response, data, error) -> Void in
                            if let error = error {
                                print("Error: \(error)")
                            }
                            else if let data = data {
                                filesData[file.sourceUrl] = data
                            }
                            dispatch_group_leave(actionsGroup)
                        })
                    }
                }
                
                self.post = post
            }
            dispatch_group_leave(actionsGroup)
        }
        
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            self.renderContentWithFiles(self.post.files, filesData: filesData)
            self.populateData()
            completionHandler(error: storedError)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let authorCell = cell as? ProfileCollectionViewCell {
            authorCell.disclosureIndicatorView.hidden = false
        }
        else if let contentCell = cell as? PostContentCollectionViewCell {
            contentCell.textView.delegate = textViewDelegate
        }
    }
    
    func attachmentForTextAttachment(textAttachment: NSTextAttachment) -> PostAttachment? {
        return attachments[textAttachment]
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
        card.addContent(content: [post.byProfile])
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
    
    private func renderContentWithFiles(files: [Services.File.Containers.FileV1]?, filesData: [String: NSData]?) {
        let availableWidth = UIScreen.mainScreen().bounds.size.width - 20.0
        
        // Post content style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        let contentAttributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: UIColor.appPrimaryTextColor(),
            NSFontAttributeName: UIFont.regularFont(18.0),
        ]
        
        // Image caption style
        let imageCaptionParagraphStyle = NSMutableParagraphStyle()
        imageCaptionParagraphStyle.paragraphSpacingBefore = 5.0
        imageCaptionParagraphStyle.alignment = .Center
        let imageCaptionAttributes = [
            NSForegroundColorAttributeName: UIColor.appSecondaryTextColor(),
            NSFontAttributeName: UIFont.secondaryTextFont(),
            NSParagraphStyleAttributeName: imageCaptionParagraphStyle,
        ]
        
        var attachmentStrings = [NSAttributedString]()
        if let files = files {
            for (index, file) in files.enumerate() {
                if let data = filesData?[file.sourceUrl], image = UIImage(data: data), cgImage = image.CGImage {
                    let attachment = NSTextAttachment()
                    let imageWidth = image.size.width
                    let scale = (imageWidth > availableWidth) ? (imageWidth / availableWidth) : 1.0
                    
                    attachment.image = UIImage(CGImage: cgImage, scale: scale, orientation: .Up)
                    
                    let attachmentString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
                    let captionString = NSAttributedString(string: "\n\(file.name)", attributes: imageCaptionAttributes)
                    attachmentString.appendAttributedString(captionString)
                    
                    attachmentStrings.insert(attachmentString, atIndex: index)
                    attachments[attachment] = PostAttachment(name: file.name, data: data)
                }
                else {
                    // Make a link to the file
                    if let url = NSURL(string: file.sourceUrl) {
                        let attachmentString = NSMutableAttributedString(string: file.name, attributes: contentAttributes)
                        attachmentString.addAttribute(NSLinkAttributeName, value: url, range: NSMakeRange(0, attachmentString.length))
                        attachmentStrings.insert(attachmentString, atIndex: index)
                    }
                }
            }
        }
        
        let contentString = NSMutableAttributedString(string: self.post.content, attributes: contentAttributes)
        
        for attachmentString in attachmentStrings {
            contentString.appendAttributedString(NSAttributedString(string: "\n\n"))
            contentString.appendAttributedString(attachmentString)
        }
        
        self.content = contentString
    }
    
}
