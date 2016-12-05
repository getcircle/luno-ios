//
//  UINavigationBarExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func makeTransparent() {
        translucent = true
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    
    func makeOpaque() {
        translucent = false
        shadowImage = nil
        setBackgroundImage(nil, forBarMetrics: .Default)
    }
}

