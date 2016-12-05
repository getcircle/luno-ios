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

class ProfilesViewController: OverviewViewController {
    
    override func filterPlaceHolderComment() -> String {
        return "Placeholder for text field use for filtering people."
    }
    
    override func filterPlaceHolderText() -> String {
        return "Filter people"
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pageType = pageType else {
            print("Page Type needs to be set for ProfilesViewController")
            return
        }

        Tracker.sharedInstance.trackPageView(pageType: pageType)
    }
    
    override func initializeDataSource() -> CardDataSource {
        return ProfilesDataSource()
    }

    // MARK: - Collection View Delegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
            Tracker.sharedInstance.trackSearchResultTap(
                query: dataSource.searchTerm,
                searchSource: dataSource.getSearchTrackingSource(),
                searchLocation: .Modal,
                searchResultType: .Profile,
                searchResultIndex: indexPath.row + 1,
                searchResultId: profile.id,
                category: dataSource.getSearchTrackingCategory(),
                attribute: (dataSource as! ProfilesDataSource).searchTrackerAttribute,
                value: (dataSource as! ProfilesDataSource).searchAttributeValue
            )
            showProfileDetail(profile)
        }
        else if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
            Tracker.sharedInstance.trackSearchResultTap(
                query: dataSource.searchTerm,
                searchSource: dataSource.getSearchTrackingSource(),
                searchLocation: .Modal,
                searchResultType: .Team,
                searchResultIndex: indexPath.row + 1,
                searchResultId: team.id,
                category: dataSource.getSearchTrackingCategory(),
                attribute: (dataSource as! ProfilesDataSource).searchTrackerAttribute,
                value: (dataSource as! ProfilesDataSource).searchAttributeValue
            )
            showTeamDetail(team)
        }
    }
}
