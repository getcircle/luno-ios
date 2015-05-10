//
//  GroupDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class GroupDetailViewController: DetailViewController {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = GroupDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        
        // Delegate
        collectionView.delegate = delegate
        
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = GroupHeaderCollectionReusableView.height
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
            let profileVC = ProfileDetailViewController(profile: profile)
            navigationController?.pushViewController(profileVC, animated: true)
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let groupHeaderView = (collectionView!.dataSource as! GroupDetailDataSource).groupHeaderView {
            let contentOffset = scrollView.contentOffset
            
            // Todo: need to understand how this changes with orientation
            let statusBarHeight: CGFloat = currentStatusBarHeight()
            let navBarHeight: CGFloat = navigationBarHeight()
            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
            let initialYConstrainValue: CGFloat = groupHeaderView.groupNameLabelCenterYConstraintInitialValue
            let finalYConstraintValue: CGFloat = groupHeaderView.frame.height/2.0 - navBarHeight/2.0
            // Initial y value is added because for center y constraints this represents additional distance it needs
            // to move down
            let distanceToMove: CGFloat = finalYConstraintValue + initialYConstrainValue
            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = GroupHeaderCollectionReusableView.height - navBarStatusBarHeight
            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - distanceToMove
            
            // Y Constraint has to be modified only after a certain point
            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
                var newY: CGFloat = initialYConstrainValue
                newY += max(-distanceToMove, -contentOffset.y + pointAtWhichHeightShouldStartIncreasing)
                groupHeaderView.groupNameLabelCenterYConstraint.constant = newY
            }
            else {
                groupHeaderView.groupNameLabelCenterYConstraint.constant = initialYConstrainValue
            }
            
            let minFontSize: CGFloat = 15.0
            let maxFontSize: CGFloat = groupHeaderView.groupNameLabelInitialFontSize
            let pointAtWhichSizeShouldStartChanging: CGFloat = 20.0
            
            // Size needs to be modified much sooner
            if contentOffset.y > pointAtWhichSizeShouldStartChanging {
                var size = max(minFontSize, maxFontSize - ((contentOffset.y - pointAtWhichSizeShouldStartChanging) / (maxFontSize - minFontSize)))
                groupHeaderView.groupNameLabel.font = UIFont(name: groupHeaderView.groupNameLabel.font.familyName, size: size)
            }
            else {
                groupHeaderView.groupNameLabel.font = UIFont(name: groupHeaderView.groupNameLabel.font.familyName, size: maxFontSize)
            }
            
            // Modify alpha for departmentlabel
            if contentOffset.y > 0.0 {
                groupHeaderView.groupSecondaryInfoLabel.alpha = 1.0 - contentOffset.y/(groupHeaderView.groupSecondaryInfoLabel.frame.origin.y - 40.0)
            }
            else {
                groupHeaderView.groupSecondaryInfoLabel.alpha = 1.0
            }
            
            // Update constraints and request layout
            groupHeaderView.groupNameLabel.setNeedsUpdateConstraints()
            groupHeaderView.groupNameLabel.layoutIfNeeded()
        }
    }
}
