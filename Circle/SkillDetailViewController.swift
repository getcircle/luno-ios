//
//  SkillDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SkillDetailViewController: DetailViewController {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()

        dataSource = SkillDetailDataSource()
        delegate = StickyHeaderCollectionViewDelegate()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        
        // Delegate
        collectionView.delegate = delegate
        
        layout.headerHeight = SkillHeaderCollectionReusableView.height
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

    // MARK: - Scroll view delegate

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (collectionView!.dataSource as SkillDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            
            // Todo: need to understand how this changes with orientation
            let statusBarHeight: CGFloat = 0.0
            let navBarHeight: CGFloat = navigationBarHeight()
            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
            let initialYConstrainValue: CGFloat = 0.0
            let finalYConstraintValue: CGFloat = profileHeaderView.frameHeight/2.0 - navBarHeight/2.0
            // Initial y value is added because for center y constraints this represents additional distance it needs
            // to move down
            let distanceToMove: CGFloat = finalYConstraintValue + initialYConstrainValue
            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = SkillHeaderCollectionReusableView.height - navBarStatusBarHeight
            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - distanceToMove
            
            // Y Constraint has to be modified only after a certain point
            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
                var newY: CGFloat = initialYConstrainValue
                newY += max(-distanceToMove, -contentOffset.y + pointAtWhichHeightShouldStartIncreasing)
                profileHeaderView.skillNameLabelCenterYConstraint.constant = newY
            }
            else {
                profileHeaderView.skillNameLabelCenterYConstraint.constant = initialYConstrainValue
            }
            
            let minFontSize: CGFloat = 15.0
            let maxFontSize: CGFloat = profileHeaderView.skillLabelInitialFontSize
            let pointAtWhichSizeShouldStartChanging: CGFloat = 20.0

            // Size needs to be modified much sooner
            if contentOffset.y > pointAtWhichSizeShouldStartChanging {
                var size = max(minFontSize, maxFontSize - ((contentOffset.y - pointAtWhichSizeShouldStartChanging) / (maxFontSize - minFontSize)))
                profileHeaderView.skillNameLabel.font = UIFont(name: profileHeaderView.skillNameLabel.font.familyName, size: size)
            }
            else {
                profileHeaderView.skillNameLabel.font = UIFont(name: profileHeaderView.skillNameLabel.font.familyName, size: maxFontSize)
            }
            
            // Update constraints and request layout
            profileHeaderView.skillNameLabel.setNeedsUpdateConstraints()
            profileHeaderView.skillNameLabel.layoutIfNeeded()
        }
    }
}
