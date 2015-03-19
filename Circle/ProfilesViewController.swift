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
    
    override func initializeDataSource() -> CardDataSource {
        return ProfilesDataSource()
    }

    // MARK: - Collection View Delegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
            trackViewProfile(profile)
            let profileVC = ProfileDetailViewController(profile: profile)
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
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

}
