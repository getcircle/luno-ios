//
//  FormBuilder.swift
//  Circle
//
//  Created by Ravi Rani on 2/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

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
        var imageSource: String
        var items: [SectionItem]
    }
    
    private(set) var activeField: UIView?
    var sections = [Section]()

    func build(parentView: UIView, afterSubView: UIView? = nil) {
        
        let formFieldEdgeInset = UIEdgeInsetsMake(25.0, 15.0, 0.0, 15.0)
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
            sectionContainerView.autoSetDimension(.Height, toSize: 44.0)
            previousView = sectionContainerView
            
            // Section Image
            let sectionImageView = UIImageView(forAutoLayout: ())
            sectionImageView.image = UIImage(named: section.imageSource)
            sectionContainerView.addSubview(sectionImageView)
            sectionImageView.autoPinEdgeToSuperviewEdge(.Left)
            sectionImageView.autoAlignAxisToSuperviewAxis(.Horizontal)
            sectionImageView.autoSetDimensionsToSize(sectionImageView.image!.size)
            
            // Section Title
            let sectionTitleLabel = UILabel(forAutoLayout: ())
            sectionTitleLabel.backgroundColor = UIColor.appViewBackgroundColor()
            sectionTitleLabel.text = section.title.localizedUppercaseString()
            sectionTitleLabel.font = UIFont.appAttributeTitleLabelFont()
            sectionTitleLabel.textColor = UIColor.appAttributeTitleLabelColor()
            sectionContainerView.addSubview(sectionTitleLabel)
            sectionTitleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: sectionImageView, withOffset: 10.0)
            sectionTitleLabel.autoPinEdgeToSuperviewEdge(.Right)
            sectionTitleLabel.autoAlignAxisToSuperviewAxis(.Horizontal)

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
                    fieldNameLabel.text = item.placeholder.localizedUppercaseString()
                    fieldNameLabel.font = UIFont.appAttributeTitleLabelFont()
                    fieldNameLabel.textColor = UIColor.appAttributeTitleLabelColor()
                    containerView.addSubview(fieldNameLabel)
                    fieldNameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: formFieldEdgeInset.left)
                    fieldNameLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
                    
                    let textField = UITextField(forAutoLayout: ())
                    textField.textColor = UIColor.appAttributeValueLabelColor()
                    textField.font = UIFont.appAttributeValueLabelFont()
                    textField.textAlignment = .Right
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
                    textField.autoPinEdge(.Left, toEdge: .Right, ofView: fieldNameLabel, withOffset: 10.0)
                    textField.autoPinEdgeToSuperviewEdge(.Right, withInset: formFieldEdgeInset.right)
                    textField.autoAlignAxisToSuperviewAxis(.Horizontal)
                    textField.autoSetDimension(.Height, toSize: 40.0)

                    if let textValue = item.value {
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
        var contactMethodType: ProfileService.ContactMethodType
        
        required init(placeholder withPlaceholder: String, type andType: FormFieldType, keyboardType andKeyboardType: UIKeyboardType, container andContainer: String, containerKey andContainerKey: String, contactMethodType andContactMethodType: ProfileService.ContactMethodType) {
            contactMethodType = andContactMethodType
            super.init(placeholder: withPlaceholder, type: andType, keyboardType: andKeyboardType, container: andContainer, containerKey: andContainerKey)
        }
        
        convenience init(placeholder withPlaceholder: String, type andType: FormFieldType, keyboardType andKeyboardType: UIKeyboardType, contactMethodType andContactMethodType: ProfileService.ContactMethodType) {
         
            self.init(placeholder: withPlaceholder, type: andType, keyboardType: andKeyboardType, container: "", containerKey: "", contactMethodType: andContactMethodType)
        }
    }
}
