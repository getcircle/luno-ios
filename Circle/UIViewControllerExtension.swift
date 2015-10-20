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
                placeholder: AppStrings.SearchPlaceholder
            )

        case .Email:
            return MetaInfo(
                actionLabel: AppStrings.QuickActionEmailLabel,
                imageSource: "detail_email",
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
                imageSource: "detail_phone",
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
            
            if let loggedInUserOrg = AuthenticationViewController.getLoggedInUserOrganization() where MFMailComposeViewController.canSendMail() {
                
                let mailVC = MFMailComposeViewController()
                if let recipients = toRecipients as? [String] where recipients.count > 0 {
                    mailVC.setToRecipients(recipients)
                }
                
                if let subjectString = subject {
                    mailVC.setSubject(subjectString)
                }
                
                var message: String = messageBody ?? ""
                let orgUrl = loggedInUserOrg.getURL("?ls=app_footer")
                let orgUrlText = (loggedInUserOrg.hasDomain ? loggedInUserOrg.domain + "." : "") + "lunohq.com"
                message += "<br/><br/><br/>Sent from <a href=\"" + orgUrl + "\">" + orgUrlText + "</a> "
                message += "using the <a href=\"https://itunes.apple.com/us/app/id981648781?mt=8\">iOS app</a>"
                mailVC.setMessageBody(message, isHTML: true)
                
                if let composeDelegate = self as? MFMailComposeViewControllerDelegate {
                    mailVC.mailComposeDelegate = composeDelegate
                }
                
                mailVC.navigationBar.tintColor = UIColor.appNavigationBarTintColor()
                presentViewController(mailVC, animated: true, completion: { () -> Void in
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
            
            let messageVC = MFMessageComposeViewController()

            // Recipients
            if let recipients = toRecipients as? [String] where recipients.count > 0 {
                messageVC.recipients = recipients
            }
            
            // Subject
            if MFMessageComposeViewController.canSendSubject() {
                if let subjectString = subject {
                    messageVC.subject = subjectString
                }
            }
            
            // Body
            var message: String = messageBody ?? ""
            message += "\n\n\nSent from luno"
            messageVC.body = messageBody
            
            // Delegate
            if let composeDelegate = self as? MFMessageComposeViewControllerDelegate {
                messageVC.messageComposeDelegate = composeDelegate
            }
            
            messageVC.navigationBar.tintColor = UIColor.appNavigationBarTintColor()
            presentViewController(messageVC, animated: true, completion: { () -> Void in
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
    
    func checkUserAndPresentAuthenticationViewController() -> Bool {
        return AuthenticationViewController.checkUser(
            unverifiedPhoneHandler: nil, 
            unverifiedProfileHandler: nil
        )
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
    
    func addCancelTextButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        if isBeingPresentedModally() {
            let cancelButtonItem = UIBarButtonItem(
                title: AppStrings.GenericCancelButtonTitle,
                style: .Plain,
                target: self,
                action: callbackMethod
            )
            navigationItem.leftBarButtonItem = cancelButtonItem
            return cancelButtonItem
        }
        
        return nil
    }
    
    func addSaveTextButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        let saveButtonItem = UIBarButtonItem(
            title: AppStrings.GenericSaveButtonTitle,
            style: .Plain,
            target: self,
            action: callbackMethod
        )
        
        navigationItem.rightBarButtonItem = saveButtonItem
        return saveButtonItem
    }
    
    func addPostTextButtonWithAction(callbackMethod: Selector) -> UIBarButtonItem? {
        let postButtonItem = UIBarButtonItem(
            title: AppStrings.GenericPostButtonTitle,
            style: .Plain,
            target: self,
            action: callbackMethod
        )
        
        navigationItem.rightBarButtonItem = postButtonItem
        return postButtonItem
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
    
    func showProfileStatusDetail(profileStatus: Services.Profile.Containers.ProfileStatusV1) {
        let profileStatusDetailVC = ProfileStatusDetailViewController()
        (profileStatusDetailVC.dataSource as! ProfileStatusDetailDataSource).profileStatus = profileStatus
        navigationController?.pushViewController(profileStatusDetailVC, animated: true)
    }
    
    // MARK: - Message View
    
    func addMessageView(message: String, messageType: MessageView.MessageType) -> MessageView {
        let messageView = MessageView(message: message, messageType: messageType)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageView)
        messageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        return messageView
    }
}
