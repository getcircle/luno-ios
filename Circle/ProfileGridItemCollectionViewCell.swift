//
//  ProfileGridItemCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 5/22/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileGridItemCollectionViewCell: ProfileCollectionViewCell {

    let NUMBER_OF_COLUMNS: CGFloat = UI_USER_INTERFACE_IDIOM() == .Pad ? 3.0 : 2.0
    
    override class var interItemSpacing: CGFloat {
        return 10.0
    }
    
    override class var lineSpacing: CGFloat {
        return 20.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override class var classReuseIdentifier: String {
        return "ProfileGridItemCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        layer.cornerRadiusWithMaskToBounds(3.0)
        profileImageView.animateImageLoading = false
    }
    
    override func intrinsicContentSize() -> CGSize {
        profileImageView.layoutIfNeeded()
        nameLabel.layoutIfNeeded()
        subTextLabel.layoutIfNeeded()
        // subtract inter item space
        // 3.0 is to be able to fit three items
        let imageWidth: CGFloat = (ProfileCollectionViewCell.width - ((NUMBER_OF_COLUMNS + 1.0) * 10.0)) / NUMBER_OF_COLUMNS
        
        // 20.0 accounts for generic logic in card delegate that subtracts left and right insets from a width
        return CGSizeMake(imageWidth + 20.0, imageWidth + 40.0)
    }
}
