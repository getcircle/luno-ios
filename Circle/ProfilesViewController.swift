//
//  ProfilesViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit
import ProtobufRegistry

class ProfilesViewController: UIViewController,
                            MFMailComposeViewControllerDelegate,
                            UICollectionViewDelegate,
                            UISearchBarDelegate,
                            UISearchResultsUpdating {

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchControllerContainerView: UIView!

    let rowHeight: CGFloat = 64.0
    
    var dataSource = ProfilesDataSource()
//    private var filteredPeople: [Person]?
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
//        filteredPeople = []
        configureSearchController()
        configureCollectionView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Configuration

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchControllerContainerView.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        collectionView.dataSource = dataSource
        (collectionView.delegate as ProfilesCollectionViewDelegate).delegate = self
    }

    // MARK: - Collection View Delegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
            
            let profileVC = ProfileDetailsViewController.forProfile(profile)
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }

    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
//        let trimmedString = searchString.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
//        if trimmedString == "" {
//            filteredPeople = people
//        }
//        else {
//            
//            var andPredicates = [NSPredicate]()
//            var searchTerms = trimmedString.componentsSeparatedByString(" ")
//            
//            for searchTerm in searchTerms {
//                var searchTermPredicates = [NSPredicate]()
//                let trimmedSearchTerm = searchTerm.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
//
//                // Match first name
//                var firstNamePredicate = NSComparisonPredicate(
//                    leftExpression: NSExpression(forKeyPath: "firstName"),
//                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
//                    modifier: .DirectPredicateModifier,
//                    type: .ContainsPredicateOperatorType,
//                    options: .CaseInsensitivePredicateOption
//                )
//                
//                // Match last name
//                var lastNamePredicate = NSComparisonPredicate(
//                    leftExpression: NSExpression(forKeyPath: "lastName"),
//                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
//                    modifier: .DirectPredicateModifier,
//                    type: .ContainsPredicateOperatorType,
//                    options: .CaseInsensitivePredicateOption
//                )
//
//                // Match title
//                var titlePredicate = NSComparisonPredicate(
//                    leftExpression: NSExpression(forKeyPath: "title"),
//                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
//                    modifier: .DirectPredicateModifier,
//                    type: .ContainsPredicateOperatorType,
//                    options: .CaseInsensitivePredicateOption
//                )
//                
//                andPredicates.append(
//                    NSCompoundPredicate.orPredicateWithSubpredicates([
//                        firstNamePredicate,
//                        lastNamePredicate,
//                        titlePredicate
//                    ])
//                )
//            }
//    
//            let allPeople = people
//            let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
//            filteredPeople = allPeople?.filter{ finalPredicate.evaluateWithObject($0) }
//        }
//
//        collectionView.reloadData()
    }
    
    // MARK: UISearchBarDelegate
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        updateSearchResultsForSearchController(searchController)
//        searchBar.resignFirstResponder()
//    }
    
    // MARK: Helpers
    
//    // Function to fetch the correct person for a row regardless of whether
//    // the data source is for a search results view or regular table view
//    private func getPersonAtIndexPath(indexPath: NSIndexPath!) -> Person? {
//        var person: Person?
//        if searchController.active {
//            person = filteredPeople?[indexPath.row]
//        }
//        else {
//            person = people?[indexPath.row]
//        }
//        
//        return person
//    }
    
    // MARK: - Orientation change

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize = CGSizeMake(size.width, rowHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
