//
//  UIViewControllerExtension.swift
//  Circle
//
//  Created by Ravi Rani on 12/16/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit
import ProtobufRegistry

enum QuickAction: Int {
    case None
    case Email
    case Message
    case MoreInfo
    case Phone
    case Slack
    
    struct MetaInfo {
        var actionLabel: String
        var imageSource: String
        var placeholder: String
    }
    
    static func metaInfoForQuickAction(quickAction: QuickAction) -> MetaInfo {
        switch quickAction {
        case .None:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionNoneLabel,
                imageSource: "", 
                placeholder: AppStrings.QuickActionNonePlaceholder
            )

        case .Email:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionEmailLabel,
                imageSource: "Email",
                placeholder: AppStrings.QuickActionEmailPlaceholder
            )
            
        case .Message:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionMessageLabel,
                imageSource: "Sms",
                placeholder: AppStrings.QuickActionMessagePlaceholder
            )

        case .MoreInfo:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionInfoLabel,
                imageSource: "Ellipsis",
                placeholder: AppStrings.QuickActionInfoPlaceholder
            )
        
        case .Phone:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionCallLabel,
                imageSource: "Call",
                placeholder: AppStrings.QuickActionCallPlaceholder
            )
            
        case .Slack:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionSlackLabel,
                imageSource: "Info",
                placeholder: AppStrings.QuickActionSlackPlaceholder
            )
        }
    }
}

struct QuickActionNotifications {
    // Started indicates taps where the receipient or the info needed to do the quick action
    // is still to be gathered
    static let onQuickActionStarted = "com.rhlabs.notification:QuickActionStarted"
    
    // Selected should be used when the receipient info is available and is expected
    // in the user info dictionary
    static let onQuickActionSelected = "com.rhlabs.notification:QuickActionSelected"
    
    // UserInfo Keys
    static let QuickActionTypeUserInfoKey = "quickAction"
    static let AdditionalDataUserInfoKey = "additionalData"
}

extension UIViewController {

    var pushAnimator: UIViewControllerAnimatedTransitioning? {
        return nil
    }

    var popAnimator: UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func isBeingPresentedModally() -> Bool {
        return navigationController?.topViewController == self && navigationController?.viewControllers.count == 1
    }
    
    // MARK: - Share functionality

    /**
    * Presents the standard compose mail view controller.
    *
    * The calling controller is made the delegate for the mail view controller.
    * NOTE: It is the responsibility of the delegate to dismiss this VC.
    */
    func presentMailViewController(toRecipients: [AnyObject]?, subject: String?, messageBody: String?,
        completionHandler: (() -> Void)?) {
            
            if MFMailComposeViewController.canSendMail() {
                
                var mailVC = MFMailComposeViewController()
                if toRecipients?.count > 0 {
                    mailVC.setToRecipients(toRecipients)
                }
                
                if let subjectString = subject {
                    mailVC.setSubject(subject)
                }
                
                var message: String = messageBody ?? ""
                message += "\n\n\nSent using Circle app"
                mailVC.setMessageBody(message, isHTML: false)
                
                if let composeDelegate = self as? MFMailComposeViewControllerDelegate {
                    mailVC.mailComposeDelegate = composeDelegate
                }
                
                mailVC.navigationBar.tintColor = UIColor.appNavigationBarTintColor()
                presentViewController(mailVC, animated: true, completion: { () -> Void in
                    UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                    if let handler = completionHandler {
                        handler()
                    }
                })
            }
            else {
                //TODO: Show generic error
            }
    }

    /**
    * Presents the standard compose message view controller.
    *
    * The calling controller is made the delegate for the message view controller.
    * NOTE: It is the responsibility of the delegate to dismiss this VC.
    */
    func presentMessageViewController(toRecipients: [AnyObject]?, subject: String?, messageBody: String?,
        completionHandler: (() -> Void)?) {
            
        if MFMessageComposeViewController.canSendText() {
            
            var messageVC = MFMessageComposeViewController()

            // Recipients
            if toRecipients?.count > 0 {
                messageVC.recipients = toRecipients
            }
            
            // Subject
            if MFMessageComposeViewController.canSendSubject() {
                if let subjectString = subject {
                    messageVC.subject = subjectString
                }
            }
            
            // Body
            var message: String = messageBody ?? ""
            message += "\n\n\nSent using Circle app"
            messageVC.body = messageBody
            
            // Delegate
            if let composeDelegate = self as? MFMessageComposeViewControllerDelegate {
                messageVC.messageComposeDelegate = composeDelegate
            }
            
            messageVC.navigationBar.tintColor = UIColor.appNavigationBarTintColor()
            presentViewController(messageVC, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                if let handler = completionHandler {
                    handler()
                }
            })
        }
        else {
            //TODO: Show generic error
        }
    }
    
    // MARK: - Authentication
    
    func checkUserAndPresentAuthViewController() -> Bool {
        return AuthViewController.checkUser(
            unverifiedPhoneHandler: nil, 
            unverifiedProfileHandler: nil
        )
    }
    
    func setStatusBarHidden(hidden: Bool, animated: Bool? = true) {
        var withAnimation: UIStatusBarAnimation = animated != nil ? (animated! ? .Fade : .None) : .Fade
        UIApplication.sharedApplication().setStatusBarHidden(hidden, withAnimation: withAnimation)
    }
    
    func navigationBarHeight() -> CGFloat {
        if let navBarHidden = navigationController?.navigationBarHidden {
            return (navBarHidden ? 0.0 : (navigationController?.navigationBar.frame.height ?? 0.0))
        }
        
        return 0.0
    }
    
    func currentStatusBarHeight() -> CGFloat {
        if !UIApplication.sharedApplication().statusBarHidden {
            let statusBarFrame = view.window?.convertRect(UIApplication.sharedApplication().statusBarFrame, toView:view)
            return statusBarFrame?.size.height ?? 0.0
        }
        
        return 0.0
    }

    func addAddButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        let addButtonItem = UIBarButtonItem(
            image: UIImage(named: "Add"),
            style: .Plain,
            target: self,
            action: callbackMethod
        )
        
        navigationItem.rightBarButtonItem = addButtonItem
        return addButtonItem
    }

    func addNextButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        let nextButtonItem = UIBarButtonItem(
            title: AppStrings.GenericNextButtonTitle,
            style: .Plain,
            target: self,
            action: callbackMethod
        )
        
        navigationItem.rightBarButtonItem = nextButtonItem
        return nextButtonItem
    }

    func addDoneTextButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        let doneButtonItem = UIBarButtonItem(
            title: AppStrings.GenericDoneButtonTitle,
            style: .Plain,
            target: self,
            action: callbackMethod
        )
        
        navigationItem.rightBarButtonItem = doneButtonItem
        return doneButtonItem
    }
    
    func addDoneButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        let saveButtonItem = UIBarButtonItem(
            image: UIImage(named: "Check"),
            style: .Plain,
            target: self,
            action: callbackMethod
        )

        navigationItem.rightBarButtonItem = saveButtonItem
        return saveButtonItem
    }
    
    func addCloseButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        if isBeingPresentedModally() {
            let cancelButtonItem = UIBarButtonItem(
                image: UIImage(named: "close"),
                style: .Plain,
                target: self,
                action: callbackMethod
            )
            navigationItem.leftBarButtonItem = cancelButtonItem
            return cancelButtonItem
        }
        
        return nil
    }
    
    func showToast(message: String, title: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: AppStrings.GenericOKButtonTitle, style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Common Navigation VCs
    
    func showProfileDetail(profile: Services.Profile.Containers.ProfileV1) {
        let profileDetailVC = ProfileDetailViewController(profile: profile)
        navigationController?.pushViewController(profileDetailVC, animated: true)
    }

    func showTeamDetail(team: Services.Organization.Containers.TeamV1) {
        let teamDetailVC = TeamDetailViewController()
        (teamDetailVC.dataSource as! TeamDetailDataSource).team = team
        navigationController?.pushViewController(teamDetailVC, animated: true)
    }
    
    func showLocationDetail(location: Services.Organization.Containers.LocationV1) {
        let locationDetailVC = LocationDetailViewController()
        (locationDetailVC.dataSource as! LocationDetailDataSource).location = location
        navigationController?.pushViewController(locationDetailVC, animated: true)
    }
    
    
}
