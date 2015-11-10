//
//  SearchTextValueCollectionViewCell.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-29.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

class SearchTextValueCollectionViewCell: TextValueCollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!

    override class var classReuseIdentifier: String {
        return "SearchTextValueCollectionViewCell"
    }
    
    override func intrinsicContentSize() -> CGSize {
        var height = titleLabel.intrinsicContentSize().height
        height += textLabel.intrinsicContentSize().height
        height += textLabelTopConstraint.constant * 2
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    override func setData(data: AnyObject) {
        super.setData(data)
        
        if let title = card?.title {
            titleLabel.attributedText = NSAttributedString.headerText(title)
        }
    }
}
