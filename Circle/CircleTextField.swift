//
//  CircleTextField.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleTextField: UITextField {

    var placeholderColor: UIColor?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func drawPlaceholderInRect(rect: CGRect) {
        var defaultPlaceholderColor = UIColor.grayColor().colorWithAlphaComponent(0.75)
        var updatedRect = CGRectInset(rect, 0, (rect.size.height - font.lineHeight) / 2.0)
        placeholder?.drawInRect(
            updatedRect,
            withAttributes: [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: (placeholderColor ?? defaultPlaceholderColor)
            ]
        )
    }
}
