//
//  NSAttributedStringExtension.swift
//  Circle
//
//  Created by Felix Mo on 2015-09-09.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

extension NSAttributedString {
 
    // MARK: - Text Styles
    
    static func headerText(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont.headerTextFont(), NSKernAttributeName: 1.0])
    }
    
    static func mainText(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont.mainTextFont()])
    }
}
