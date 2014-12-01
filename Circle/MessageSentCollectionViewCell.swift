//
//  MessageSentCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MessageSentCollectionViewCell: UICollectionViewCell {
    
    class var classReuseIdentifier: String {
        return "MessageSentCollectionViewCell"
    }
    
    @IBOutlet weak var contentsLabel: UILabel!
    
    var message: Message? {
        didSet {
            contentsLabel.text = message!.contents
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentsLabel.layer.cornerRadiusWithMaskToBounds(5.0)
    }

}
