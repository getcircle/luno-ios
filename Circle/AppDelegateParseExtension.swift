//
//  AppDelegateParseExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Foundation
import Parse

extension AppDelegate {

    func setupParse(launchOptions: [NSObject: AnyObject]?) {
        let applicationID = "6sLV1l2Pu7FMXa1rQCa8GIQ5B9xg3lbX8snFMLiB"
        let clientKey = "W1hR6R8Ie4J3U3nFzB5iduZ9yIdPNbiUHGgrCYxW"
        Parse.setApplicationId(applicationID, clientKey: clientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
    }
}