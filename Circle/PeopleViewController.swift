//
//  PeopleViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit
import Parse

class PeopleViewController: UITableViewController, MGSwipeTableCellDelegate {

    var profileViewController: ProfileViewController?
    var people: [Person]?

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
        customizeTableView()
        loadInitialData()
    }

    private func customizeTableView() {
        // Customize table view
        tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ContactCell")
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        tableView.rowHeight = 64.0
        addDummyFooterView()
    }

    private func addDummyFooterView() {
        // Add dummy footer view
        let footerView = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 10.0))
        footerView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = footerView
    }

    private func loadInitialData() {
        let parseQuery = Person.query() as PFQuery
        parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.people = objects as? [Person]
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let person = self.people?[indexPath.row]
                let controller = (segue.destinationViewController as UINavigationController).topViewController as ProfileViewController
                controller.person = person
                controller.navigationItem.leftBarButtonItem = self.tabBarController?.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as ContactTableViewCell

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

            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                // Perform the segue only on the iPad
                performSegueWithIdentifier("showDetail", sender: tableView)
            }
            else {
                // For iPhone manually push the detail view
                // This is required because of our custom setup of tab
                // view controller as the master view controller

                let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
                profileVC.person = person
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

