//
//  ProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailViewController: DetailViewController {

    var profile: ProfileService.Containers.Profile!
    
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = ProfileDetailDataSource()
        delegate = StickyHeaderCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        (dataSource as ProfileDetailDataSource).profile = profile

        // Delegate
        collectionView.delegate = delegate
        
        layout.headerHeight = ProfileHeaderCollectionReusableView.height
        
        super.configureCollectionView()
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = collectionView.dataSource as ProfileDetailDataSource
        if let card = dataSource.cardAtSection(indexPath.section) {
            switch card.type {
            case .KeyValue:
                handleKeyValueCardSelection(dataSource, indexPath: indexPath)
            default:
                break
            }
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    private func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .Email:
            presentMailViewController([profile.email], subject: "Hey", messageBody: "", completionHandler: nil)

        case .Manager:
            let profileVC = ProfileDetailViewController()
            profileVC.profile = dataSource.manager
            navigationController?.pushViewController(profileVC, animated: true)

        case .Team:
            let teamVC = TeamDetailViewController()
            (teamVC.dataSource as TeamDetailDataSource).selectedTeam = dataSource.team!
            navigationController?.pushViewController(teamVC, animated: true)

        default:
            break
        }
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        if let profileHeaderView = (collectionView!.dataSource as ProfileDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            let minOffsetToMakeChanges: CGFloat = 20.0
            
            // Do not change anything unless user scrolls up more than 20 points
            if contentOffset.y > minOffsetToMakeChanges {
                
                // Scale down the image and reduce opacity
                let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileHeaderView.profileImage.frameY
                profileHeaderView.profileImage.alpha = profileImageFractionValue
                if profileImageFractionValue >= 0 {
                    var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                    profileHeaderView.profileImage.transform = transform
                }
                
                // Reduce opacity of the name and title label at a faster pace
                let titleLabelAlpha = 1.0 - contentOffset.y/(profileHeaderView.titleLabel.frameY - 40.0)
                profileHeaderView.titleLabel.alpha = titleLabelAlpha
                profileHeaderView.nameLabel.alpha = 1.0 - contentOffset.y/(profileHeaderView.nameLabel.frameY - 40.0)
                profileHeaderView.nameNavLabel.alpha = titleLabelAlpha <= 0.0 ? profileHeaderView.nameNavLabel.alpha + 1/20 : 0.0
            }
            else {
                // Change alpha faster for profile image
                let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
                
                // Change it slower for everything else
                let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
                profileHeaderView.nameLabel.alpha = otherViewsAlpha
                profileHeaderView.nameNavLabel.alpha = 0.0
                profileHeaderView.titleLabel.alpha = otherViewsAlpha
                profileHeaderView.profileImage.alpha = profileImageAlpha
                profileHeaderView.visualEffectView.alpha = otherViewsAlpha
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
        }

    }
    
}
