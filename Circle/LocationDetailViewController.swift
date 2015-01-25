//
//  LocationDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationDetailViewController: DetailViewController {

    private let offsetToTriggerFullScreenMapView: CGFloat = -100.0
    private var overlayButtonHandlerAdded = false

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = LocationDetailDataSource()
        delegate = StickyHeaderCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        layout.headerHeight = MapHeaderCollectionReusableView.height
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
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= offsetToTriggerFullScreenMapView {
            scrollView.setContentOffset(scrollView.contentOffset, animated: true)
            presentFullScreenMapView(true)
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        atIndexPath indexPath: NSIndexPath) {
        var customDataSource = (dataSource as LocationDetailDataSource)
        if customDataSource.profileHeaderView != nil && !overlayButtonHandlerAdded {
            customDataSource.profileHeaderView?.overlayButton.addTarget(
                self,
                action: "overlayButtonTapped:",
                forControlEvents: .TouchUpInside
            )

            overlayButtonHandlerAdded = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (collectionView!.dataSource as LocationDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            
            // Todo: need to understand how this changes with orientation
            let statusBarHeight: CGFloat = 0.0
            let navBarHeight: CGFloat = navigationBarHeight()
            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
            let heightToCoverNavBar: CGFloat = navBarStatusBarHeight - profileHeaderView.initialHeightForAddressContainer
            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = MapHeaderCollectionReusableView.height - navBarStatusBarHeight
            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - heightToCoverNavBar
            
            // We want the address label centered in the nav rather than nav bar + status bar
            let finalCenterYConstant: CGFloat = navBarHeight/2.0 - navBarStatusBarHeight/2.0
            let heightAtWhichCenterYShouldStartChanging: CGFloat = navBarStatusBarHeight + finalCenterYConstant
            
            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
                // Update height for address container
                var newHeight: CGFloat = profileHeaderView.initialHeightForAddressContainer
                newHeight += min(heightToCoverNavBar, contentOffset.y - pointAtWhichHeightShouldStartIncreasing)
                profileHeaderView.addressContainerViewHeightConstraint.constant = newHeight
                
                // Update center Y for addressLabel
                var newCenterYConstant: CGFloat = 0.0
                if newHeight >= heightAtWhichCenterYShouldStartChanging {
                    newCenterYConstant = max(finalCenterYConstant, heightAtWhichCenterYShouldStartChanging - newHeight)
                }
                
                profileHeaderView.addressLabelCenterYConstraint.constant = newCenterYConstant
            }
            else {
                profileHeaderView.addressContainerViewHeightConstraint.constant = profileHeaderView.initialHeightForAddressContainer
                profileHeaderView.addressLabelCenterYConstraint.constant = 0.0
            }

            // Update constraints and request layout
            profileHeaderView.addressContainerView.setNeedsUpdateConstraints()
            profileHeaderView.addressContainerView.layoutIfNeeded()
            profileHeaderView.addressLabel.setNeedsUpdateConstraints()
            profileHeaderView.addressLabel.layoutIfNeeded()
        }
    }
    
    // MARK: - Present Map View
    
    private func presentFullScreenMapView(animated: Bool) {
        var mapViewController = MapViewController()
        if let headerView = (dataSource as LocationDetailDataSource).profileHeaderView {
          
            // Add initial and final positions for the map
            mapViewController.initialMapViewRect = headerView.convertRect(headerView.mapView.frame, toView: view)
            let finalRect = CGRect(
                origin: CGPointZero,
                size: CGSizeMake(view.frameWidth, MapHeaderCollectionReusableView.height)
            )
            mapViewController.finalMapViewRect = finalRect
            mapViewController.addressSnapshotView = headerView.addressContainerView.snapshotViewAfterScreenUpdates(false)
            mapViewController.selectedLocation = (dataSource as LocationDetailDataSource).selectedLocation
        }
        
        mapViewController.modalPresentationStyle = .Custom
        mapViewController.transitioningDelegate = mapViewController
        mapViewController.modalPresentationCapturesStatusBarAppearance = true
        presentViewController(mapViewController, animated: animated, completion: nil)
    }
    
    func overlayButtonTapped(sender: AnyObject!) {
        presentFullScreenMapView(true)
    }
}
