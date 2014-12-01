//
//  Person.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

class Person : PFObject, PFSubclassing {
    
    var profileImageURL: String! {
        return self.objectForKey("profileImageURL") as String!
    }

    var firstName: String! {
        return self.objectForKey("firstName") as String!
    }
    
    var lastName: String! {
        return self.objectForKey("lastName") as String!
    }

    var email: String! {
        return self.objectForKey("email") as String!
    }

    var title: String! {
        return self.objectForKey("title") as String!
    }

    var cell: String! {
        return self.objectForKey("cell") as String!
    }

    var location: String! {
        return self.objectForKey("location") as String!
    }

    var country: String! {
        return self.objectForKey("country") as String!
    }
    
    var manager: Person! {
        return self.objectForKey("manager") as Person!
    }

    var department: String! {
        return self.objectForKey("department") as String!
    }
    
    var user: PFUser! {
        return self.objectForKey("user") as PFUser!
    }
    
    var hasDirectReports: Bool!
    
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
    
    class func signUpInitialUsers() {
        let users = [
            ["username": "ravi", "email": "ravirani@gmail.com", "pass": "abcd"],
            ["username": "hahn", "email": "mwhahn@gmail.com", "pass": "abcd"],
            ["username": "brent", "email": "brent@traut.com", "pass": "abcd"],
        ]
        
        for user in users {
            var pfuser = PFUser()
            pfuser.username = user["username"]
            pfuser.password = user["pass"]
            pfuser.email = user["email"]
            
            pfuser.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    // Hooray! Let them use the app now.
                }
            }
        }
    }
}