//
//  GradientView.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
}
