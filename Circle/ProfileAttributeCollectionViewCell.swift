//
//  ProfileAttributeCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileAttributeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var valueLabel: UILabel!
    @IBOutlet private(set) weak var nameImageView: UIImageView!
    @IBOutlet weak var valueLabelTrailingSpaceConstraint: NSLayoutConstraint!
    
    class var classReuseIdentifier: String {
        return "ProfileAttributeCell"
    }
}
