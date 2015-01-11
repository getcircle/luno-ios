//
//  UIImageExtension.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

extension UIImage {

    class func imageFromColor(color: UIColor, withRect imageRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(imageRect.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, imageRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}