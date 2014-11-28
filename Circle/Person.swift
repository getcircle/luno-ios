//
//  Person.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Parse

class Person : PFObject, PFSubclassing {
    
    var profileImageURL:String! {
        return self.objectForKey("profileImageURL") as String!
    }

    var firstName:String! {
        return self.objectForKey("firstName") as String!
    }
    
    var lastName:String! {
        return self.objectForKey("lastName") as String!
    }

    var email:String! {
        return self.objectForKey("email") as String!
    }

    var title:String! {
        return self.objectForKey("title") as String!
    }

    var manager:Person! {
        return self.objectForKey("manager") as Person!
    }

    var hasDirectReports:Bool!
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Person"
    }
    
    func attributes() -> [String:String] {
        var attributeTitleAndKeys = ["Email": "email"]
        var attributes = [String:String]()
        
        for (title, key) in attributeTitleAndKeys {
            if let value = (self.objectForKey(key) as? String) {
                attributes[title] = value
            }
        }
        
        return attributes
    }
}