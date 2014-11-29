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
}
