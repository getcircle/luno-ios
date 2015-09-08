//
//  UIBarButtonItemExtension.swift
//  Circle
//
//  Created by Felix Mo on 2015-09-07.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    static func roundedItemWithTitle(title: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(frame: CGRectZero)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        button.backgroundColor = UIColor.clearColor()

        button.addRoundCorners(radius: 2.0)
        button.layer.borderWidth = 2.0
        let borderColor = UIColor(white: 1.0, alpha: 0.2)
        button.layer.borderColor = borderColor.CGColor

        button.titleLabel?.font = UIFont.headerTextFont()
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSKernAttributeName: 1.0, NSForegroundColorAttributeName: UIColor.whiteColor()]), forState: .Normal)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSKernAttributeName: 1.0, NSForegroundColorAttributeName: borderColor]), forState: .Highlighted)
        
        let verticalPadding = CGFloat(6.0)
        let horizontalPadding = verticalPadding * 2
        button.contentEdgeInsets = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)
        
        button.sizeToFit()
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }

}
