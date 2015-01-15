//
//  TagDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagDetailViewController: DetailViewController {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        dataSource = TagDetailDataSource()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        
        // Delegate
        delegate = ProfileCollectionViewDelegate()
        collectionView.delegate = delegate
        
        layout.headerHeight = TagHeaderCollectionReusableView.height
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
            var profileVC = ProfileDetailViewController()
            profileVC.profile = profile
            navigationController?.pushViewController(profileVC, animated: true)
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if let profileHeaderView = (collectionView!.dataSource as LocationDetailDataSource).profileHeaderView {
//            let contentOffset = scrollView.contentOffset
//            
//            // Todo: need to understand how this changes with orientation
//            let statusBarHeight: CGFloat = 20.0
//            let navBarHeight: CGFloat = navigationController!.navigationBar.frameHeight
//            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
//            let heightToCoverNavBar: CGFloat = navBarStatusBarHeight - profileHeaderView.initialHeightForAddressContainer
//            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = MapHeaderCollectionReusableView.height - navBarStatusBarHeight
//            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - heightToCoverNavBar
//            
//            // We want the address label centered in the nav rather than nav bar + status bar
//            let finalCenterYConstant: CGFloat = navBarHeight/2.0 - navBarStatusBarHeight/2.0
//            let heightAtWhichCenterYShouldStartChanging: CGFloat = navBarStatusBarHeight + finalCenterYConstant
//            
//            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
//                // Update height for address container
//                var newHeight: CGFloat = profileHeaderView.initialHeightForAddressContainer
//                newHeight += min(heightToCoverNavBar, contentOffset.y - pointAtWhichHeightShouldStartIncreasing)
//                profileHeaderView.addressContainerViewHeightConstraint.constant = newHeight
//                
//                // Update center Y for addressLabel
//                var newCenterYConstant: CGFloat = 0.0
//                if newHeight >= heightAtWhichCenterYShouldStartChanging {
//                    newCenterYConstant = max(finalCenterYConstant, heightAtWhichCenterYShouldStartChanging - newHeight)
//                }
//                
//                profileHeaderView.addressLabelCenterYConstraint.constant = newCenterYConstant
//            }
//            else {
//                profileHeaderView.addressContainerViewHeightConstraint.constant = profileHeaderView.initialHeightForAddressContainer
//                profileHeaderView.addressLabelCenterYConstraint.constant = 0.0
//            }
//            
//            // Update constraints and request layout
//            profileHeaderView.addressContainerView.setNeedsUpdateConstraints()
//            profileHeaderView.addressContainerView.layoutIfNeeded()
//            profileHeaderView.addressLabel.setNeedsUpdateConstraints()
//            profileHeaderView.addressLabel.layoutIfNeeded()
//        }
    }
}
