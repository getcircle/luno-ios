//
//  UIViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIView {
    // It is assumed that the view would be 1:1 aspect ratio
    func makeItCircular(addBorder: Bool, borderColor: UIColor? = UIColor.appProfileImageBorderColor()) {
        layer.cornerRadiusWithMaskToBounds(bounds.size.width/2.0)
        
        if addBorder {
            layer.borderColor = borderColor?.CGColor ?? UIColor.appProfileImageBorderColor().CGColor
            layer.borderWidth = 1.0
        }
    }
    
    func makeItCircular() {
        makeItCircular(false)
    }
    
    func addRoundCorners(radius: CGFloat? = 5.0) {
        let cornerRadius = radius ?? 5.0
        layer.cornerRadiusWithMaskToBounds(cornerRadius)
    }
    
    func addShakeAnimation() {
        var animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(center.x - 20.0, center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(center.x + 20.0, center.y))
        layer.addAnimation(animation, forKey: "position")
    }
    
    func addBottomBorder(offset withOffset: CGFloat? = 1.0) -> UIView {
        var borderView = UIView(forAutoLayout: ())
        borderView.backgroundColor = UIColor.appSeparatorViewColor()
        if let parentView = superview {
            parentView.addSubview(borderView)
            borderView.autoPinEdge(.Left, toEdge: .Left, ofView: self)
            borderView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset: withOffset ?? 1.0)
            borderView.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            borderView.autoSetDimension(.Height, toSize: 0.5)
        }
        
        return borderView
    }
    
    func addTopBorder(offset withOffset: CGFloat? = 1.0) -> UIView {
        var borderView = UIView(forAutoLayout: ())
        borderView.backgroundColor = UIColor.appSeparatorViewColor()
        if let parentView = superview {
            parentView.addSubview(borderView)
            borderView.autoPinEdge(.Left, toEdge: .Left, ofView: self)
            borderView.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: withOffset ?? 1.0)
            borderView.autoMatchDimension(.Width, toDimension: .Width, ofView: self)
            borderView.autoSetDimension(.Height, toSize: 0.5)
        }
        
        return borderView
    }
    
    func addGradientView() -> UIView {
        var gradientView = GradientView(forAutoLayout: ())
        gradientView.backgroundColor = UIColor.clearColor()
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        gradientView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        return gradientView
    }
    
    func addVisualEffectView(style: UIBlurEffectStyle) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        var visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(visualEffectView)
        sendSubviewToBack(visualEffectView)
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        return visualEffectView
    }
    
    func addActivityIndicator(color: UIColor = UIColor.appActivityIndicatorViewColor(), start: Bool = true) -> CircleActivityIndicatorView {
        var activityIndicatorView = CircleActivityIndicatorView()
        activityIndicatorView.tintColor = color
        activityIndicatorView.hidesWhenStopped = true
        if start {
            activityIndicatorView.startAnimating()
        }
        addSubview(activityIndicatorView)
        bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        let height = min(frameHeight - 10.0, CircleActivityIndicatorView.height)
        let width = height
        activityIndicatorView.autoSetDimensionsToSize(CGSizeMake(width, height))
        
        return activityIndicatorView
    }

    func addErrorMessageView(error: NSError?, tryAgainHandler: (()-> Void)?) -> CircleErrorMessageView {
        var errorView = CircleErrorMessageView(error: error, errorHandler: tryAgainHandler)
        errorView.hide()
        addSubview(errorView)
        bringSubviewToFront(errorView)
        errorView.autoCenterInSuperview()
        let height = min(frameHeight - 10.0, CircleErrorMessageView.height)
        let width = frameWidth
        errorView.autoSetDimensionsToSize(CGSizeMake(width, height))
        return errorView
    }
}
