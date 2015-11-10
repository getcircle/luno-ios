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
        let width = self.dynamicType.width
        // Subtract 20px to accommodate for default section inset
        let height = textView.sizeThatFits(CGSizeMake(width - 20, CGFloat.max)).height
        return CGSizeMake(width, height)
    }
    
    override func setData(data: AnyObject) {
        if let content = data as? NSAttributedString {
            textView.attributedText = content
            textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.appHighlightColor()]
            textView.layoutIfNeeded()
            textView.setNeedsUpdateConstraints()
        }
    }
    
}
