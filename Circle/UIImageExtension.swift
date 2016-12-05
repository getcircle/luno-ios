//
//  UIImageExtension.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func imageFromColor(color: UIColor, withRect imageRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, imageRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func templateImage() -> UIImage {
        return imageWithRenderingMode(.AlwaysTemplate)
    }
    
    /*
    * This function tints an image and it should be used only when the default implementation
    * does not support tinting images. E.g., animated images.
    */
    func imageWithTintColor(tintColor: UIColor, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextSetAlpha(context, 1)
        
        let rect = CGRectMake(0.0, 0.0, size.width, size.height)
        CGContextBeginTransparencyLayerWithRect(context, rect, nil)
        tintColor.setFill()
        drawInRect(rect)
        UIRectFillUsingBlendMode(rect, CGBlendMode.SourceIn)
        CGContextEndTransparencyLayer(context)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
