//
//  PostDetailViewController.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-08.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostDetailViewController: DetailViewController, UITextViewDelegate, UIDocumentInteractionControllerDelegate {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        let postDetailDataSource = PostDetailDataSource()
        postDetailDataSource.textViewDelegate = self
        dataSource = postDetailDataSource
        delegate = CardCollectionViewDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: track page view
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        super.configureCollectionView()
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let dataSource = collectionView.dataSource as? PostDetailDataSource {
            if let card = dataSource.cardAtSection(indexPath.section) {
                switch card.type {
                case .Profiles:
                    let data: AnyObject? = dataSource.contentAtIndexPath(indexPath)
                    if let profile = data as? Services.Profile.Containers.ProfileV1 {
                        showProfileDetail(profile)
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        if let postDetailDataSource = dataSource as? PostDetailDataSource, attachment = postDetailDataSource.attachmentForTextAttachment(textAttachment) {
            // Write attachment data to a temp file so we can preview it
            let tempFileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).URLByAppendingPathComponent(attachment.name)
            do {
                try attachment.data.writeToURL(tempFileUrl, options: [])
                let documentInteractionController = UIDocumentInteractionController(URL: tempFileUrl)
                documentInteractionController.delegate = self
                documentInteractionController.presentPreviewAnimated(true)
            }
            catch {
                print("Error: \(error)")
            }
        }
        
        return true
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        if let tempFileUrl = controller.URL {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(tempFileUrl)
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
}
