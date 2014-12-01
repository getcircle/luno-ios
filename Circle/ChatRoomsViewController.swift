//
//  ChatRoomsViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ChatRoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NoConversationsViewDelegate, SelectContactDelegate {
    
    var chatRooms: [ChatRoom]?
    var placeholder: NoConversationsView?

    @IBOutlet weak private(set) var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlaceholder()
        configureNavigation()
        configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Configuration
    
    private func configurePlaceholder() {
        placeholder = UINib(nibName: "NoConversationsView", bundle: nil).instantiateWithOwner(self, options: nil).first as? NoConversationsView
        if let noConversationsView = placeholder {
            view.addSubview(noConversationsView)
            noConversationsView.delegate = self
            noConversationsView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(
            UINib(nibName: "ChatRoomHistoryTableViewCell", bundle: nil),
            forCellReuseIdentifier: ChatRoomHistoryTableViewCell.reuseIdentifier()
        )
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        tableView.rowHeight = 64.0
        tableView.addDummyFooterView()
    }

    private func configureNavigation() {
        navigationItem.title = "Messages"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .Plain, target: self, action: "handleCompose:")
    }
    
    private func loadData() {
        let parseQuery = ChatRoom.query() as PFQuery
        parseQuery.includeKey("members")
        parseQuery.includeKey("lastMessage")
        parseQuery.orderByDescending("updatedAt")
        parseQuery.whereKey("members", equalTo: AuthViewController.getLoggedInPerson())
        parseQuery.whereKeyExists("lastMessage")
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.chatRooms = objects as? [ChatRoom]
                if let conversations = self.chatRooms {
                    if conversations.count > 0 {
                        UIView.animateWithDuration(0.3, animations: { _ -> Void in
                            self.placeholder?.alpha = 0
                            return
                        }, completion: { _ -> Void in
                            self.placeholder?.removeFromSuperview()
                            self.placeholder = nil
                            return
                        })
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ChatRoomHistoryTableViewCell.reuseIdentifier()) as ChatRoomHistoryTableViewCell
        if let chatRoom: ChatRoom = chatRooms?[indexPath.row] {
            cell.chatRoom = chatRoom
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let chatRoom = self.chatRooms?[indexPath.row] {
            let vc = ChatRoomViewController(chatRoom: chatRoom)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Actions
    
    func handleNewMessage(sender: AnyObject) {
        displaySelectContact()
    }
    
    func handleCompose(sender: AnyObject) {
        displaySelectContact()
    }
    
    // MARK: - SelectContactDelegate
    
    func didSelectChatRoom(chatRoom: ChatRoom) {
        let vc = ChatRoomViewController(chatRoom: chatRoom)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: - Helpers
    
    private func displaySelectContact() {
        let vc = SelectContactViewController(nibName: "SelectContactViewController", bundle: nil)
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
    }
    
}
