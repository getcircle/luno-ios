//
//  FormBuilder.swift
//  Circle
//
//  Created by Ravi Rani on 2/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class FormBuilder: NSObject, UITextFieldDelegate {
    
    enum FormFieldType {
        case TextField
        case LongTextField
        case Radio
        case Checkbox
        case Select
        case DatePicker
        case Photo
    }

    class SectionItem {
        var container: String
        var containerKey: String
        var input: AnyObject?
        var inputEnabled: Bool?
        var keyboardType: UIKeyboardType
        var placeholder: String
        var type: FormFieldType
        var value: String?
        
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
        
        let formFieldEdgeInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)
        var previousView = afterSubView
        
        for section in sections {
            
            // Section Container
            let sectionContainerView = UIView(forAutoLayout: ())
            sectionContainerView.opaque = true
            sectionContainerView.backgroundColor = UIColor.appViewBackgroundColor()
            parentView.addSubview(sectionContainerView)
            if let lastView = previousView {
                sectionContainerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: lastView, withOffset: formFieldEdgeInset.top)
                sectionContainerView.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                sectionContainerView.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
            }
            else {
                sectionContainerView.autoPinEdgesToSuperviewEdgesWithInsets(formFieldEdgeInset, excludingEdge: .Bottom)
            }
            sectionContainerView.autoSetDimension(.Height, toSize: 40.0)
            previousView = sectionContainerView
            
            // Section Title
            let sectionTitleLabel = UILabel(forAutoLayout: ())
            sectionTitleLabel.backgroundColor = UIColor.appViewBackgroundColor()
            sectionTitleLabel.textColor = UIColor.appSecondaryTextColor()
            sectionTitleLabel.attributedText = NSAttributedString.headerText(section.title.localizedUppercaseString())
            sectionContainerView.addSubview(sectionTitleLabel)
            sectionTitleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0), excludingEdge: .Top)
            sectionTitleLabel.autoSetDimension(.Height, toSize: 15.0)

            for item in section.items {

                switch item.type {
                
                case .TextField:
                    let containerView = UIView(forAutoLayout: ())
                    containerView.opaque = true
                    containerView.backgroundColor = UIColor.whiteColor()
                    parentView.addSubview(containerView)
                    containerView.autoPinEdgeToSuperviewEdge(.Left)
                    containerView.autoPinEdgeToSuperviewEdge(.Right)
                    containerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView!, withOffset: (previousView == sectionTitleLabel ? 5.0 : 1.0))
                    containerView.autoSetDimension(.Height, toSize: 60.0)
                    
                    let hasPlaceholder = (item.placeholder.characters.count > 0)
                    
                    var fieldNameLabel: UILabel?
                    if hasPlaceholder {
                        fieldNameLabel = UILabel(forAutoLayout: ())
                        fieldNameLabel?.opaque = true
                        fieldNameLabel?.backgroundColor = UIColor.whiteColor()
                        fieldNameLabel?.text = item.placeholder
                        fieldNameLabel?.font = UIFont.mainTextFont()
                        fieldNameLabel?.textColor = UIColor.appSecondaryTextColor()
                        containerView.addSubview(fieldNameLabel!)
                        fieldNameLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                        fieldNameLabel?.autoAlignAxisToSuperviewAxis(.Horizontal)
                    }
                    
                    let textField = UITextField(forAutoLayout: ())
                    textField.textColor = UIColor.appAttributeValueLabelColor()
                    textField.font = UIFont.mainTextFont()
                    textField.textAlignment = hasPlaceholder ? .Right : .Left
                    textField.keyboardType = item.keyboardType
                    // TODO: Make these configurable
                    // Not urgent since we are using the form builder for contact info
                    // only, to which the following settings are fine
                    textField.autocapitalizationType = .None
                    textField.autocorrectionType = .No
                    textField.spellCheckingType = .No
                    textField.delegate = self
                    if let inputEnabled = item.inputEnabled {
                        textField.enabled = inputEnabled
                        if !inputEnabled {
                            textField.textColor = UIColor.lightGrayColor()
                        }
                    }
                    containerView.addSubview(textField)
                    if fieldNameLabel == nil {
                        textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
                    }
                    else {
                        textField.autoPinEdge(.Left, toEdge: .Right, ofView: fieldNameLabel!, withOffset: 10.0)
                    }
                    textField.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
                    textField.autoAlignAxisToSuperviewAxis(.Horizontal)
                    textField.autoSetDimension(.Height, toSize: 40.0)

                    if let textValue = item.value {
                        textField.text = textValue
                    }

                    item.input = textField
                    previousView = containerView
                    break
                    
                case .DatePicker:
                    let containerView = UIView(forAutoLayout: ())
                    containerView.opaque = true
                    containerView.backgroundColor = UIColor.whiteColor()
                    parentView.addSubview(containerView)
                    containerView.autoPinEdgeToSuperviewEdge(.Left)
                    containerView.autoPinEdgeToSuperviewEdge(.Right)
                    containerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView!, withOffset: (previousView == sectionTitleLabel ? 5.0 : 1.0))
                    containerView.autoSetDimension(.Height, toSize: 60.0)
                    
                    let textField = UITextField(forAutoLayout: ())
                    textField.textColor = UIColor.appAttributeValueLabelColor()
                    textField.font = UIFont.mainTextFont()
                    textField.textAlignment = .Left
                    textField.keyboardType = item.keyboardType
                    // TODO: Make these configurable
                    // Not urgent since we are using the form builder for contact info
                    // only, to which the following settings are fine
                    textField.autocapitalizationType = .None
                    textField.autocorrectionType = .No
                    textField.spellCheckingType = .No
                    textField.delegate = self
                    if let inputEnabled = item.inputEnabled {
                        textField.enabled = inputEnabled
                        if !inputEnabled {
                            textField.textColor = UIColor.lightGrayColor()
                        }
                    }
                    let datePicker = UIDatePicker()
                    datePicker.datePickerMode = .Date
                    datePicker.maximumDate = NSDate()
                    datePicker.addTarget(self, action: "valueWasChangedOnDatePicker:", forControlEvents: .ValueChanged)
                    textField.inputView = datePicker
                    containerView.addSubview(textField)
                    textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
                    textField.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
                    textField.autoAlignAxisToSuperviewAxis(.Horizontal)
                    textField.autoSetDimension(.Height, toSize: 40.0)
                    
                    if let textValue = item.value {
                        textField.text = textValue
                        datePicker.date = textValue.toDate() ?? NSDate()
                    }
                    
                    item.input = textField
                    previousView = containerView
                    break
                    
                case .Photo:
                    let containerView = UIView(forAutoLayout: ())
                    containerView.opaque = true
                    containerView.backgroundColor = UIColor.whiteColor()
                    parentView.addSubview(containerView)
                    containerView.autoPinEdgeToSuperviewEdge(.Left)
                    containerView.autoPinEdgeToSuperviewEdge(.Right)
                    containerView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView!, withOffset: (previousView == sectionTitleLabel ? 5.0 : 1.0))
                    containerView.autoSetDimension(.Height, toSize: 60.0)
                    
                    let fieldNameLabel = UILabel(forAutoLayout: ())
                    fieldNameLabel.opaque = true
                    fieldNameLabel.backgroundColor = UIColor.whiteColor()
                    fieldNameLabel.text = item.placeholder
                    fieldNameLabel.font = UIFont.mainTextFont()
                    fieldNameLabel.textColor = UIColor.appSecondaryTextColor()
                    containerView.addSubview(fieldNameLabel)
                    fieldNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                    fieldNameLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
                    
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
    
    // MARK: - Date Picker
    
    @objc private func valueWasChangedOnDatePicker(datePicker: UIDatePicker) {
        updateValues()
    }
    
    // MARK: Data
    
    func updateValues() {
        
        for section in sections {
            
            for item in section.items {
                
                if let input: AnyObject = item.input {
                    switch item.type {
                    case .TextField:
                        item.value = (input as! UITextField).text
                        
                    case .DatePicker:
                        if let textField = input as? UITextField, let datePicker = input.inputView as? UIDatePicker {
                            item.value = NSDateFormatter.sharedHireDateFormatter.stringFromDate(datePicker.date)
                            textField.text = item.value
                        }
                        
                    default:
                        break
                    }
                }
            }
        }
    }
}

extension FormBuilder {
    class ContactSectionItem: SectionItem {
        var contactMethodType: Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1
        
        required init(placeholder withPlaceholder: String, type andType: FormFieldType, keyboardType andKeyboardType: UIKeyboardType, container andContainer: String, containerKey andContainerKey: String, contactMethodType andContactMethodType: Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1) {
            contactMethodType = andContactMethodType
            super.init(placeholder: withPlaceholder, type: andType, keyboardType: andKeyboardType, container: andContainer, containerKey: andContainerKey)
        }
        
        convenience init(placeholder withPlaceholder: String, type andType: FormFieldType, keyboardType andKeyboardType: UIKeyboardType, contactMethodType andContactMethodType: Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1) {
         
            self.init(placeholder: withPlaceholder, type: andType, keyboardType: andKeyboardType, container: "", containerKey: "", contactMethodType: andContactMethodType)
        }
    }
    
    class ProfileSectionItem: SectionItem {
        
        enum ProfileFieldType {
            case Photo
            case Title
            case HireDate
        }
        
        var fieldType: ProfileFieldType
        
        required init(placeholder withPlaceholder: String = "", type andType: FormFieldType, keyboardType andKeyboardType: UIKeyboardType = .Default, fieldType andFieldType: ProfileFieldType) {
            fieldType = andFieldType
            super.init(placeholder: withPlaceholder, type: andType, keyboardType: andKeyboardType, container: "", containerKey: "")
        }
    }
}
