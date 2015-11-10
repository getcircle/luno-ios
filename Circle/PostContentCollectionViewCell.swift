//
//  PostContentCollectionViewCell.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-09.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostContentCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet private var textView: UITextView!
    
    override class var classReuseIdentifier: String {
        return "PostContentCollectionViewCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = nil
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(self.dynamicType.width, textView.intrinsicContentSize().height)
    }
    
    override func setData(data: AnyObject) {
        if let post = data as? Services.Post.Containers.PostV1 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.0
            let attributes = [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSForegroundColorAttributeName: UIColor.appPrimaryTextColor(),
                NSFontAttributeName: UIFont.mainTextFont(),
            ]
            let attributedString = NSAttributedString(string: post.content, attributes: attributes)
            textView.attributedText = attributedString
            textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.appHighlightColor()]
        }
    }
}
