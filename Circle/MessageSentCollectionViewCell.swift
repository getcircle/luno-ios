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
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    
    var message: Message? {
        didSet {
            contentsLabel.text = message!.contents
            timeStampLabel.text = NSDateFormatter.shortStyleStringFromDate(message!.date)
            readLabel.hidden = !message!.hasBeenReadByAll()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentsLabel.layer.cornerRadiusWithMaskToBounds(5.0)
        readLabel.hidden = true
    }

}
