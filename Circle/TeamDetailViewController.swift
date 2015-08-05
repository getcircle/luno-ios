//
//  TeamDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamDetailViewController: DetailViewController, EditTeamViewControllerDelegate {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()

        dataSource = TeamDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        
        // Delegate
        collectionView.delegate = delegate
        
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = TeamHeaderCollectionReusableView.height
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let tappedCard = dataSource.cardAtSection(indexPath.section) {
            switch tappedCard.type {
            case .Profiles:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    let profileVC = ProfileDetailViewController(profile: profile)
                    navigationController?.pushViewController(profileVC, animated: true)
                }

            case .Settings:
                let editTeamViewController = EditTeamViewController(nibName: "EditTeamViewController", bundle: nil)
                let editTeamNavController = UINavigationController(rootViewController: editTeamViewController)
                editTeamViewController.team = (dataSource as! TeamDetailDataSource).selectedTeam
                editTeamViewController.editTeamViewControllerDelegate = self
                navigationController?.presentViewController(editTeamNavController, animated: true, completion: nil)

            default:
                break
            }
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (collectionView!.dataSource as! TeamDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            
            // Todo: need to understand how this changes with orientation
            let statusBarHeight: CGFloat = currentStatusBarHeight()
            let navBarHeight: CGFloat = navigationBarHeight()
            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
            let initialYConstrainValue: CGFloat = profileHeaderView.teamNameLabelCenterYConstraintInitialValue
            let finalYConstraintValue: CGFloat = profileHeaderView.frame.height/2.0 - navBarHeight/2.0
            // Initial y value is added because for center y constraints this represents additional distance it needs
            // to move down
            let distanceToMove: CGFloat = finalYConstraintValue + initialYConstrainValue
            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = TeamHeaderCollectionReusableView.height - navBarStatusBarHeight
            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - distanceToMove
            
            // Y Constraint has to be modified only after a certain point
            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
                var newY: CGFloat = initialYConstrainValue
                newY += max(-distanceToMove, -contentOffset.y + pointAtWhichHeightShouldStartIncreasing)
                profileHeaderView.teamNameLabelCenterYConstraint.constant = newY
            }
            else {
                profileHeaderView.teamNameLabelCenterYConstraint.constant = initialYConstrainValue
            }
            
            let minFontSize: CGFloat = 15.0
            let maxFontSize: CGFloat = profileHeaderView.teamNameLabelInitialFontSize
            let pointAtWhichSizeShouldStartChanging: CGFloat = 20.0
            
            // Size needs to be modified much sooner
            if contentOffset.y > pointAtWhichSizeShouldStartChanging {
                var size = max(minFontSize, maxFontSize - ((contentOffset.y - pointAtWhichSizeShouldStartChanging) / (maxFontSize - minFontSize)))
                profileHeaderView.teamNameLabel.font = UIFont(name: profileHeaderView.teamNameLabel.font.familyName, size: size)
            }
            else {
                profileHeaderView.teamNameLabel.font = UIFont(name: profileHeaderView.teamNameLabel.font.familyName, size: maxFontSize)
            }
            
            // Modify alpha for subTitleLabel
            if contentOffset.y > 0.0 {
                profileHeaderView.subTitleLabel.alpha = 1.0 - contentOffset.y/(profileHeaderView.subTitleLabel.frame.origin.y - 40.0)
            }
            else {
                profileHeaderView.subTitleLabel.alpha = 1.0
            }
            
            // Update constraints and request layout
            profileHeaderView.teamNameLabel.setNeedsUpdateConstraints()
            profileHeaderView.teamNameLabel.layoutIfNeeded()
        }
    }
    
    // MARK: - EditTeamViewControllerDelegate
    
    func onTeamDetailsUpdated(team: Services.Organization.Containers.TeamV1) {
        (dataSource as! TeamDetailDataSource).selectedTeam = team
        loadData()
    }
}
