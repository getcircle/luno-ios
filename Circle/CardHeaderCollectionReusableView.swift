//
//  CardHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class CardHeaderCollectionReusableView: UICollectionReusableView {

    class var classReuseIdentifier: String {
        return "CardSectionHeaderView"
    }
    
    class var height: CGFloat {
        return 44.0
    }
    
    @IBOutlet weak private(set) var cardContentCountLabel: UILabel!
    @IBOutlet weak private(set) var cardImageView: UIImageView!
    @IBOutlet weak private(set) var cardParentView: UIView!
    @IBOutlet weak private(set) var cardTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
