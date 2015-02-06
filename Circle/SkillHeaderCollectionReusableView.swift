//
//  SkillHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SkillHeaderCollectionReusableView: CircleCollectionReusableView {

    override class var classReuseIdentifier: String {
        return "SkillHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var skillNameLabel: PaddedLabel!
    @IBOutlet weak private(set) var skillNameLabelCenterYConstraint: NSLayoutConstraint!
    
    private(set) var skillLabelInitialFontSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        // Initialization code
        skillNameLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        skillNameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        skillNameLabel.layer.borderWidth = 0.5
        skillLabelInitialFontSize = skillNameLabel.font.pointSize
    }
}
