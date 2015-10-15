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
    func editTextButtonTapped(type: TextData.TextDataType)
}

class TextValueCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var editTextButton: UIButton?
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

    func configureEditButton() {
        editTextButton?.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        editTextButton?.setTitle(AppStrings.GenericCancelButtonTitle.localizedUppercaseString(), forState: .Normal)
        editTextButton?.hidden = true
    }
    
    func configureTextLabel() {
        textLabel.textColor = UIColor.appPrimaryTextColor()
        textLabel.font = UIFont.regularFont(textLabel.font.pointSize)
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
    
    private func resetViews() {
        textLabel.font = UIFont.regularFont(textLabel.font.pointSize)
        editTextButton?.hidden = true
        placeholderButton?.hidden = true
        timestampLabel?.hidden = true
    }
    
    override func setData(data: AnyObject) {
        resetViews()
        
        let italicFont = UIFont.italicFont(textLabel.font.pointSize)
        if let textData = data as? TextData {
            currentTextDataType = textData.type
            
            if textData.value.trimWhitespace() != "" {

                // Add text and handle quoting
                var text: String = textData.value
                if textData.type == .TeamStatus || textData.type == .ProfileStatus {
                    text = "\"" + textData.value + "\""
                    textLabel.font = italicFont
                }
                
                textLabel.text = text
                
                // Add timestamp if present
                if let timestamp = TextData.getFormattedTimestamp(
                    textData.updatedTimestamp,
                    authorProfile: textData.authorProfile)
                {
                    timestampLabel?.text = timestamp
                    timestampLabel?.hidden = false
                    
                    if let canEdit = textData.canEdit where canEdit == true {
                        editTextButton?.hidden = false
                    }
                }
            }
            else if let placeholder = textData.placeholder {

                // Show placeholder (read-only) if user can edit
                textLabel.textColor = UIColor.appSecondaryTextColor()
                textLabel.text = placeholder
                
                // Else show button to nudge user
                if let canEdit = textData.canEdit where canEdit == false {
                    placeholderButton?.hidden = false
                    placeholderButton?.setTitle(placeholder, forState: .Normal)
                }
            }

            // Resize as per new content
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
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        if let currentTextDataType = currentTextDataType {
            delegate?.editTextButtonTapped(currentTextDataType)
        }
    }
}
