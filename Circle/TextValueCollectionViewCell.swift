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
        return "TextValueCollectionViewCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = nil
        textLabel.text = ""
    }

    override func intrinsicContentSize() -> CGSize {
        var height = textLabel.intrinsicContentSize().height
        height += textLabelTopConstraint.constant
        height += textLabelBottomConstraint.constant
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    override func setData(data: AnyObject) {
        if let textData = data as? TextData {
            if textData.value.trimWhitespace() != "" {
                textLabel.text = "\"" + textData.value + "\""
            }
        }
    }

}
