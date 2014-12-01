//
//  Message.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

class Message: PFObject, PFSubclassing {
    
    var contents: String! {
        return self.objectForKey("contents") as String!
    }
    
    var ephemeral: Bool! {
        return self.objectForKey("ephemeral") as Bool!
    }
    
    var sender: Person! {
        return self.objectForKey("sender") as Person!
    }
    
    // TODO: possibly have an object like ReadReceipt which could contain Person and a Date of when it was read.
    var readBy: [String]! {
        return self.objectForKey("readBy") as [String]!
    }
    
    var chatRoom: ChatRoom! {
        return self.objectForKey("chatRoom") as ChatRoom
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
   
}
