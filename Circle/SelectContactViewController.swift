//
//  SelectContactViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

protocol SelectContactDelegate {
    func didSelectContact(person: Person)
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
//                self.contacts = contacts?.filter { person in
//                    return currentUser?.objectId != person.objectId
//                }
                self.visibleContacts = self.contacts
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Configuration
    
    private func configureNavigation() {
        navigationItem.title = "Select Contact"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "handleCancel:")
        navigationController?.navigationBar.translucent = false
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
        cell.addQuickActions = false

        if let contact = visibleContacts?[indexPath.row] {
            cell.person = contact
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let contact = visibleContacts?[indexPath.row] {
            delegate?.didSelectContact(contact)
        }
        dismiss()
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
