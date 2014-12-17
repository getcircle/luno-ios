//
//  MessageReceivedCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class MessageReceivedCollectionViewCell: UICollectionViewCell {
    
    class var classReuseIdentifier: String {
        return "MessageReceivedCollectionViewCell"
    }
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!

    var message: Message? {
        didSet {
            contentsLabel.text = message?.contents
            profileImageView.setImageWithPerson(message?.sender)
            profileImageView.makeItCircular(false)
            timeStampLabel.text = NSDateFormatter.shortStyleStringFromDate(message!.createdAt)
            readLabel.hidden = !message!.currentUserHasRead()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        contentsLabel.layer.cornerRadiusWithMaskToBounds(5.0)
        readLabel.hidden = true
    }

}
