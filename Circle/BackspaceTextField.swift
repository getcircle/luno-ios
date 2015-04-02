//
//  BackspaceTextField.swift
//  Circle
//
//  Created by Michael Hahn on 4/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

@objc protocol BackspaceTextFieldDelegate: UITextFieldDelegate {
    func textFieldDidEnterBackspace(textField: BackspaceTextField)
    
    optional func textFieldDidChangeText(text: String)
    optional func textField(textField: BackspaceTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)
    optional func textFieldDidBeginEditing(textField: BackspaceTextField)
    optional func textFieldDidEndEditing(textField: BackspaceTextField)
    optional func textFieldShouldBeginEditing(textField: BackspaceTextField) -> Bool
    optional func textFieldShouldReturn(textField: BackspaceTextField) -> Bool
}

class BackspaceTextField: UIView, UITextFieldDelegate {
    
    var delegate: BackspaceTextFieldDelegate?
    private var textField: UITextField!
    
    override init() {
        super.init()
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        textField = UITextField.newAutoLayoutView()
        textField.delegate = self
        textField.text = " "
        textField.autocorrectionType = .No
        textField.spellCheckingType = .No
        textField.addTarget(self, action: "textFieldChanged:", forControlEvents: .EditingChanged)
        addSubview(textField)
        textField.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - Simulate UITextField
    
    var text: String {
        get {
            var result = textField.text
            result.removeAtIndex(result.startIndex)
            return result
        }
        set {
            textField.text = " \(newValue)"
        }
    }
    
    func addTarget(target: AnyObject?, action: Selector, forControlEvents: UIControlEvents) {
        textField.addTarget(target, action: action, forControlEvents: forControlEvents)
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func isFirstResponder() -> Bool {
        return textField.isFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length == 1 && range.location == 0 && string == "" {
            delegate?.textFieldDidEnterBackspace(self)
            return false
        }
        return delegate?.textField?(textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldDidEndEditing?(self)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing?(self) ?? true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn?(self) ?? true
    }
    
    // MARK: - Targets
    
    func textFieldChanged(textField: UITextField) {
        delegate?.textFieldDidChangeText?(text)
    }

    override func intrinsicContentSize() -> CGSize {
        return textField.intrinsicContentSize()
    }
}
