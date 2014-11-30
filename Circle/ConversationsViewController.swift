//
//  ConversationsViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NoConversationsViewDelegate, SelectContactDelegate {
    
    var conversations: [ConversationHistory]?
    var placeholder: NoConversationsView?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePlaceholder()
        self.configureNavigation()
        self.configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    // MARK: - Configuration
    
    private func configurePlaceholder() {
        self.placeholder = UINib(nibName: "NoConversationsView", bundle: nil).instantiateWithOwner(self, options: nil).first as? NoConversationsView
        if let placeholder = self.placeholder {
            self.view.addSubview(placeholder)
            placeholder.delegate = self
            placeholder.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(
            UINib(nibName: "ConversationHistoryTableViewCell", bundle: nil),
            forCellReuseIdentifier: ConversationHistoryTableViewCell.reuseIdentifier()
        )
        self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        self.tableView.rowHeight = 64.0
        self.addDummyFooterView()
    }
    
    private func addDummyFooterView() {
        // Add dummy footer view
        let footerView = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 10.0))
        footerView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = footerView
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
                self.conversations = objects as? [ConversationHistory]
                if let conversations = self.conversations {
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
        return self.conversations?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ConversationHistoryTableViewCell.reuseIdentifier()) as ConversationHistoryTableViewCell
        if let history: ConversationHistory = self.conversations?[indexPath.row] {
            cell.history = history
        }
        return cell
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
