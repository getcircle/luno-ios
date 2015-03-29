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
        var container: String
        var containerKey: String
        var input: AnyObject?
        var keyboardType: UIKeyboardType
        var placeholder: String
        var type: FormFieldType
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
            sectionTitleLabel.backgroundColor = UIColor.appViewBackgroundColor()
            sectionTitleLabel.text = section.title.uppercaseStringWithLocale(NSLocale.currentLocale())
            sectionTitleLabel.font = UIFont.appAttributeTitleLabelFont()
            sectionTitleLabel.textColor = UIColor.appAttributeTitleLabelColor()
            parentView.addSubview(sectionTitleLabel)
            if let lastView = previousView {
                sectionTitleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: lastView, withOffset: 25.0)
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
                    let containerView = UIView(forAutoLayout: ())
                    containerView.opaque = true
                    containerView.backgroundColor = UIColor.whiteColor()
                    parentView.addSubview(containerView)
                    containerView.autoPinEdgeToSuperviewEdge(.Left)
                    containerView.autoPinEdgeToSuperviewEdge(.Right)
                    containerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView!, withOffset: (previousView == sectionTitleLabel ? 10.0 : 1.0))
                    containerView.autoSetDimension(.Height, toSize: 60.0)
                    
                    let fieldNameLabel = UILabel(forAutoLayout: ())
                    fieldNameLabel.opaque = true
                    fieldNameLabel.backgroundColor = UIColor.whiteColor()
                    fieldNameLabel.text = item.placeholder.uppercaseStringWithLocale(NSLocale.currentLocale())
                    fieldNameLabel.font = UIFont.appAttributeTitleLabelFont()
                    fieldNameLabel.textColor = UIColor.appAttributeTitleLabelColor()
                    containerView.addSubview(fieldNameLabel)
                    fieldNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                    fieldNameLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
                    
                    let textField = UITextField(forAutoLayout: ())
                    textField.textColor = UIColor.appAttributeValueLabelColor()
                    textField.font = UIFont.appAttributeValueLabelFont()
                    textField.clearButtonMode = .WhileEditing
                    textField.textAlignment = .Right
                    textField.keyboardType = item.keyboardType
                    textField.delegate = self
                    containerView.addSubview(textField)
                    textField.autoPinEdge(.Left, toEdge: .Right, ofView: fieldNameLabel, withOffset: 10.0)
                    textField.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
                    textField.autoAlignAxisToSuperviewAxis(.Horizontal)
                    textField.autoSetDimension(.Height, toSize: 40.0)

                    if let textValue = item.value as? String {
                        textField.text = textValue
                    }

                    item.input = textField
                    previousView = containerView
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
        textFieldEditingComplete(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldEditingComplete(textField)
        return true
    }
    
    private func textFieldEditingComplete(textField: UITextField) {
        activeField = nil
        updateValues()
    }
    
    
    // MARK: Data
    
    func updateValues() {
        
        for section in sections {
            
            for item in section.items {
                
                if let input: AnyObject = item.input {
                    switch item.type {
                    case .TextField:
                        item.value = (input as UITextField).text
                        println(item.value)

                    default:
                        break
                    }
                }
            }
        }
    }
}
