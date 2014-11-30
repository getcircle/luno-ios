//
//  MessagesViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MessagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NoMessagesCellDelegate, SelectContactDelegate {
    
    var messages: [ConversationHistory]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
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
    
    private func loadData() {
        let parseQuery = ConversationHistory.query() as PFQuery
        parseQuery.includeKey("sender")
        parseQuery.includeKey("recipient")
        parseQuery.includeKey("message")
        parseQuery.orderByDescending("createdAt")
        parseQuery.whereKey("sender", equalTo: AuthViewController.getLoggedInPerson())
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.messages = objects as? [ConversationHistory]
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
            
            if let history: ConversationHistory = self.messages?[indexPath.row] {
                cell.history = history
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
        self.displaySelectContact()
    }
    
    func handleCompose(sender: AnyObject) {
        self.displaySelectContact()
    }
    
    // MARK: - SelectContactDelegate
    
    func didSelectContact(person: Person) {
        let vc = ConversationViewController.instance()
        vc.recipient = person
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: - Helpers
    
    private func displaySelectContact() {
        let vc = SelectContactViewController(nibName: "SelectContactViewController", bundle: nil)
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
}
