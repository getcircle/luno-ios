//
//  PeopleViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, MGSwipeTableCellDelegate {

    @IBOutlet weak private(set) var menuContainer: UIView!
    @IBOutlet weak private(set) var tableView: UITableView!

    var dataLoadAttempted: Bool!
    var people: [Person]?
    var profileViewController: ProfileViewController?

    private var topMenuSegmentedControl: DZNSegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        dataLoadAttempted = false
        configTableView()
        configureTopMenu()
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

    private func configTableView() {
        // configure table view
        tableView.registerNib(
            UINib(nibName: "ContactTableViewCell", bundle: nil),
            forCellReuseIdentifier: ContactTableViewCell.classReuseIdentifier)
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 64.0, 0.0, 0.0)
        tableView.rowHeight = 64.0
        tableView.addDummyFooterView()
    }

    private func configureTopMenu() {
        let items = ["Direct Reports", "Peers", "Favorites"]
        topMenuSegmentedControl = DZNSegmentedControl(items: items)
        topMenuSegmentedControl.showsCount = false
        topMenuSegmentedControl.tintColor = UIColor.appTintColor()
        topMenuSegmentedControl.height = menuContainer.frameHeight
        topMenuSegmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: .ValueChanged)
        topMenuSegmentedControl.selectedSegmentIndex = 0
        topMenuSegmentedControl.font = UIFont.segmentedControlTitleFont()
        menuContainer.addSubview(topMenuSegmentedControl)
        topMenuSegmentedControl.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    private func loadData() {
        if let pfUser = PFUser.currentUser() {
            dataLoadAttempted = true
            let loggedInPerson = AuthViewController.getLoggedInPerson()!
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.orderByAscending("firstName")
            parseQuery.whereKey("email", notEqualTo: PFUser.currentUser().email)

            switch topMenuSegmentedControl.selectedSegmentIndex {
            case 0:
                // Direct Reports
                parseQuery.whereKey("manager", equalTo: loggedInPerson)

            case 1:
                // Peers
                if let manager = loggedInPerson.manager {
                    parseQuery.whereKey("manager", equalTo: manager)
                }

            default:
                break;
            }

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
            if let indexPath = tableView.indexPathForSelectedRow() {
                let person = people?[indexPath.row]
                let controller = segue.destinationViewController as ProfileViewController
                controller.person = person
            }
        }
    }

    // MARK: - Table View Delegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.classReuseIdentifier, forIndexPath: indexPath) as ContactTableViewCell
        cell.addQuickActions = true

        if let person = people?[indexPath.row] {
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let person = people?[indexPath.row] {
            performSegueWithIdentifier("showProfile", sender: tableView)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Segment Selection

    @IBAction func segmentedControlValueChanged(sender: AnyObject!) {
        loadData()
    }
}

