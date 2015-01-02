//
//  UIViewControllerExtension.swift
//  Circle
//
//  Created by Ravi Rani on 12/16/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit

extension UIViewController {
    
    var pushAnimator: UIViewControllerAnimatedTransitioning? {
        return nil
    }

    var popAnimator: UIViewControllerAnimatedTransitioning? {
        return nil
    }

    /**
     * Presents the standard compose mail view controller.
     *
     * The calling controller is made the delegate for the mail view controller.
     * NOTE: It is the responsibility of the delegate to dismiss this vc.
     */
    func presentMailViewController(toRecipients: [AnyObject]?, subject: String?, messageBody: String?) {

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
            })
        }
        else {
//TODO: Show generic error
        }
    }
}