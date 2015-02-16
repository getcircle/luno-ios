//
//  TextValueCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class TextValueCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelBottomConstraint: NSLayoutConstraint!
    
    override class var classReuseIdentifier: String {
        return "TextValueCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func intrinsicContentSize() -> CGSize {
        var height = textLabel.intrinsicContentSize().height
        height += textLabelTopConstraint.constant
        height += textLabelBottomConstraint.constant
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    override func setData(data: AnyObject) {
        if let value = data as? String {
            textLabel.text = value
        }
    }

}
