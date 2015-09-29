//
//  SearchResultCollectionViewCell.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SearchResultCollectionViewCell: ProfileCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "SearchResultCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 60.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.makeItCircular()
        nameLabel.font = UIFont.regularFont(16.0)
        subTextLabel.font = UIFont.secondaryTextFont()
        nameLabel.textColor = UIColor.appPrimaryTextColor()
        subTextLabel.textColor = UIColor.appSecondaryTextColor()
    }
    
}