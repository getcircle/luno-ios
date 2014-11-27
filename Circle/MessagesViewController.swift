//
//  MessagesViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var messages: [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customize()
        self.loadInitialData()
    }
    
    // MARK: - Private Methods
    
    private func customize() {
        self.collectionView.registerNib(
            UINib(nibName: "MessageReceivedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: MessageReceivedCollectionViewCell.reuseIdentifier()
        )
        self.collectionView.registerNib(
            UINib(nibName: "NoMessagesCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: NoMessagesCollectionViewCell.reuseIdentifier()
        )
    }
    
    private func loadInitialData() {
        let parseQuery = Message.query() as PFQuery
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.messages = objects as? [Message]
                self.collectionView.reloadData()
            }
        }
    }
    
    private func hasMessages() -> Bool {
        let messageCount = self.messages?.count ?? 0
        if messageCount > 0 {
            return true
        } else {
            return false
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.hasMessages() {
            return self.messages!.count
        } else {
            return 1
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if self.hasMessages() {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(
                MessageReceivedCollectionViewCell.reuseIdentifier(),
                forIndexPath: indexPath
            ) as MessageReceivedCollectionViewCell
            
            if let message: Message = self.messages?[indexPath.row] {
                cell.setMessage(message)
            }
            return cell
        } else {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(
                NoMessagesCollectionViewCell.reuseIdentifier(),
                forIndexPath: indexPath
            ) as NoMessagesCollectionViewCell
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
}
