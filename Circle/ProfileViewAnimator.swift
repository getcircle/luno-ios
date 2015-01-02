//
//  ProfileViewAnimator.swift
//  Circle
//
//  Created by Ravi Rani on 12/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak private var weakTransitionContext: UIViewControllerContextTransitioning?
    private var isDismissAnimation = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        if toViewController is ProfileViewController {
            containerView.addSubview((toViewController as UIViewController!).view)
            presentAnimation(toViewController as ProfileViewController, transitionContext: transitionContext)
        }
        else {
            containerView.insertSubview((toViewController as UIViewController!).view, atIndex: 0)
            isDismissAnimation = true
            presentAnimation(fromViewController as ProfileViewController, transitionContext: transitionContext)
        }
    }
    
    private func presentAnimation(profileVC: ProfileViewController, transitionContext: UIViewControllerContextTransitioning) {
        weakTransitionContext = transitionContext
        let sourceRect = profileVC.animationSourceRect? ?? CGRectMake(256.0, 20.0, 44.0, 44.0)
        let sourceCenter = sourceRect.center()
        
        // Initial circle for the mask layer
        let pathInitial = UIBezierPath(ovalInRect: sourceRect)
        let topMostPointForFinalCircle = CGPointMake(sourceCenter.x, sourceCenter.y - CGRectGetHeight(profileVC.view.bounds))
        let xDelta = sourceCenter.x - topMostPointForFinalCircle.x
        let yDelta = sourceCenter.y - topMostPointForFinalCircle.y
        let radius = sqrt((xDelta * xDelta) + (yDelta * yDelta))
        let pathFinal = UIBezierPath(ovalInRect: CGRectInset(sourceRect, -radius, -radius))

        // Mask Layer
        var maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.redColor().CGColor
        maskLayer.path = isDismissAnimation ? pathInitial.CGPath : pathFinal.CGPath
        profileVC.view.layer.mask = maskLayer

        // Animate the increase in radius
        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.duration = transitionDuration(transitionContext)
        if isDismissAnimation {
            maskLayerAnimation.fromValue = pathFinal.CGPath
            maskLayerAnimation.toValue = pathInitial.CGPath
        }
        else {
            maskLayerAnimation.fromValue = pathInitial.CGPath
            maskLayerAnimation.toValue = pathFinal.CGPath
        }
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
    }

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if isDismissAnimation {
            weakTransitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
        }
        else {
            weakTransitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        }
        weakTransitionContext?.completeTransition(true)
    }
}