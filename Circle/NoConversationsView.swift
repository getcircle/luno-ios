//
//  NoConversationsView.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

protocol NoConversationsViewDelegate {
    func handleNewMessage(sender: AnyObject)
}

class NoConversationsView: UIView {

    var delegate: NoConversationsViewDelegate?
    @IBOutlet weak var newMessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newMessageButton.addRoundCorners()
    }

    @IBAction func handleNewMessage(sender: AnyObject) {
        delegate?.handleNewMessage(self)
    }
}
