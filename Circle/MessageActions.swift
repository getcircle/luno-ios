//
//  MessageActions.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Foundation

class MessageActions {
    
    class func sendMessage(chatRoom: ChatRoom, contents: String) -> Message {
        let message = Message()
        message["contents"] = contents
        message["sender"] = AuthViewController.getLoggedInPerson()
        message["chatRoom"] = chatRoom
        message.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                ChatRoom.recordMessage(message)
            }
        }
        return message
    }
    
}