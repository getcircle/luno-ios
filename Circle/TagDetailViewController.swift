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
        delegate = StickyHeaderCollectionViewDelegate()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        
        // Delegate
        collectionView.delegate = delegate
        
        layout.headerHeight = TagHeaderCollectionReusableView.height
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
            let profileVC = ProfileDetailsViewController.forProfile(profile)
            navigationController?.pushViewController(profileVC, animated: true)
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (collectionView!.dataSource as TagDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            
            // Todo: need to understand how this changes with orientation
            let statusBarHeight: CGFloat = 0.0
            let navBarHeight: CGFloat = navigationController?.navigationBar.frameHeight ?? 44.0
            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
            let initialYConstrainValue: CGFloat = 0.0
            let finalYConstraintValue: CGFloat = profileHeaderView.frameHeight/2.0 - navBarHeight/2.0
            let distanceToMove: CGFloat = finalYConstraintValue - initialYConstrainValue
            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = TagHeaderCollectionReusableView.height - navBarStatusBarHeight
            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - distanceToMove
            
            // Y Constraint has to be modified only after a certain point
            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
                var newY: CGFloat = initialYConstrainValue
                newY += max(-finalYConstraintValue, -contentOffset.y + pointAtWhichHeightShouldStartIncreasing)
                profileHeaderView.tagNameLabelCenterYConstraint.constant = newY
            }
            else {
                profileHeaderView.tagNameLabelCenterYConstraint.constant = 0.0
            }
            
            let minFontSize: CGFloat = 15.0
            let maxFontSize: CGFloat = profileHeaderView.tagLabelInitialFontSize
            let pointAtWhichSizeShouldStartChanging: CGFloat = 20.0

            // Size needs to be modified much sooner
            if contentOffset.y > pointAtWhichSizeShouldStartChanging {
                var size = max(minFontSize, maxFontSize - ((contentOffset.y - pointAtWhichSizeShouldStartChanging) / (maxFontSize - minFontSize)))
                profileHeaderView.tagNameLabel.font = UIFont(name: profileHeaderView.tagNameLabel.font.familyName, size: size)
            }
            else {
                profileHeaderView.tagNameLabel.font = UIFont(name: profileHeaderView.tagNameLabel.font.familyName, size: maxFontSize)
            }
            
            // Update constraints and request layout
            profileHeaderView.tagNameLabel.setNeedsUpdateConstraints()
            profileHeaderView.tagNameLabel.layoutIfNeeded()
        }
    }
}
