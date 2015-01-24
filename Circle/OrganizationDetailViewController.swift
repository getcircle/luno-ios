//
//  OrganizationDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OrganizationDetailViewController: DetailViewController, CardHeaderViewDelegate {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()

        dataSource = OrganizationDetailDataSource()
        delegate = OrganizationDetailCollectionViewDelegate()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        dataSource.registerDefaultCardHeader(collectionView)
        dataSource.cardHeaderDelegate = self
        
        // Delegate
        collectionView.delegate = delegate

        // Header height
        layout.headerHeight = OrganizationHeaderCollectionReusableView.height

        super.configureCollectionView()
    }

    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let profileHeaderView = (collectionView!.dataSource as OrganizationDetailDataSource).profileHeaderView {
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
                let titleLabelAlpha = 1.0 - contentOffset.y/(profileHeaderView.nameNavLabel.frameY - 40.0)
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
                profileHeaderView.profileImage.alpha = profileImageAlpha
                profileHeaderView.visualEffectView.alpha = otherViewsAlpha
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        
        switch selectedCard.type {
        case .People, .Birthdays, .Anniversaries, .NewHires:
            if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
                let viewController = ProfileDetailViewController()
                viewController.profile = profile
                navigationController?.pushViewController(viewController, animated: true)
            }
        case .Group:
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            viewController.dataSource.setInitialData(selectedCard.content[0] as [AnyObject], ofType: nil)
            viewController.title = selectedCard.title
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Locations:
            if let locationAddress = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Address {
                let viewController = LocationDetailViewController()
                (viewController.dataSource as LocationDetailDataSource).selectedLocation = locationAddress
                navigationController?.pushViewController(viewController, animated: true)
            }

        case .TeamsGrid:
            if let selectedTeam = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Team {
                let viewController = TeamDetailViewController()
                (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        default:
            performSegueWithIdentifier("showListOfPeople", sender: collectionView)
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(card: Card!) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        switch card.type {
        case .Group, .People, .Birthdays, .Anniversaries, .NewHires:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            if card.type == .Group {
                viewController.dataSource.setInitialData(card.content[0] as [AnyObject], ofType: nil)
            }
            else {
                viewController.dataSource.setInitialData(card.allContent, ofType: card.type)
            }
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Locations:
            let viewController = LocationsOverviewViewController(nibName: "LocationsOverviewViewController", bundle: nil)
            viewController.dataSource.setInitialData(card.allContent, ofType: nil)
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)
        
        case .TeamsGrid:
            let viewController = TeamsOverviewViewController(nibName: "TeamsOverviewViewController", bundle: nil) 
            viewController.dataSource.setInitialData(card.allContent, ofType: nil)
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)

        default:
            break
        }
    }
}
