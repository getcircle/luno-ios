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
    func makeItCircular(addBorder: Bool) {
        self.layer.cornerRadius = self.bounds.size.width/2.0
        self.layer.masksToBounds = true
        
        if addBorder {
            self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).CGColor
            self.layer.borderWidth = 1.0
        }
    }
}
