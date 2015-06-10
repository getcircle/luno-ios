//
//  AppDelegateNotificationExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    class var NotificationActionApprove: String {
        return "APPROVE"
    }

    class var NotificationActionDeny: String {
        return "DENY"
    }
    
    class var NotificationCategoryGroupRequest: String {
        return "GROUP_REQUEST"
    }

    func registerForRemoteNotifications() {
        let notificationTypes: UIUserNotificationType = .Badge | .Sound | .Alert
        let notificationSettings = UIUserNotificationSettings(
            forTypes: notificationTypes, 
            categories: getNotificationCategories()
        )
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }
    
    private func getNotificationCategories() -> Set<UIUserNotificationCategory>? {
        var approveAction = UIMutableUserNotificationAction()
        approveAction.activationMode = .Background
        approveAction.title = AppStrings.GroupRequestApproveButtonTitle
        approveAction.identifier = self.dynamicType.NotificationActionApprove
        approveAction.destructive = false
        approveAction.authenticationRequired = false

        var denyAction = UIMutableUserNotificationAction()
        denyAction.activationMode = .Background
        denyAction.title = AppStrings.GroupRequestDenyButtonTitle
        denyAction.identifier = self.dynamicType.NotificationActionDeny
        denyAction.destructive = false
        denyAction.authenticationRequired = false
        
        var groupRequestActionCategory = UIMutableUserNotificationCategory()
        groupRequestActionCategory.identifier = self.dynamicType.NotificationCategoryGroupRequest
        groupRequestActionCategory.setActions([approveAction, denyAction], forContext: .Default)
        
        var notificationCategories = Set<UIUserNotificationCategory>()
        notificationCategories.insert(groupRequestActionCategory)
        return notificationCategories
    }
}
