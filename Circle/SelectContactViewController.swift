//
//  SelectContactViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

protocol SelectContactDelegate {
    func didSelectChatRoom(chatRoom: ChatRoom)
}

class SelectContactViewController: UITableViewController, UISearchBarDelegate {
    
    var delegate: SelectContactDelegate?
    var contacts: [Person]?
    var visibleContacts: [Person]?

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
        configureSearchBar()
        
        loadContacts()
    }
    
    private func loadContacts() {
        let parseQuery = Person.query() as PFQuery
        parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                let currentUser = AuthViewController.getLoggedInPerson()
                let contacts = objects as? [Person]
                self.contacts = contacts?.filter { person in
                    return currentUser?.objectId != person.objectId
                }
                self.visibleContacts = self.contacts
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Configuration
    
    private func configureNavigation() {
        self.navigationItem.title = "Select Contact"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "handleCancel:")
        self.navigationController?.navigationBar.translucent = false
    }
    
    private func configureTableView() {
        tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classReuseIdentifier)
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        tableView.rowHeight = 64.0
        tableView.addDummyFooterView()
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleContacts?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.classReuseIdentifier) as ContactTableViewCell
        
        if let contact = visibleContacts?[indexPath.row] {
            cell.person = contact
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let contact = visibleContacts?[indexPath.row] {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
            activityIndicator.autoCenterInSuperview()
            activityIndicator.startAnimating()
            let members = [contact, AuthViewController.getLoggedInPerson()!]
            ChatRoom.getRoomWithBlock(members) { (room: ChatRoom, error: NSError?) -> Void in
                self.delegate?.didSelectChatRoom(room)
                activityIndicator.stopAnimating()
                self.dismiss()
                return
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.lowercaseString
        if query == "" {
            visibleContacts = contacts?
        } else {
            if let people = contacts {
                visibleContacts = people.filter { person in
                    return person.firstName.lowercaseString.hasPrefix(query) || person.lastName.lowercaseString.hasPrefix(query)
                }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func handleCancel(sender: AnyObject) {
        dismiss()
    }
    
    // MARK: - Helpers
    
    func dismiss() {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
