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
//        if let group = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
//            trackViewProfile(profile)
//            let profileVC = ProfileDetailViewController(profile: profile)
//            navigationController?.pushViewController(profileVC, animated: true)
//        }
    }
    
    // MARK: - Tracking
    
    private func trackViewGroup(profile: Services.Group.Containers.GroupV1) {
//        var properties = [
//            TrackerProperty.withDestinationId("profileId").withString(profile.id),
//            TrackerProperty.withKey(.Source).withSource(.Overview),
//            TrackerProperty.withKey(.Destination).withSource(.Detail),
//            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile),
//            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
//        ]
//        if let title = self.title {
//            properties.append(TrackerProperty.withKey(.SourceOverviewType).withString(title))
//        }
//        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
}
