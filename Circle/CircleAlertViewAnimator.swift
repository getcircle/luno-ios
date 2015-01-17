//
//  CircleAlertViewAnimator.swift
//  Circle
//
//  Created by Ravi Rani on 1/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleAlertViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var containerView = transitionContext.containerView()
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        
        if toViewController is CircleAlertViewController {
            // present animation
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = fromViewController.view.frame

            let alertViewController = toViewController as CircleAlertViewController
            alertViewController.parentContainerView.frameBottom = 0.0
            
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    alertViewController.parentContainerView.center = alertViewController.view.center
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
        else if fromViewController is CircleAlertViewController {
            
            // dismiss animation
            let alertViewController = fromViewController as CircleAlertViewController
            
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    alertViewController.parentContainerView.frameY = alertViewController.view.frameHeight
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}
