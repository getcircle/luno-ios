//
//  CALayerExtension.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation

extension CALayer {
    
    func cornerRadiusWithMaskToBounds(radius: CGFloat) {
        cornerRadius = radius
        masksToBounds = true
    }
    
}