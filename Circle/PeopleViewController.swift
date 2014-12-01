//
//  PeopleViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController, MGSwipeTableCellDelegate {

    var profileViewController: ProfileViewController?
    var people: [Person]?
    var dataLoadAttempted: Bool!

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        dataLoadAttempted = false
        configTableView()
        loadInitialData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if dataLoadAttempted == false {
            // Checks if it has a user and loads data
            loadInitialData()
        }
    }
    
    // MARK: - Configuration
    
    private func configTableView() {
        // configure table view
        tableView.registerNib(
            UINib(nibName: "ContactTableViewCell", bundle: nil),
            forCellReuseIdentifier: ContactTableViewCell.classReuseIdentifier)
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        tableView.rowHeight = 64.0
        tableView.addDummyFooterView()
    }

    private func loadInitialData() {
        if let pfUser = PFUser.currentUser() {
            dataLoadAttempted = true
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.orderByAscending("firstName")
            parseQuery.whereKey("email", notEqualTo: PFUser.currentUser().email)
            parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    self.people = objects as? [Person]
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfile" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let person = self.people?[indexPath.row]
                let controller = segue.destinationViewController as ProfileViewController
                controller.person = person
            }
        }
    }

    // MARK: - Table View Delegate

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.classReuseIdentifier, forIndexPath: indexPath) as ContactTableViewCell

        if let person = self.people?[indexPath.row] {
            cell.person = person
            cell.delegate = self
        }

        return cell
    }

    // MARK: - Swipe Cell Delegate

    func swipeTableCell(cell: ContactTableViewCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        switch direction {
            case .LeftToRight:
                // Left button tapped
                println("Will mark favorite")
            case .RightToLeft:
                // Right buttons tapped
                println("Email = \(cell.person.email)")
            default:
                break
        }

        return true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let person = self.people?[indexPath.row] {
            performSegueWithIdentifier("showProfile", sender: tableView)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

