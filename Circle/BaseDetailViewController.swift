//
//  BaseDetailViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MessageUI
import ProtobufRegistry

class BaseDetailViewController: UIViewController,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate {

    convenience init(showCloseButton: Bool) {
        self.init()
        if showCloseButton {
            addCloseButton()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        customInit()
    }
    
    deinit {
        // Last attempt to ensure self has been removed correctly from all notifications
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func customInit() {
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.Top, .Bottom]
        navigationController?.view.backgroundColor = UIColor.appNavigationBarBarTintColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
            self.navigationController?.navigationBar.makeTransparent()
            return
            },
            completion: nil
        )
        navigationItem.title = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        registerNotifications()
        navigationController?.navigationBar.makeTransparent()
        navigationItem.title = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
            if !(toViewController is BaseDetailViewController) {
                toViewController.navigationController?.navigationBar.makeOpaque()
            }
            return
        }, completion: nil)
        unregisterNotifications()
    }

    private func addCloseButton() {
        if navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(
                image: UIImage(named: "Down"),
                style: .Plain,
                target: self,
                action: "closeButtonTapped:"
            )
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    func closeButtonTapped(sender: AnyObject!) {
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - Notifications
    
    /**
        Registers for notifications for generic events needed by all detail view controllers.
        
        The default handlers are also provided in this class. However subclasses can override
        the handlers and add any other custom functionality as needed.
        
        When overriding, subclasses should call the super static function as well.
    */
    func registerNotifications() {
    }
    
    /**
        Removes observer from generic notifications needed by all detail view controllers.
        
        Subclasses should override this function if they have also overridden registerNotifications and
        remove observer for custom notifications.
        
        When overriding, subclasses should call the super static function as well.
    */
    func unregisterNotifications() {
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError?
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
