//
//  MessageReceivedCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MessageReceivedCollectionViewCell: UICollectionViewCell {
    
    class var classReuseIdentifier: String {
        return "MessageReceivedCollectionViewCell"
    }
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    var message: Message? {
        didSet {
            contentsLabel.text = message?.contents
            profileImageView.setImageWithPerson(message?.sender)
            profileImageView.makeItCircular(false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        contentsLabel.layer.cornerRadiusWithMaskToBounds(5.0)
    }

}
