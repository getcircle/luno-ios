//
//  CALayerExtension.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func cornerRadiusWithMaskToBounds(radius: CGFloat) {
        cornerRadius = radius
        masksToBounds = radius > 0
        contentsScale = UIScreen.mainScreen().scale
    }
    
    static func gradientLayerWithFrame(frame: CGRect, startColor: CGColorRef, endColor: CGColorRef) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [startColor, endColor]
        return gradientLayer
    }
}
