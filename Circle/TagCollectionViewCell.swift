//
//  TagCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private(set) var tagLabel: PaddedLabel!

    class var classReuseIdentifier: String {
        return "TagCollectionViewCell"
    }
    
    class var height: CGFloat {
        return 30.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        tagLabel.layer.borderColor = UIColor.grayColor().CGColor
        tagLabel.layer.borderWidth = 1.0
        tagLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return tagLabel.intrinsicContentSize()
    }
}
