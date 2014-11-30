//
//  MessageActions.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Foundation

class MessageActions {
    
    class func sendMessage(sender: Person, recipient: Person, contents: String) -> Message {
        let message = Message()
        message["contents"] = contents
        message["sender"] = sender
        message["recipients"] = [recipient]
        message.saveInBackgroundWithBlock(nil)
        return message
    }
    
}