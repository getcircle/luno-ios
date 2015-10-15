//
//  TextValueCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

protocol TextValueCollectionViewDelegate {
    func placeholderButtonTapped(type: TextData.TextDataType)
}

class TextValueCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var placeholderButton: UIButton?
    @IBOutlet weak private(set) var textLabel: UILabel!
    @IBOutlet weak private(set) var textLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var timestampLabel: UILabel?

    var delegate: TextValueCollectionViewDelegate?
    
    private var currentTextDataType: TextData.TextDataType?
    
    override class var classReuseIdentifier: String {
        return "TextValueCollectionViewCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = nil
        configureTextLabel()
        configureTimestampLabel()
        configurePlaceholderButton()
    }

    func configureTextLabel() {
        textLabel.textColor = UIColor.appPrimaryTextColor()
        textLabel.text = ""
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .ByWordWrapping
    }
    
    func configureTimestampLabel() {
        timestampLabel?.text = ""
        timestampLabel?.textColor = UIColor.appSecondaryTextColor()
        timestampLabel?.hidden = true
    }

    func configurePlaceholderButton() {
        placeholderButton?.setTitle("", forState: .Normal)
        placeholderButton?.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        placeholderButton?.hidden = true
    }
    
    override func intrinsicContentSize() -> CGSize {
        var height = textLabel.text == nil || textLabel.text?.trimWhitespace() ?? "" == "" ? 60.0 : textLabel.intrinsicContentSize().height
        height += textLabelTopConstraint.constant * 2
        height += timestampLabel?.hidden ?? true ? 0.0 : 30.0
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    override func setData(data: AnyObject) {
        let normalFont = UIFont.regularFont(textLabel.font.pointSize)
        let italicFont = UIFont.italicFont(textLabel.font.pointSize)

        if let textData = data as? TextData {
            currentTextDataType = textData.type
            
            if textData.value.trimWhitespace() != "" {
                placeholderButton?.hidden = true
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
                
                textLabel.text = text
                textLabel.font = font
                
                if let timestamp = TextData.getFormattedTimestamp(textData.updatedTimestamp, authorProfile: textData.authorProfile) {
                    timestampLabel?.text = timestamp
                    timestampLabel?.hidden = false
                }
                else {
                    timestampLabel?.hidden = true
                }
            }
            else if let placeholder = textData.placeholder {
                textLabel.textColor = UIColor.appSecondaryTextColor()
                textLabel.text = placeholder
                textLabel.font = normalFont
                
                if let canEdit = textData.canEdit where canEdit == false {
                    placeholderButton?.hidden = false
                    placeholderButton?.setTitle(placeholder, forState: .Normal)
                }
            }

            textLabel.setNeedsUpdateConstraints()
            textLabel.layoutIfNeeded()
            timestampLabel?.layoutIfNeeded()
            placeholderButton?.layoutIfNeeded()
        }
    }
    
    // MARK - IBActions
    
    @IBAction func placeholderButtonTapped(sender: AnyObject) {
        if let currentTextDataType = currentTextDataType {
            delegate?.placeholderButtonTapped(currentTextDataType)
        }
    }
}
