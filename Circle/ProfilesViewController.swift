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
    SearchHeaderViewDelegate,
    CardDataSourceDelegate
{

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchContainerView: UIView!
    @IBOutlet weak var collectionViewVerticalSpaceConstraint: NSLayoutConstraint!
    
    private var searchHeaderView: SearchHeaderView?

    let rowHeight: CGFloat = 70.0
    
    var dataSource = ProfilesDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureSearchHeaderView()
        dataSource.delegate = self
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.hideFilterIfLimitedContent()
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.dataSource = dataSource
        (collectionView.delegate as ProfilesCollectionViewDelegate).delegate = self
    }
    
    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            if let headerView = nibViews.first as? SearchHeaderView {
                searchHeaderView = headerView
                headerView.delegate = self
                headerView.searchTextField.placeholder = NSLocalizedString(
                    "Filter people",
                    comment: "Placeholder for text field used for filtering people"
                )
                headerView.searchTextField.addTarget(self, action: "filterPeople:", forControlEvents: .EditingChanged)
                searchContainerView.addSubview(headerView)
                headerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
                headerView.layer.cornerRadius = 10.0
            }
        }
    }

    // MARK: - Collection View Delegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
            trackViewProfile(profile)
            let profileVC = ProfileDetailViewController.forProfile(profile)
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    // MARK: Helpers
    
    private func hideFilterIfLimitedContent() {
        if dataSource.cardAtSection(0)?.content.count < 5 {
            collectionViewVerticalSpaceConstraint.constant = -44
            collectionView.setNeedsUpdateConstraints()
            searchHeaderView?.removeFromSuperview()
        }
    }
    
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
    
    // MARK: - Tracking
    
    private func trackViewProfile(profile: ProfileService.Containers.Profile) {
        var properties = [
            TrackerProperty.withDestinationId("profile_id").withString(profile.id),
            TrackerProperty.withKey(.Source).withSource(.Overview),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        if let title = self.title {
            properties.append(TrackerProperty.withKey(.SourceOverviewType).withString(title))
        }
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
    
    // MARK: - CardDataSourceDelegate
    
    func onDataLoaded(indexPaths: [NSIndexPath]) {
        collectionView.insertItemsAtIndexPaths(indexPaths)
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        dataSource.clearFilter {
            self.collectionView.reloadData()
        }
    }
    
    func filterPeople(sender: AnyObject?) {
        if searchHeaderView != nil {
            let query = searchHeaderView!.searchTextField.text
            if query.trimWhitespace() == "" {
                dataSource.clearFilter { () -> Void in
                    self.collectionView.reloadData()
                }
            } else {
                dataSource.filter(searchHeaderView!.searchTextField.text) { (error) -> Void in
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchHeaderView?.searchTextField.resignFirstResponder()
    }

}
