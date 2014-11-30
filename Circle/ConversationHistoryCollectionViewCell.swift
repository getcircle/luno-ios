//
//  ConversationHistoryCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ConversationHistoryCollectionViewCell: UICollectionViewCell {
    
    var history: ConversationHistory? {
        didSet {
            self.profileImage.setImageWithPerson(self.history!.sender)
            self.messageContents.text = self.history!.message.contents
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageContents: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2.0
        self.profileImage.layer.masksToBounds = true
    }
    
    class func reuseIdentifier() -> String {
        return "ConversationHistory"
    }

}
