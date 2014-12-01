//
//  AppDelegateParseExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Foundation

extension AppDelegate {

    func setupParse(launchOptions: [NSObject: AnyObject]?) {

        // Load custom subclasses
        ChatRoom.load()
        Message.load()
        Person.load()

        // Setup keys and init Parse
        let applicationID = "6sLV1l2Pu7FMXa1rQCa8GIQ5B9xg3lbX8snFMLiB"
        let clientKey = "W1hR6R8Ie4J3U3nFzB5iduZ9yIdPNbiUHGgrCYxW"
        Parse.setApplicationId(applicationID, clientKey: clientKey)
        
        // Track app launches
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        // Query and cache logged in person
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            AuthViewController.getLoggedInPerson()
            return
        })
        
        // Following are temporary functions added to reset or import new data
        // Make sure these are commented before checking in code
        // Log out user
        // PFUser.logOut()
        
        // Temp user creation step - Enable once when creating or importing data
        // Person.signUpInitialUsers()
        
        // Import data and create Parse objects
        // Person.importData()
    }
}