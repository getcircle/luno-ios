//
//  TagHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class TagHeaderCollectionReusableView: CircleCollectionReusableView {

    override class var classReuseIdentifier: String {
        return "TagHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var tagNameLabel: PaddedLabel!
    @IBOutlet weak private(set) var tagNameLabelCenterYConstraint: NSLayoutConstraint!
    
    private(set) var tagLabelInitialFontSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        // Initialization code
        tagNameLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        tagNameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        tagNameLabel.layer.borderWidth = 0.5
        tagLabelInitialFontSize = tagNameLabel.font.pointSize
    }
}
