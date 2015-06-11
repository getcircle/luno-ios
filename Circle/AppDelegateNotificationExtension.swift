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
    
    enum NotificationAction: String {
        case Approve = "APPROVE"
        case Deny = "DENY"
    }
    
    // These are set on the server and are based on a client-server contract
    enum NotificationCategory: String {
        case GroupRequest = "GROUP_REQUEST"
    }
    
    // These are set on the server and are based on a client-server contract
    enum NotificationUserInfoKey: String {
        case GroupRequestID = "request_id"
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
        approveAction.identifier = NotificationAction.Approve.rawValue
        approveAction.destructive = false
        approveAction.authenticationRequired = false

        var denyAction = UIMutableUserNotificationAction()
        denyAction.activationMode = .Background
        denyAction.title = AppStrings.GroupRequestDenyButtonTitle
        denyAction.identifier = NotificationAction.Deny.rawValue
        denyAction.destructive = false
        denyAction.authenticationRequired = false
        
        var groupRequestActionCategory = UIMutableUserNotificationCategory()
        groupRequestActionCategory.identifier = NotificationCategory.GroupRequest.rawValue
        groupRequestActionCategory.setActions([approveAction, denyAction], forContext: .Default)
        
        var notificationCategories = Set<UIUserNotificationCategory>()
        notificationCategories.insert(groupRequestActionCategory)
        return notificationCategories
    }
    
    internal func handleRemoteNotification(userInfo: [NSObject : AnyObject]) {
        var alertTitle = AppStrings.NotificationTitle
        var alertMessage = ""
        
        // Get the title and message
        if let notificationPayload = userInfo["aps"] as? [String: AnyObject] {
            // If its a string, use a generic title and simply use the string as a message
            if let alertMessageString = notificationPayload["alert"] as? String {
                alertMessage = alertMessageString
            }
            else if let alertDictionary = notificationPayload["alert"] as? [String: String] {
                // For dictionaries use the standard keys
                alertTitle = alertDictionary["title"]!
                alertMessage = alertDictionary["body"]!
            }
        }
        
        // Can't do much if there is no message defined
        if alertMessage == "" {
            return
        }
        
        // Figure out actions to show
        var actions = [UIAlertAction]()
        
        // If there is a category key defined, use appropriate actions
        if let notificationCategory = userInfo["category"] as? String, category = NotificationCategory(rawValue: notificationCategory)  {
            switch (category) {
            case .GroupRequest:
                if let requestID = userInfo[NotificationUserInfoKey.GroupRequestID.rawValue] as? String {
                    let approveAction = UIAlertAction(
                        title: AppStrings.GroupRequestApproveButtonTitle, 
                        style: .Default,
                        handler: { (action) -> Void in
                            self.actOnGroupRequest(requestID, shouldApprove: true)
                        })
                    
                    let denyAction = UIAlertAction(
                        title: AppStrings.GroupRequestDenyButtonTitle, 
                        style: .Default, 
                        handler: { (action) -> Void in
                            self.actOnGroupRequest(requestID, shouldApprove: false)
                        })
                    
                    actions.append(denyAction)
                    actions.append(approveAction)
                }
                
                break
                
            default:
                break
            }
        }
        
        // If not, default to OK
        if actions.count == 0 {
            let genericOKAction = UIAlertAction(title: AppStrings.GenericOKButtonTitle, style: .Default, handler: nil)
            actions.append(genericOKAction)
        }
        
        // Show the custom alert dialog
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        for action in actions {
            alertController.addAction(action)
        }

        window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    internal func actOnGroupRequest(requestID: String, shouldApprove: Bool) {
        var status = Services.Group.Actions.RespondToMembershipRequest.RequestV1.ResponseActionV1.Approve
        Services.Group.Actions.respondToMembershipRequest(requestID, action: status, completionHandler: nil)
    }
}
