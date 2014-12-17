//
//  ReadReceipt.swift
//  Circle
//
//  Created by Michael Hahn on 12/1/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

class ReadReceipt: PFObject, PFSubclassing {
    
    override class func load() {
        registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "ReadReceipt"
    }
    
    var person: Person! {
        return objectForKey("person") as Person!
    }
    
    var message: Message! {
        return objectForKey("message") as Message!
    }
    
    
}
