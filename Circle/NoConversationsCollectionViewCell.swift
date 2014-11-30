//
//  NoConversationsCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

protocol NoConversationsCellDelegate {
    func handleNewMessage(sender: AnyObject)
}

class NoConversationsCollectionViewCell: UICollectionViewCell {

    var delegate: NoConversationsCellDelegate?
    @IBOutlet weak var newMessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.newMessageButton.layer.cornerRadius = 5
        self.newMessageButton.layer.masksToBounds = true
    }

    @IBAction func handleNewMessage(sender: AnyObject) {
        self.delegate?.handleNewMessage(self)
    }
    
    class func reuseIdentifier() -> String {
        return "NoConversations"
    }
}
