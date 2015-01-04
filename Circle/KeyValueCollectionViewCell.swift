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
}
