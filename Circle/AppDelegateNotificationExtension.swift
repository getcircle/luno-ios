//
//  AppDelegateNotificationExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

extension AppDelegate {
    
    func registerForRemoteNotifications() {
        let application = UIApplication.sharedApplication()
        application.registerForRemoteNotifications()
    }
}
