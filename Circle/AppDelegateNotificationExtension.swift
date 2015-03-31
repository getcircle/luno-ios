//
//  AppDelegateNotificationExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

extension AppDelegate {

    func registerForRemoteNotifications() {
        let notificationTypes: UIUserNotificationType = .Badge | .Sound | .Alert
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }
}
