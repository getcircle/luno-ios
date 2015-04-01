//
//  KeyValueCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class KeyValueCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet private(set) weak var nameImageView: UIImageView!
    @IBOutlet private(set) weak var nameImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var valueLabel: UILabel!
    
    private var nameImageViewWidthConstraintInitialValue: CGFloat!
    
    override class var classReuseIdentifier: String {
        return "KeyValueCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 60.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Record initial constraint values
        nameImageViewWidthConstraintInitialValue = nameImageViewWidthConstraint.constant
        nameLabel.font = UIFont.appAttributeTitleLabelFont()
        nameLabel.textColor = UIColor.appAttributeTitleLabelColor()

        valueLabel.textAlignment = .Right
        valueLabel.font = UIFont.appAttributeValueLabelFont()
        valueLabel.textColor = UIColor.appAttributeValueLabelColor()
    }

    override func setData(data: AnyObject) {
        if let keyValueDictionary = data as? [String: AnyObject] {
            nameLabel.text = (keyValueDictionary["name"] as String!).uppercaseString
            valueLabel.text = keyValueDictionary["value"] as String!
            
            if let imageSource = keyValueDictionary["image"] as String? {
                nameImageView.alpha = 1.0
                nameImageView.image = UIImage(named: imageSource)?.imageWithRenderingMode(.AlwaysTemplate)
                nameImageView.tintColor = keyValueDictionary["imageTintColor"] as UIColor!
                if let imageSizeValue = keyValueDictionary["imageSize"] as NSValue? {
                    nameImageViewWidthConstraint.constant = imageSizeValue.CGSizeValue().width
                }
                else {
                    nameImageViewWidthConstraint.constant = nameImageViewWidthConstraintInitialValue
                }
            }
            else {
                nameImageViewWidthConstraint.constant = 0.0
                nameImageView.alpha = 0.0
            }

            nameImageView.setNeedsUpdateConstraints()
            nameImageView.layoutIfNeeded()
        }
    }
}
