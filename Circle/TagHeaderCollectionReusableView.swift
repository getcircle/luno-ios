//
//  TagHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagHeaderCollectionReusableView: CircleCollectionReusableView {

    override class var classReuseIdentifier: String {
        return "TagHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var interestNameLabel: PaddedLabel!
    @IBOutlet weak private(set) var interestNameLabelCenterYConstraint: NSLayoutConstraint!
    
    private(set) var interestLabelInitialFontSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        // Initialization code
        interestNameLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        interestNameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        interestNameLabel.layer.borderWidth = 0.5
        interestLabelInitialFontSize = interestNameLabel.font.pointSize
    }
    
    func setTag(interest: ProfileService.Containers.Tag) {
        interestNameLabel.attributedText = NSAttributedString(
            string: interest.name.uppercaseString,
            attributes: [NSKernAttributeName: 2.0]
        )
    }
}
