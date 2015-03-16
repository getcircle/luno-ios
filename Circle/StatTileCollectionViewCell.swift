//
//  StatTileCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 3/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class StatTileCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var countLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    
    override class var sizeIncludesInsets: Bool {
        return true
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override class var interItemSpacing: CGFloat {
        return 10.0
    }
    
    override class var lineSpacing: CGFloat {
        return 10.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countLabel.textColor = UIColor.appTintColor()
        titleLabel.textColor = UIColor.appSecondaryTextColor()
    }
    
    override func setData(data: AnyObject) {
        if let stats = data as? [String: AnyObject] {
            titleLabel.text = data["title"] as String!
            countLabel.text = String(data["value"] as Int!)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        // account for padding of 10
        let width = UIScreen.mainScreen().bounds.width/2 - 15.0
        return CGSizeMake(width, width)
    }

}