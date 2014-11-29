//
//  SelectContactViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class SelectContactViewController: UITableViewController, UISearchBarDelegate {
    
    var contacts: [Person]?
    var visibleContacts: [Person]?

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureSearchBar()
        
        self.loadContacts()
    }
    
    private func loadContacts() {
        let parseQuery = Person.query() as PFQuery
        parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.contacts = objects as? [Person]
                self.visibleContacts = self.contacts
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Configuration
    
    private func configureTableView() {
        self.tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.classReuseIdentifier)
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
    
    private func configureSearchBar() {
        self.searchBar.delegate = self
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visibleContacts?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.classReuseIdentifier) as ContactTableViewCell
        
        if let contact = self.visibleContacts?[indexPath.row] {
            cell.person = contact
        }
        
        return cell
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText.lowercaseString
        if query == "" {
            self.visibleContacts = self.contacts?
        } else {
            if let contacts = self.contacts {
                self.visibleContacts = contacts.filter { person in
                    return person.firstName.lowercaseString.hasPrefix(query) || person.lastName.lowercaseString.hasPrefix(query)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func handleCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
