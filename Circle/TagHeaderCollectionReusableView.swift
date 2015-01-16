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
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        // Initialization code
        tagNameLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        tagNameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        tagNameLabel.layer.borderWidth = 0.5
        
        var gradientView = addGradientView()
        let startColor = UIColor.blackColor().colorWithAlphaComponent(0.5).CGColor
        let endColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        if let gradientLayer = gradientView.layer as? CAGradientLayer {
            gradientLayer.colors = [startColor, endColor, startColor]
            gradientLayer.locations = [NSNumber(double: 0.0), NSNumber(double: 0.5), NSNumber(double: 1.0)]
        }
    }
}
