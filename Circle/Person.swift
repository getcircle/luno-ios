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

    var location:String! {
        return self.objectForKey("location") as String!
    }

    var country:String! {
        return self.objectForKey("country") as String!
    }
    
    var manager:Person! {
        return self.objectForKey("manager") as Person!
    }

    var hasDirectReports:Bool!
    
    var hasManager: Bool {
        return manager != nil
    }
    
    func description() -> String {
        return firstName + " " + lastName
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Person"
    }

    // Please note that the following two arrays are
    // supposed to be 1:1. If you add anything to one
    // of them, be sure to add correspoding entry
    // in the other one.
    //
    // Also, the order here is important because this is
    // how the profile view will show the entries.
    //
    // Eventually this info will be sent by the backend.
    let attributeTitles = [
        "Email",
        "Cell Phone",
        "City",
        "Country",
        "Manager"
    ]
    
    private let attributeKeys = [
        "email",
        "cell",
        "location",
        "country",
        "manager"
    ]
    
    func attributes() -> [String] {

        assert(attributeTitles.count == attributeKeys.count, "Attribute titles and keys should have 1:1 mapping")
        var attributes = [String]()
        for index in 0..<attributeKeys.count {
            if let value: AnyObject = self.objectForKey(attributeKeys[index]) {
                attributes.append(value.description())
            }
        }
        
        return attributes
    }
}