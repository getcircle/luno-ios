//
//  CircleTextField.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

@objc protocol CircleTextFieldDelegate {
    optional func textFieldDidDeleteBackwardWhenEmpty(textField: CircleTextField)
}

class CircleTextField: UITextField {

    weak var helperDelegate: CircleTextFieldDelegate?
    
    var placeholderColor: UIColor? {
        didSet {
            let defaultPlaceholderColor = UIColor.grayColor().colorWithAlphaComponent(0.75)
            if let placeholderText = placeholder, font = self.font {
                attributedPlaceholder = NSAttributedString(
                    string: placeholderText, 
                    attributes: [
                        NSFontAttributeName: font,
                        NSForegroundColorAttributeName: (placeholderColor ?? defaultPlaceholderColor)
                    ]
                )
            }
        }
    }
    
    override func deleteBackward() {
        let alreadyEmpty = text?.isEmpty ?? true
        
        super.deleteBackward()
        
        if alreadyEmpty {
            helperDelegate?.textFieldDidDeleteBackwardWhenEmpty?(self)
        }
    }
}
