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
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var valueLabel: UILabel!
    @IBOutlet private(set) weak var valueLabelTrailingSpaceConstraint: NSLayoutConstraint!
    
    override class var classReuseIdentifier: String {
        return "KeyValueCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Collection view does some trickery and removes constraints from
        // background views. So, we have to add it again in code
        selectedBackgroundView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
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
            }
            else {
                nameImageView.alpha = 0.0
                valueLabelTrailingSpaceConstraint.constant = 15.0
            }
        }
    }
}
