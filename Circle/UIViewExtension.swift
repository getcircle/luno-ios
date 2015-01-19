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
    func makeItCircular(addBorder: Bool) {
        layer.cornerRadiusWithMaskToBounds(bounds.size.width/2.0)
        
        if addBorder {
            layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).CGColor
            layer.borderWidth = 1.0
        }
    }
    
    func addRoundCorners() {
        layer.cornerRadiusWithMaskToBounds(5.0)
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
        borderView.backgroundColor = UIColor.separatorViewColor()
        if let parentView = superview {
            parentView.addSubview(borderView)
            borderView.autoPinEdge(.Left, toEdge: .Left, ofView: self)
            borderView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self, withOffset: withOffset ?? 1.0)
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
}
