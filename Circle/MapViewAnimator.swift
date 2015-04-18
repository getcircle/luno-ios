//
//  MapViewAnimator.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import UIViewPlusPosition

class MapViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var containerView = transitionContext.containerView()
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        
        if toViewController is MapViewController {
            // present animation
            containerView.addSubview(toViewController.view)

            var officeViewController = ((fromViewController as! MainTabBarViewController).selectedViewController as! UINavigationController).topViewController as! OfficeDetailViewController
            
            var mapViewController = toViewController as! MapViewController
            mapViewController.mapView.frame = mapViewController.initialMapViewRect!
            mapViewController.closeButton.alpha = 0.0
            mapViewController.addressContainerView.frame.origin.y = mapViewController.mapView.frameBottom - mapViewController.addressContainerView.frame.height
            if let headerView = (officeViewController.dataSource as! OfficeDetailDataSource).profileHeaderView as? MapHeaderCollectionReusableView {
                headerView.addressContainerView.hidden = true
            }
            
            let scrollOffset = CGPointMake(0.0, -officeViewController.view.frame.height + mapViewController.addressContainerView.frame.height)
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                animations: { () -> Void in
                    mapViewController.mapView.frame.height = UIScreen.mainScreen().bounds.size.height - 35.0
                    mapViewController.closeButton.alpha = 1.0
                    mapViewController.addressContainerView.frame.origin.y = UIScreen.mainScreen().bounds.size.height - mapViewController.addressContainerView.frame.height
                    officeViewController.collectionView.setContentOffset(scrollOffset, animated: true)
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
        else if fromViewController is MapViewController {

            // dismiss animation
            var officeViewController = ((toViewController as! MainTabBarViewController).selectedViewController as! UINavigationController).topViewController as! OfficeDetailViewController
            var mapViewController = fromViewController as! MapViewController
            mapViewController.mapView.frame.height = UIScreen.mainScreen().bounds.size.height
            mapViewController.closeButton.alpha = 1.0
            mapViewController.addressContainerView.frame.origin.y = mapViewController.mapView.frameBottom - mapViewController.addressContainerView.frame.height
            
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                animations: { () -> Void in
                    mapViewController.mapView.frame.height = mapViewController.finalMapViewRect!.size.height
                    mapViewController.closeButton.alpha = 0.0
                    mapViewController.addressContainerView.frame.origin.y = mapViewController.finalMapViewRect!.size.height - mapViewController.addressContainerView.frame.height
                    officeViewController.collectionView.setContentOffset(CGPointZero, animated: true)
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                    if let headerView = (officeViewController.dataSource as! OfficeDetailDataSource).profileHeaderView as? MapHeaderCollectionReusableView {
                        headerView.addressContainerView.hidden = false
                    }
                }
            )
        }
    }
}
