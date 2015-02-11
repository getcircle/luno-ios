//
//  UIViewControllerExtension.swift
//  Circle
//
//  Created by Ravi Rani on 12/16/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit

enum QuickAction: Int {
    case None
    case Email
    case Message
    case Phone
    case Slack
    
    static func placeholderByQuickAction(quickAction: QuickAction) -> String {
        switch quickAction {
        case .None:
            return NSLocalizedString("Search people, teams, skills, etc.",
                comment: "Placeholder text for search field used to search people, teams and skills.")
            
        case .Email:
            return NSLocalizedString("Who do you want to email",
                comment: "Placeholder for search field used search for the person user intends to email")
            
        case .Message:
            return NSLocalizedString("Who do you want to message",
                comment: "Placeholder for search field used search for the person user intends to send a message")
        case .Phone:
            return NSLocalizedString("Who do you want to call",
                comment: "Placeholder for search field used search for the person user intends to call")
            
        case .Slack:
            return NSLocalizedString("Who do you want to message",
                comment: "Placeholder for search field used search for the person user intends to send a message")
        }
    }
}

extension UIViewController {

    struct QuickActionNotifications {
        static let QuickActionSelected = "com.ravcode.notification:QuickActionSelected"
    }

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
                
                mailVC.navigationBar.tintColor = UIColor.navigationBarTintColor()
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
            
            messageVC.navigationBar.tintColor = UIColor.navigationBarTintColor()
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
    
    func checkUserAndPresentAuthViewController() {
        AuthViewController.checkUser(unverifiedPhoneHandler: nil, unverifiedProfileHandler: nil)
    }
    
    func setStatusBarHidden(hidden: Bool, animated: Bool? = true) {
        var withAnimation: UIStatusBarAnimation = animated != nil ? (animated! ? .Fade : .None) : .Fade
        UIApplication.sharedApplication().setStatusBarHidden(hidden, withAnimation: withAnimation)
    }
    
    func navigationBarHeight() -> CGFloat {
        if let navBarHidden = navigationController?.navigationBarHidden {
            return (navBarHidden ? 0.0 : (navigationController?.navigationBar.frameHeight ?? 0.0))
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
}