//
//  Message.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Parse

class Message: PFObject, PFSubclassing {
    
    var contents:String! {
        return self.objectForKey("contents") as String!
    }
    
    // this should be an NSLocalizedDate
    var created:String! {
        return self.objectForKey("created") as String!
    }
    
    var ephemeral:Bool! {
        return self.objectForKey("ephemeral") as Bool!
    }
    
    var sender:Person! {
        return self.objectForKey("from") as Person!
    }
    
    var readBy:[String]! {
        return self.objectForKey("readBy") as [String]!
    }
    
    var recipients:[Person]! {
        return self.objectForKey("recipients") as [Person]!
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
   
}
