//
//  UILabelExtension.swift
//  Luno
//
//  Created by Ravi Rani on 10/14/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

extension UILabel {
    func size(constrainedToWidth width: CGFloat) -> CGSize {
        if let text = text {
            return (text as NSString).boundingRectWithSize(
                CGSize(width: width, height: CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font],
                context: nil
            ).size
        }
        
        return CGSizeZero
    }
}
