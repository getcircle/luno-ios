//
//  ChatRoomViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ChatRoomViewController: SLKTextViewController {
    
    var chatRoom: ChatRoom? {
        didSet {
            configureNavigation()
        }
    }
    var messages: [Message]?
    var reloadMessagesTimer: NSTimer?
    
    init(person: Person, composeFocus: Bool) {
        super.init(collectionViewLayout: ChatRoomCollectionViewLayout())
        configure()
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
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
        super.init(collectionViewLayout: ChatRoomCollectionViewLayout())
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
        configureCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        reloadMessagesTimer?.invalidate()
    }

    // MARK: - Configuration
    
    private func configure() {
        view.backgroundColor = UIColor.whiteColor()
        hidesBottomBarWhenPushed = true
        reloadMessagesTimer = NSTimer(timeInterval: 5.0, target: self, selector: "loadData", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(reloadMessagesTimer!, forMode: "NSDefaultRunLoopMode")
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
        layout.itemSize = CGSizeMake(view.frame.width, 64.0)
        collectionView.alwaysBounceVertical = true
    }
    
    func loadData() {
        if let room = chatRoom {
            let parseQuery = Message.query()
            parseQuery.whereKey("chatRoom", equalTo: room)
            parseQuery.includeKey("sender")
            parseQuery.includeKey("readReceipts")
            parseQuery.orderByDescending("createdAt")
            parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    self.messages = objects as? [Message]
                    self.collectionView.reloadData()
                    // need to put this behind a timer
                    self.markMessagesAsRead()
                }
            }
        }
    }
    
    private func markMessagesAsRead() {
        if let items = messages {
            var readMessages = [Message]()
            for message in items {
                let alreadyRead = message.markAsRead()
                if !alreadyRead {
                    readMessages.append(message)
                }
            }
            PFObject.saveAllInBackground(readMessages, block: nil)
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
        return messages?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let currentUser = AuthViewController.getLoggedInPerson()
        let message = messages![indexPath.row]
        
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
