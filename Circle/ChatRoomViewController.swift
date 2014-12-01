//
//  ChatRoomViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ChatRoomViewController: SLKTextViewController {
    
    var chatRoom: ChatRoom? {
        didSet {
            configureNavigation()
        }
    }
    var messages: [Message]?
    
    init(person: Person, composeFocus: Bool) {
        super.init(collectionViewLayout: SpringFlowLayout())
        configure()
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.autoCenterInSuperview()
        activityIndicator.startAnimating()
        let members = [person, AuthViewController.getLoggedInPerson()!]
        ChatRoom.getRoomWithBlock(members) { (room: ChatRoom, error: NSError?) -> Void in
            activityIndicator.stopAnimating()
            if error == nil {
                self.chatRoom = room
                self.loadData()
            }
            
            if composeFocus {
                self.textView.becomeFirstResponder()
            }
        }
    }
    
    init(room: ChatRoom, composeFocus: Bool) {
        super.init(collectionViewLayout: SpringFlowLayout())
        chatRoom = room
        configure()
        configureNavigation()
        
        if composeFocus {
            textView.becomeFirstResponder()
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }

    // MARK: - Configuration
    
    private func configure() {
        view.backgroundColor = UIColor.whiteColor()
        hidesBottomBarWhenPushed = true
    }
    
    private func configureNavigation() {
        navigationItem.title = chatRoom?.description
    }
    
    private func configureCollectionView() {
        collectionView.registerNib(
            UINib(nibName: "MessageReceivedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: MessageReceivedCollectionViewCell.classReuseIdentifier
        )
        collectionView.registerNib(
            UINib(nibName: "MessageSentCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: MessageSentCollectionViewCell.classReuseIdentifier
        )
        let layout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(self.view.frame.width, 64.0)
        collectionView.alwaysBounceVertical = true
    }
    
    private func loadData() {
        if let room = chatRoom {
            let parseQuery = Message.query()
            parseQuery.whereKey("chatRoom", equalTo: room)
            parseQuery.includeKey("sender")
            parseQuery.orderByDescending("createdAt")
            parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    self.messages = objects as? [Message]
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - SLKTextViewController Overrides
    
    override func didPressRightButton(sender: AnyObject!) {
        let message = MessageActions.sendMessage(chatRoom!, contents: textView.text)
        messages?.insert(message, atIndex: 0)
        super.didPressRightButton(sender)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let currentUser = AuthViewController.getLoggedInPerson()
        let message = self.messages![indexPath.row]
        
        var cell: UICollectionViewCell?
        if message.sender.objectId != currentUser?.objectId {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                MessageReceivedCollectionViewCell.classReuseIdentifier,
                forIndexPath: indexPath
            ) as? UICollectionViewCell
            let received = cell as MessageReceivedCollectionViewCell
            received.message = message
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                MessageSentCollectionViewCell.classReuseIdentifier,
                forIndexPath: indexPath
            ) as? UICollectionViewCell
            let sent = cell as MessageSentCollectionViewCell
            sent.message = message
        }
        return cell!
    }
    
}
