//
//  UIImageViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

extension UIImageView {

    // It is assumed that the image would be 1:1 aspect ratio
    func makeItCircular() {
        self.layer.cornerRadius = self.bounds.size.width/2.0
        self.layer.masksToBounds = true
    }
}
