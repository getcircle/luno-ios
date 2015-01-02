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
                            MFMailComposeViewControllerDelegate,
                            UISearchBarDelegate,
                            UISearchResultsUpdating {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchControllerContainerView: UIView!

    private var dataLoadAttempted: Bool!
    private var filteredPeople: [Person]?
    private var loggedInPerson: Person?
    private var people: [Person]?
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        filteredPeople = []
        dataLoadAttempted = false
        configureSearchController()
        configureCollectionView()
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

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchControllerContainerView.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        collectionView.registerNib(
            UINib(nibName: "PersonCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: PersonCollectionViewCell.classReuseIdentifier
        )
        
        let collectionViewLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        collectionViewLayout.itemSize = CGSizeMake(view.frameWidth, 64.0)
        collectionViewLayout.sectionInset = UIEdgeInsetsZero
        collectionViewLayout.minimumInteritemSpacing = 0.0
        collectionViewLayout.minimumLineSpacing = 1.0
    }
    
    // MARK: - Load Data

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
        collectionView.reloadData()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfile" {
            if let indexPath = collectionView.indexPathsForSelectedItems()[0] as? NSIndexPath {
                let person = getPersonAtIndexPath(indexPath)
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

    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.active {
            return filteredPeople?.count ?? 0
        }
        
        return people?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            PersonCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as PersonCollectionViewCell

        cell.sizeMode = .Medium
        if let person = getPersonAtIndexPath(indexPath) {
            cell.setData(person)
            // TODO: Remove this hack
            cell.subTextLabel.text = person.title
        }
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var profileVC = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        profileVC.person = getPersonAtIndexPath(indexPath)

        // Convert point to superview coordinates
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as PersonCollectionViewCell
        profileVC.animationSourceRect = cell.convertRect(cell.profileImageView.frame, toView: view)
        navigationController?.pushViewController(profileVC, animated: true)
    }

    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let trimmedString = searchString.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        if trimmedString == "" {
            filteredPeople = people
        }
        else {
            
            var andPredicates = [NSPredicate]()
            var searchTerms = trimmedString.componentsSeparatedByString(" ")
            
            for searchTerm in searchTerms {
                var searchTermPredicates = [NSPredicate]()
                let trimmedSearchTerm = searchTerm.stringByTrimmingCharactersInSet(whitespaceCharacterSet)

                // Match first name
                var firstNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forKeyPath: "firstName"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .ContainsPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                // Match last name
                var lastNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forKeyPath: "lastName"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .ContainsPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )

                // Match title
                var titlePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forKeyPath: "title"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .ContainsPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                andPredicates.append(
                    NSCompoundPredicate.orPredicateWithSubpredicates([
                        firstNamePredicate,
                        lastNamePredicate,
                        titlePredicate
                    ])
                )
            }
    
            let allPeople = people
            let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
            filteredPeople = allPeople?.filter{ finalPredicate.evaluateWithObject($0) }
        }

        collectionView.reloadData()
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        updateSearchResultsForSearchController(searchController)
        searchBar.resignFirstResponder()
    }
    
    // MARK: Helpers
    
    // Function to fetch the correct person for a row regardless of whether
    // the data source is for a search results view or regular table view
    private func getPersonAtIndexPath(indexPath: NSIndexPath!) -> Person? {
        var person: Person?
        if searchController.active {
            person = filteredPeople?[indexPath.row]
        }
        else {
            person = people?[indexPath.row]
        }
        
        return person
    }
}