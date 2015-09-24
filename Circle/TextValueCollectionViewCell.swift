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
        let normalFont = UIFont.regularFont(textLabel.font.pointSize)
        let italicFont = UIFont.italicFont(textLabel.font.pointSize)

        if let textData = data as? TextData {
            if textData.value.trimWhitespace() != "" {
                let text: String
                let font: UIFont

                if textData.type == .TeamStatus || textData.type == .ProfileStatus {
                    text = "\"" + textData.value + "\""
                    font = italicFont
                }
                else {
                    text = textData.value
                    font = normalFont
                }
                
                let attributedText = NSMutableAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.appPrimaryTextColor(), NSFontAttributeName: font])
                
                if let timestamp = textData.getFormattedTimestamp() {
                    let attributedTimestamp = NSAttributedString(string: "  \(timestamp)", attributes: [NSForegroundColorAttributeName: UIColor.appSecondaryTextColor(), NSFontAttributeName: UIFont.regularFont(10.0)])
                    attributedText.appendAttributedString(attributedTimestamp)
                }
                
                textLabel.attributedText = attributedText
            }
            else if let placeholder = textData.placeholder {
                textLabel.textColor = UIColor.appSecondaryTextColor()
                textLabel.text = placeholder
                textLabel.font = normalFont
            }

            textLabel.setNeedsUpdateConstraints()
            textLabel.layoutIfNeeded()
        }
    }
}
