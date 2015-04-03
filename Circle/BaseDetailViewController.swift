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
    
    override init() {
        super.init()
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
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
        edgesForExtendedLayout = .Top
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
            var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
            if !(toViewController is BaseDetailViewController) {
                toViewController.navigationController?.navigationBar.makeOpaque()
            }
            return
        }, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
        
        When overriding, subclasses should call the super class function as well.
    */
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTag:",
            name: TagScrollingCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTeam:",
            name: TeamsCollectionViewCellNotifications.onTeamSelectedNotification,
            object: nil
        )
    }
    
    /**
        Removes observer from generic notifications needed by all detail view controllers.
        
        Subclasses should override this function if they have also overridden registerNotifications and
        remove observer for custom notifications.
        
        When overriding, subclasses should call the super class function as well.
    */
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: TagScrollingCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: TeamsCollectionViewCellNotifications.onTeamSelectedNotification,
            object: nil
        )
    }
    
    // MARK: - Notification Handlers
    
    func didSelectTag(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["interest"] as? ProfileService.Containers.Tag {
                let viewController = TagDetailViewController()
                (viewController.dataSource as TagDetailDataSource).selectedTag = selectedTag
                viewController.hidesBottomBarWhenPushed = false
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func didSelectTeam(notification: NSNotification!) {
        if let userInfo = notification.userInfo {
            if let selectedTeam = userInfo["team"] as? OrganizationService.Containers.Team {
                let viewController = TeamDetailViewController()
                (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                viewController.hidesBottomBarWhenPushed = false
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError!
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
