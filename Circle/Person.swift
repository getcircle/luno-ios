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

    var cell:String! {
        return self.objectForKey("cell") as String!
    }

    var city:String! {
        return self.objectForKey("location") as String!
    }

    var country:String! {
        return self.objectForKey("country") as String!
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
    
    let attributeTitles = [
        "Email",
        "Cell Phone",
        "City",
        "Country"
    ]
    
    private let attributeKeys = [
        "email",
        "cell",
        "location",
        "country"
    ]
    
    func attributes() -> [String] {

        assert(attributeTitles.count == attributeKeys.count, "Attribute titles and keys should have 1:1 mapping")
        var attributes = [String]()
        for index in 0..<attributeKeys.count {
            if let value = (self.objectForKey(attributeKeys[index]) as? String) {
                attributes.append(value)
            }
        }
        
        return attributes
    }
}