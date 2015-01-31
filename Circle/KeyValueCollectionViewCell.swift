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
    @IBOutlet private(set) weak var valueLabelTrailingSpaceConstraint: NSLayoutConstraint!
    
    private var nameImageViewWidthConstraintInitialValue: CGFloat!
    
    override class var classReuseIdentifier: String {
        return "KeyValueCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Record initial constraint values
        nameImageViewWidthConstraintInitialValue = nameImageViewWidthConstraint.constant
    }

    override func setData(data: AnyObject) {
        if let keyValueDictionary = data as? [String: AnyObject] {
            nameLabel.text = keyValueDictionary["name"] as String!
            valueLabel.text = keyValueDictionary["value"] as String!
            
            if let imageSource = keyValueDictionary["image"] as String? {
                nameImageView.alpha = 1.0
                valueLabelTrailingSpaceConstraint.constant = 60.0
                nameImageView.image = UIImage(named: imageSource)?.imageWithRenderingMode(.AlwaysTemplate)
                nameImageView.tintColor = keyValueDictionary["imageTintColor"] as UIColor!
                if let imageSizeValue = keyValueDictionary["imageSize"] as NSValue? {
                    nameImageViewWidthConstraint.constant = imageSizeValue.CGSizeValue().width
                }
                else {
                    nameImageViewWidthConstraint.constant = nameImageViewWidthConstraintInitialValue
                }
                
                nameImageView.setNeedsUpdateConstraints()
                nameImageView.layoutIfNeeded()
            }
            else {
                nameImageView.alpha = 0.0
                valueLabelTrailingSpaceConstraint.constant = 15.0
            }
        }
    }
}
