//
//  MessageReceivedCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MessageReceivedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageContents: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2.0
        self.profileImage.layer.masksToBounds = true
    }
    
    func setMessage(message: Message) {
        self.profileImage.setImageWithPerson(message.sender)
        self.messageContents.text = message.contents
    }
    
    class func reuseIdentifier() -> String {
        return "MessageReceived"
    }

}
