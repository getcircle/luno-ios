//
//  ChatRoomHistoryTableViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ChatRoomHistoryTableViewCell: UITableViewCell {
    
    var chatRoom: ChatRoom? {
        didSet {
            self.profileImage.setImageWithProfileImageURL(chatRoom!.profileImageURL())
            self.messageContents.text = self.chatRoom!.lastMessage.contents
            self.recipientLabel.text = self.chatRoom!.description
            self.lastMessageDate.text = NSDateFormatter.shortStyleStringFromDate(self.chatRoom!.lastMessage.createdAt)
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    @IBOutlet weak var messageContents: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.makeItCircular(false)
    }
    
    class func reuseIdentifier() -> String {
        return "ConversationHistory"
    }

}
