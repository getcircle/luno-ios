//
//  CGRectExtension.swift
//  Circle
//
//  Created by Ravi Rani on 1/1/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    func center() -> CGPoint {
        // Midpoint of the diagonal
        return CGPointMake((2 * origin.x + size.width) / 2.0, (2 * origin.y + size.height) / 2.0)
    }
}
