//
//  CircleButton.swift
//  Circle
//
//  Created by Ravi Rani on 3/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    var highlightColor: UIColor?
    private var originalBackgroundColor: UIColor? = UIColor.whiteColor()

    override var highlighted: Bool {
        didSet {
            if highlighted {
                backgroundColor = getHighlightedColor()
            }
            else {
                resetToOriginalBackgroundColor()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalBackgroundColor = backgroundColor
    }
    
    private func getHighlightedColor() -> UIColor {
        if let providedHighlightColor = highlightColor {
            return providedHighlightColor
        }
        
        return UIColor.appButtonHighlightColor()
    }

    private func resetToOriginalBackgroundColor() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.backgroundColor = self.originalBackgroundColor
        })
    }
}
