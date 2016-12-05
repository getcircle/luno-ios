//
//  TeamsOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/23/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamsOverviewViewController: OverviewViewController {
    
    override func filterPlaceHolderComment() -> String {
        return "Placeholder for text field used for filtering teams."
    }
    
    override func filterPlaceHolderText() -> String {
        return "Filter teams"
    }
    
    // MARK: - Initialization
    
    override func initializeDataSource() -> CardDataSource {
        return TeamsOverviewDataSource()
    }
    
    // MARK: - Collection View Delegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
            Tracker.sharedInstance.trackSearchResultTap(
                query: dataSource.searchTerm,
                searchSource: dataSource.getSearchTrackingSource(),
                searchLocation: .Modal,
                searchResultType: .Team,
                searchResultIndex: indexPath.row + 1,
                searchResultId: team.id,
                category: dataSource.getSearchTrackingCategory(),
                attribute: (dataSource as! TeamsOverviewDataSource).searchTrackerAttribute,
                value: (dataSource as! TeamsOverviewDataSource).searchAttributeValue
            )
            showTeamDetail(team)
        }
    }    
}
