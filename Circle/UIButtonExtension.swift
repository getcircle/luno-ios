//
//  UIButtonExtension.swift
//  Circle
//
//  Created by Ravi Rani on 2/23/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIButton {

    func convertToTemplateImageForState(state: UIControlState) {
        setImage(imageForState(state)?.imageWithRenderingMode(.AlwaysTemplate), forState: state)
    }
    
    func setCustomAttributedTitle(title: String, forState state: UIControlState) {
        setCustomAttributedTitle(title, forState: .Normal, withColor: UIColor.whiteColor())
    }
    
    func setCustomAttributedTitle(title: String, forState state: UIControlState, withColor color: UIColor) {
        setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [
                    NSKernAttributeName: NSNumber(double: 2.0),
                    NSForegroundColorAttributeName: color,
                    NSFontAttributeName: titleLabel!.font
                ]
            ),
            forState: state
        )
    }
}
