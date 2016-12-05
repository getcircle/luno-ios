//
//  PaddedLabel.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {

    var paddingEdgeInsets = UIEdgeInsetsZero
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let currentRect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        
        // Modify rect as per padding insets
        var rectWithEdgeInsets = currentRect
        
        rectWithEdgeInsets.origin.x -= paddingEdgeInsets.left
        rectWithEdgeInsets.origin.y -= paddingEdgeInsets.top
        rectWithEdgeInsets.size.width += paddingEdgeInsets.left + paddingEdgeInsets.right
        rectWithEdgeInsets.size.height += paddingEdgeInsets.top + paddingEdgeInsets.bottom
        
        return rectWithEdgeInsets
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, paddingEdgeInsets))
    }
}
