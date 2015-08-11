//
//  TextValueCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class TextValueCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var textLabel: UILabel!
    @IBOutlet weak private(set) var textLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var textLabelBottomConstraint: NSLayoutConstraint!
    
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
        let normalFont = UIFont(name: "Avenir-Roman", size: textLabel.font.pointSize)
        let obliqueFont = UIFont(name: "Avenir-Oblique", size: textLabel.font.pointSize)
        if let textData = data as? TextData {
            if textData.value.trimWhitespace() != "" {
                if textData.type == .TeamStatus || textData.type == .ProfileStatus {
                    textLabel.text = "\"" + textData.value + "\""
                    textLabel.font = obliqueFont
                }
                else {
                    textLabel.text = textData.value
                    textLabel.font = normalFont
                }
            }
            else if let placeholder = textData.placeholder {
                textLabel.text = placeholder
                textLabel.font = normalFont
            }
        }
    }
}
