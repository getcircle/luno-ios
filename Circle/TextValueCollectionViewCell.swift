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
    @IBOutlet weak private(set) var textView: UITextView!
    @IBOutlet weak private(set) var textViewTopConstraint: NSLayoutConstraint! {
        didSet {
            textViewTopMargin = textViewTopConstraint.constant
        }
    }
    @IBOutlet weak private(set) var timestampLabel: UILabel?

    var delegate: TextValueCollectionViewDelegate?
    
    private var currentTextDataType: TextData.TextDataType?
    private var textViewTopMargin = CGFloat(0.0)
    
    override class var classReuseIdentifier: String {
        return "TextValueCollectionViewCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = nil
        configureTextView()
        configureTimestampLabel()
        configurePlaceholderButton()
    }

    func configureEditButton() {
        editTextButton?.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        editTextButton?.setTitle(AppStrings.GenericCancelButtonTitle.localizedUppercaseString(), forState: .Normal)
        editTextButton?.hidden = true
    }
    
    func configureTextView() {
        textView.textColor = UIColor.appPrimaryTextColor()
        textView.font = UIFont.mainTextFont()
        textView.text = ""
        textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.appHighlightColor()]
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
        var height = textView.text == nil || textView.text?.trimWhitespace() ?? "" == "" ? 60.0 : textView.intrinsicContentSize().height
        height += textViewTopMargin * 2
        height += timestampLabel?.hidden ?? true ? 0.0 : 30.0
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    private func resetViews() {
        textView.textColor = UIColor.appPrimaryTextColor()        
        textView.font = UIFont.mainTextFont()
        editTextButton?.hidden = true
        placeholderButton?.hidden = true
        timestampLabel?.hidden = true
    }
    
    override func setData(data: AnyObject) {
        resetViews()
        
        let italicFont = UIFont.italicFont(textView.font?.pointSize ?? 14.0)
        if let textData = data as? TextData {
            currentTextDataType = textData.type
            
            if textData.value.trimWhitespace() != "" {

                // Add text and handle quoting
                var text: String = textData.value
                if textData.type != .PostContent {
                    if textData.type == .TeamStatus || textData.type == .ProfileStatus {
                        text = "\"" + textData.value + "\""
                        textView.font = italicFont
                    }
                    textView.text = text
                    textView.selectable = false
                }
                else {
                    textViewTopConstraint.constant = 0
                    textView.dataDetectorTypes = [.PhoneNumber, .Link]
                    if let font = textView.font, textColor = textView.textColor {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 1.0
                        let attributes = [
                            NSParagraphStyleAttributeName: paragraphStyle,
                            NSFontAttributeName: font,
                            NSForegroundColorAttributeName: textColor,
                        ]
                        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
                    }
                }
                
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
                textView.textColor = UIColor.appSecondaryTextColor()
                textView.text = placeholder
                
                // Else show button to nudge user
                if let canEdit = textData.canEdit where canEdit == false {
                    placeholderButton?.hidden = false
                    placeholderButton?.setTitle(placeholder, forState: .Normal)
                }
            }

            // Resize as per new content
            textView.setNeedsUpdateConstraints()
            textView.layoutIfNeeded()
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
