//
//  PostTitleCollectionViewCell.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-09.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostTitleCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var timestampLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "PostTitleCollectionViewCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = nil
    }

    override func intrinsicContentSize() -> CGSize {
        let height = titleLabel.intrinsicContentSize().height + timestampLabel.frameHeight
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    override func setData(data: AnyObject) {
        if let post = data as? Services.Post.Containers.PostV1 {
            titleLabel.text = post.title
            
            if let timestamp = TextData.getFormattedTimestamp(post.changed) {
                timestampLabel?.text = timestamp
            }
            
            titleLabel.setNeedsUpdateConstraints()
            titleLabel.layoutIfNeeded()
            timestampLabel?.layoutIfNeeded()
        }
    }

}
