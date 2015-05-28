//
//  GroupsViewController.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class GroupsViewController: OverviewViewController, GroupJoinRequestDelegate {

    override func filterPlaceHolderComment() -> String {
        return "Placeholder for text field use for filtering groups."
    }
    
    override func filterPlaceHolderText() -> String {
        return "Filter groups"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (dataSource as! GroupsDataSource).groupJoinRequestDelegate = self
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
    
    // MARK: - GroupJoinRequestDelegate
    
    func onJoinGroupButtonTapped(sender: UIView, group: Services.Group.Containers.GroupV1) {
        let buttonPoint = collectionView.convertPoint(sender.center, fromView: sender.superview)

        if let selectedIndexPath = collectionView.indexPathForItemAtPoint(buttonPoint) {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Group.Actions.joinGroup(group.email, completionHandler: { (request, error) -> Void in
                hud.hide(true)
                if let request = request where error == nil {
                    // TODO: Manually update the hasRequested to true for this group
                    if request.status == .Approved {
                        self.showToast(AppStrings.GroupJoinSuccessConfirmation)
                    }
                    else {
                        self.showToast(AppStrings.GroupRequestSentConfirmation)
                    }
                    
                    self.updateGroup(group, atIndexPath: selectedIndexPath)
                }
            })
        }
    }
    
    private func updateGroup(group: Services.Group.Containers.GroupV1, atIndexPath indexPath: NSIndexPath) {
        Services.Group.Actions.getGroup(group.email, completionHandler: { (updatedGroup, error) -> Void in
            if let updatedGroup = updatedGroup {
                (self.dataSource as! GroupsDataSource).replaceLocalGroup(updatedGroup, atIndex: indexPath.row)
                self.collectionView.reloadData()
            }
            else {
                // Ideally we would check for specific group error and remove it from the list
                // Some error..refresh all groups
                self.loadData()
            }
        })
    }
}
