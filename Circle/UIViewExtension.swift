//
//  UIViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

extension UIView {
    func addRoundCorners() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
    func addShakeAnimation() {
        var animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 20.0, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 20.0, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }
}
