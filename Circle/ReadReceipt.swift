//
//  ReadReceipt.swift
//  Circle
//
//  Created by Michael Hahn on 12/1/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

class ReadReceipt: PFObject, PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "ReadReceipt"
    }
    
    var person: Person! {
        return self.objectForKey("person") as Person!
    }
    
    var message: Message! {
        return self.objectForKey("message") as Message!
    }
    
    
}
