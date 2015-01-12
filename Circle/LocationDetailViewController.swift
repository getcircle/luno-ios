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

    private var offsetToTriggerFullScreenMapView: CGFloat = -100.0
    private var overlayButtonHandlerAdded = false
    
    // MARK: - Configuration

    override func configureCollectionView() {
        // Data Source
        dataSource = LocationDetailDataSource()
        collectionView.dataSource = dataSource

        // Delegate
        delegate = ProfileCollectionViewDelegate()
        collectionView.delegate = delegate
        
        layout.headerHeight = MapHeaderCollectionReusableView.height
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
