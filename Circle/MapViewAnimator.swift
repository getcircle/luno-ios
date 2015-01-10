//
//  MapViewAnimator.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

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

            var locationViewController = (fromViewController as UINavigationController).topViewController as LocationDetailViewController
            let scrollOffset = CGPointMake(0.0, -locationViewController.view.frameHeight)
            
            var mapViewController = toViewController as MapViewController
            mapViewController.mapboxView.frame = mapViewController.initialMapViewRect!
            mapViewController.closeButton.alpha = 0.0
            mapViewController.addressContainerView.frameY = mapViewController.mapboxView.frameBottom - mapViewController.addressContainerView.frameHeight
            
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                animations: { () -> Void in
                    mapViewController.mapboxView.frameHeight = UIScreen.mainScreen().bounds.size.height
                    mapViewController.closeButton.alpha = 1.0
                    mapViewController.addressContainerView.frameY = UIScreen.mainScreen().bounds.size.height - mapViewController.addressContainerView.frameHeight
                    locationViewController.collectionView.setContentOffset(scrollOffset, animated: true)
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
        else if fromViewController is MapViewController {

            // dismiss animation
            var locationViewController = (toViewController as UINavigationController).topViewController as LocationDetailViewController
            var mapViewController = fromViewController as MapViewController
            mapViewController.mapboxView.frameHeight = UIScreen.mainScreen().bounds.size.height
            mapViewController.closeButton.alpha = 1.0
            mapViewController.addressContainerView.frameY = mapViewController.mapboxView.frameBottom - mapViewController.addressContainerView.frameHeight
            
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                animations: { () -> Void in
                    mapViewController.mapboxView.frameHeight = mapViewController.finalMapViewRect!.size.height
                    mapViewController.closeButton.alpha = 0.0
                    mapViewController.addressContainerView.frameY = mapViewController.finalMapViewRect!.size.height - mapViewController.addressContainerView.frameHeight
                    locationViewController.collectionView.setContentOffset(CGPointZero, animated: true)
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}
