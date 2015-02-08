//
//  FormBuilder.swift
//  Circle
//
//  Created by Ravi Rani on 2/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class FormBuilder: NSObject, UITextFieldDelegate {
    
    enum FormFieldType {
        case TextField
        case LongTextField
        case Radio
        case Checkbox
        case Select
        case DatePicker
    }
    
    class SectionItem {
        var placeholder: String
        var type: FormFieldType
        var keyboardType: UIKeyboardType
        var container: String
        var containerKey: String
        var value: Any?
        
        init(placeholder withPlaceholder: String, type andType: FormFieldType, keyboardType andKeyboardType: UIKeyboardType, container andContainer: String, containerKey andContainerKey: String) {
            placeholder = withPlaceholder
            type = andType
            keyboardType = andKeyboardType
            container = andContainer
            containerKey = andContainerKey
        }
    }
    
    struct Section {
        var title: String
        var items: [SectionItem]
    }
    
    private(set) var activeField: UIView?
    var sections = [Section]()

    func build(parentView: UIView, afterSubView: UIView? = nil) {
        
        let formFieldEdgeInset = UIEdgeInsetsMake(40.0, 15.0, 0.0, 15.0)
        var previousView = afterSubView
        
        for section in sections {
            
            // Section title
            let sectionTitleLabel = UILabel(forAutoLayout: ())
            sectionTitleLabel.backgroundColor = UIColor.viewBackgroundColor()
            sectionTitleLabel.text = section.title
            sectionTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 15.0)
            sectionTitleLabel.textColor = UIColor.defaultDarkTextColor()
            parentView.addSubview(sectionTitleLabel)
            if let lastView = previousView {
                sectionTitleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: lastView, withOffset: formFieldEdgeInset.top)
                sectionTitleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                sectionTitleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
            }
            else {
                sectionTitleLabel.autoPinEdgesToSuperviewEdgesWithInsets(formFieldEdgeInset, excludingEdge: .Bottom)
            }
            previousView = sectionTitleLabel

            for item in section.items {

                switch item.type {
                
                case .TextField:
                    let textField = CircleTextField(forAutoLayout: ())
                    textField.textColor = UIColor.defaultDarkTextColor()
                    textField.placeholder = item.placeholder
                    textField.clearButtonMode = .WhileEditing
                    textField.keyboardType = item.keyboardType
                    textField.delegate = self
                    textField.placeholderColor = UIColor.lightGrayColor()
                    textField.font = UIFont(name: "Avenir-Light", size: 17.0)
                    parentView.addSubview(textField)
                    textField.addBottomBorder(offset: 0.0)
                    textField.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                    textField.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
                    textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView!, withOffset: 10.0)
                    textField.autoSetDimension(.Height, toSize: 30.0)
                    if let textValue = item.value as? String {
                        textField.text = textValue
                    }

                    previousView = textField
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
}