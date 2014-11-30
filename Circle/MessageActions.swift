//
//  MessageActions.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Foundation

class MessageActions {
    
    class func sendMessage(recipient: Person, contents: String) -> Message {
        let message = Message()
        message["contents"] = contents
        message["sender"] = AuthViewController.getLoggedInPerson()
        message["recipient"] = recipient
        message.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                ConversationHistory.recordMessage(message)
            }
        }
        return message
    }
    
}