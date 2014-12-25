//
//  PeopleViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit

class PeopleViewController: UIViewController,
                            MGSwipeTableCellDelegate,
                            MFMailComposeViewControllerDelegate,
                            UISearchBarDelegate,
                            UISearchResultsUpdating {

    @IBOutlet weak private(set) var menuContainer: UIView!
    @IBOutlet weak private(set) var tableView: UITableView!

    var dataLoadAttempted: Bool!
    var filteredPeople: [Person]?
    var loggedInPerson: Person?
    var people: [Person]?
    var searchController: UISearchController!

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        filteredPeople = []
        dataLoadAttempted = false
        configureSearchDisplayController()
        configTableView()
        loadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if dataLoadAttempted == false {
            // Checks if it has a user and loads data
            loadData()
        }

    }

    // MARK: - Configuration

    private func configureSearchDisplayController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    private func configTableView() {
        // configure table view
        tableView.registerNib(
            UINib(nibName: "ContactTableViewCell", bundle: nil),
            forCellReuseIdentifier: ContactTableViewCell.classReuseIdentifier
        )
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        tableView.rowHeight = 64.0
        tableView.addDummyFooterView()
    }

    private func loadData() {
        if let pfUser = PFUser.currentUser() {
            dataLoadAttempted = true

            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.orderByAscending("firstName")
            parseQuery.findObjectsInBackgroundWithBlock({ (objects, error: NSError!) -> Void in
                if error == nil {
                    self.setPeople(objects)
                }
            })
        }
    }
    
    private func setPeople(objects: [AnyObject]!) {
        people = objects as? [Person]
        let filteredList = people?.filter({ $0.email == PFUser.currentUser().email })
        if filteredList?.count == 1 {
            loggedInPerson = filteredList?[0]
        }
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfile" {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let person = people?[indexPath.row]
                let controller = segue.destinationViewController as ProfileViewController
                controller.person = person
            }
        }
        else if segue.identifier == "showUserProfile" {
            if let loggedInPersonObj = loggedInPerson {
                let controller = segue.destinationViewController as UINavigationController
                let profileVC = controller.topViewController as ProfileViewController
                profileVC.showCloseButton = true
                profileVC.person = loggedInPersonObj
            }
        }
    }

    // MARK: - Table View Delegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredPeople?.count ?? 0
        }
        
        return people?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            ContactTableViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as ContactTableViewCell
        cell.addQuickActions = true

        var person: Person?
        if searchController.active {
            person = filteredPeople?[indexPath.row]
        }
        else {
            person = people?[indexPath.row]
        }
        
        if person != nil {
            cell.person = person
            cell.delegate = self
        }

        return cell
    }

    // MARK: - Swipe Cell Delegate

    func swipeTableCell(
        cell: ContactTableViewCell!,
        tappedButtonAtIndex index: Int,
        direction: MGSwipeDirection,
        fromExpansion: Bool) -> Bool {
        switch direction {
            case .RightToLeft:
                // Right buttons tapped
                println("Email = \(cell.person.email)")
                presentMailViewController([cell.person.email], subject: "Hey", messageBody: "")
            default:
                break
        }

        return true
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let person = people?[indexPath.row] {
            performSegueWithIdentifier("showProfile", sender: tableView)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let trimmedString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedString == "" {
            filteredPeople = people
        }
        else {
            filteredPeople = people?.filter({
                let name: String = ($0 as Person).firstName + ($0 as Person).lastName
                let range = name.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch|NSStringCompareOptions.LiteralSearch)
                return !(range != nil ? range!.isEmpty : true)
            })
        }
        
        tableView.reloadData()
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}