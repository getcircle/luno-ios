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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButtons()
    }
    
    // MARK: - Initialization
    
    override func initializeDataSource() -> CardDataSource {
        return GroupsDataSource()
    }
    
    // MARK: - Configuration
    
    private func configureNavButtons() {
        addAddButtonWithAction("addGroupMemberButtonTapped:")
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
    
    // MARK: - IBAction
    
    @IBAction func addGroupMemberButtonTapped(sender: AnyObject!) {
        let profilesSelectorViewController = ProfilesSelectorViewController()
        // Don't add the default search/filter textfield...instead VC adds a token field
        profilesSelectorViewController.addSearchFilterView = false
        let addMemberNavController = UINavigationController(rootViewController: profilesSelectorViewController)
        navigationController?.presentViewController(addMemberNavController, animated: true, completion: nil)
    }
}
