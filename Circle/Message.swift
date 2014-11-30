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
    
    var readBy: [String]! {
        return self.objectForKey("readBy") as [String]!
    }
    
    var recipient: Person! {
        return self.objectForKey("recipient") as Person!
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
   
}
