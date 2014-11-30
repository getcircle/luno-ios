//
//  MessagesViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MessagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NoMessagesCellDelegate {
    
    var messages: [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.configureCollectionView()
        self.loadInitialData()
    }
    
    // MARK: - Configuration
    
    private func configureCollectionView() {
        self.collectionView.registerNib(
            UINib(nibName: "MessageReceivedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: MessageReceivedCollectionViewCell.reuseIdentifier()
        )
        self.collectionView.registerNib(
            UINib(nibName: "NoMessagesCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: NoMessagesCollectionViewCell.reuseIdentifier()
        )
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "Messages"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .Done, target: self, action: "handleCompose:")
    }
    
    private func loadInitialData() {
        let parseQuery = Message.query() as PFQuery
        parseQuery.includeKey("sender")
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

    // MARK: - UICollectionViewDataSource

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
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if self.hasMessages() {
            return CGSizeMake(self.collectionView.frame.width, 64.0)
        } else {
            return self.view.bounds.size
        }
    }
    
    // MARK: - Actions
    
    func handleNewMessage(sender: AnyObject) {
        let vc = SelectContactViewController(nibName: "SelectContactViewController", bundle: nil)
        let nvc = UINavigationController(rootViewController: vc)
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func handleCompose(sender: AnyObject) {
        let vc = SelectContactViewController(nibName: "SelectContactViewController", bundle: nil)
        let nvc = UINavigationController(rootViewController: vc)
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
}
