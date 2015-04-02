//
//  BackspaceTextField.swift
//  Circle
//
//  Created by Michael Hahn on 4/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

@objc protocol BackspaceTextFieldDelegate: UITextFieldDelegate {
    func textFieldDidEnterBackspace(textField: UITextField)
    optional func textFieldDidChangeText(text: String)
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
            delegate?.textFieldDidEnterBackspace(textField)
            return false
        }
        return delegate?.textField?(textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    // MARK: - Targets
    
    func textFieldChanged(textField: UITextField) {
        delegate?.textFieldDidChangeText?(text)
    }

    override func intrinsicContentSize() -> CGSize {
        return textField.intrinsicContentSize()
    }
}
