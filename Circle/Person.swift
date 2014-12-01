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
    
    class func importData() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            var peopleObjectsByEmail = [String:Person]()
            var employeeManagerEmails = [String:String]()

            // Query existing entries
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyNetworkOnly
            parseQuery.includeKey("manager")
            let existingObjects = parseQuery.findObjects() as [Person]
            for existingObject in existingObjects {
                peopleObjectsByEmail[existingObject.email] = existingObject
            }

            let columns = [
                "firstName",
                "lastName",
                "email",
                "profileImageURL",
                "title",
                "cell",
                "location",
                "country",
                "department",
                "manager",
            ]
            
            let filePathName = "/Users/anju/Apps/Circle/Circle/CircleData.csv"
            let fileManager = NSFileManager()
            if fileManager.fileExistsAtPath(filePathName) {
                let fileContents = NSString(contentsOfFile: filePathName, encoding: NSUTF8StringEncoding, error: nil)
                var lines = fileContents?.componentsSeparatedByString("\n") as [String]
                // Remove line 0 - with column names
                lines.removeAtIndex(0)
                
                for line in lines {
                    let columnData = line.componentsSeparatedByString(",")
                    println(columnData)

                    // Populate person
                    var person = Person()
                    for index in 0..<columnData.count {
                        if index == (columnData.count - 1) {
                            // Last item is manager - Keep reference
                            employeeManagerEmails[person.email] = columnData[index]
                        }
                        else {
                            person.setValue(columnData[index], forKey: columns[index])
                        }
                    }
                    
                    // Create and save user
                    var pfuser = PFUser()
                    pfuser.username = person.firstName.lowercaseString
                    pfuser.password = "abcd"
                    pfuser.email = person.email
                    pfuser.signUp()
                    
                    println("Created user \(person.email)")

                    // Relate user with person
                    person.setObject(pfuser, forKey: "user")
                    // Store reference to people
                    peopleObjectsByEmail[person.email] = person
                    println("Created person \(person.email)")
                }
                
                println("Employee Manager Emails = \(employeeManagerEmails)")
                
                // Create manager relationships
                for (employeeEmail, managerEmail) in employeeManagerEmails {
                    if let manager = peopleObjectsByEmail[managerEmail] {
                        if let person = peopleObjectsByEmail[employeeEmail] {
                            person.setObject(manager, forKey: "manager")
                        }
                    }
                }
                
                // Save all person objects now
                for (email, personObject) in peopleObjectsByEmail {
                    personObject.save()
                }
            }
        })
    }
}