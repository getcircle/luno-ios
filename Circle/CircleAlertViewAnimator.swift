//
//  CircleAlertViewAnimator.swift
//  Circle
//
//  Created by Ravi Rani on 1/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleAlertViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        
        if toViewController is CircleAlertViewController {
            // present animation
            containerView?.addSubview(toViewController.view)
            toViewController.view.frame = fromViewController.view.frame

            let alertViewController = toViewController as! CircleAlertViewController
            alertViewController.parentContainerViewCenterYConstraint.constant = -(alertViewController.view.frame.height / 2.0 + alertViewController.parentContainerView.frame.height / 2.0)
            alertViewController.parentContainerView.setNeedsUpdateConstraints()
            alertViewController.parentContainerView.layoutIfNeeded()
            alertViewController.visualEffectView.alpha = 0.0

            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.8,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    alertViewController.parentContainerViewCenterYConstraint.constant = 0.0
                    alertViewController.parentContainerView.setNeedsUpdateConstraints()
                    alertViewController.parentContainerView.layoutIfNeeded()
                    alertViewController.visualEffectView.alpha = 1.0
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
        else if fromViewController is CircleAlertViewController {
            
            // dismiss animation
            let alertViewController = fromViewController as! CircleAlertViewController
            
            UIView.animateWithDuration(
                transitionDuration(transitionContext),
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    alertViewController.parentContainerViewCenterYConstraint.constant = (alertViewController.view.frame.height / 2.0 + alertViewController.parentContainerView.frame.height / 2.0)
                    alertViewController.parentContainerView.setNeedsUpdateConstraints()
                    alertViewController.parentContainerView.layoutIfNeeded()
                    alertViewController.visualEffectView.alpha = 0.0
                },
                completion:{ (completed) -> Void in
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}
