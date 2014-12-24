//
//  SearchViewCardCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchViewCardCollectionViewCell: UICollectionViewCell {

    class var classReuseIdentifier: String {
        return "SearchCardCollectionViewCell"
    }
    
    @IBOutlet weak private(set) var containerView: UIView!
    @IBOutlet weak private(set) var userImage: UIImageView!
    @IBOutlet weak private(set) var userImage1: UIImageView!
    @IBOutlet weak private(set) var userImage2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code

        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3).CGColor
        containerView.layer.shadowOffset = CGSizeMake(-1.0, -1.0)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.masksToBounds = false
        
        userImage.makeItCircular(false)
        userImage1.makeItCircular(false)
        userImage2.makeItCircular(false)
    }
}
