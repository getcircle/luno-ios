//
//  ProfileAttributeCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileAttributeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    class var classReuseIdentifier: String {
        return "ProfileAttributeCell"
    }
}
