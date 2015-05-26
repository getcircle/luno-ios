//
//  GroupsViewController.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class GroupsViewController: OverviewViewController {

    override func filterPlaceHolderComment() -> String {
        return "Placeholder for text field use for filtering groups."
    }
    
    override func filterPlaceHolderText() -> String {
        return "Filter groups"
    }
    
    // MARK: - Initialization
    
    override func initializeDataSource() -> CardDataSource {
        return GroupsDataSource()
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let group = dataSource.contentAtIndexPath(indexPath) as? Services.Group.Containers.GroupV1 {
            trackViewGroup(group)
            let groupDetailVC = GroupDetailViewController()
            (groupDetailVC.dataSource as! GroupDetailDataSource).selectedGroup = group
            navigationController?.pushViewController(groupDetailVC, animated: true)
        }
    }
    
    // MARK: - Tracking
    
    private func trackViewGroup(group: Services.Group.Containers.GroupV1) {
        var properties = [
            TrackerProperty.withDestinationId("groupId").withString(group.id),
            TrackerProperty.withKey(.Source).withSource(.Overview),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Group),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        if let title = self.title {
            properties.append(TrackerProperty.withKey(.SourceOverviewType).withString(title))
        }
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
}
