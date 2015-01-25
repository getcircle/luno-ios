//
//  BaseDetailViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class BaseDetailViewController: UIViewController {
    
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
    
    func customInit() {
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isBeingPresentedModally() {
            navigationController?.navigationBar.makeTransparent()
        }
        else {
            transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
                self.navigationController?.navigationBar.makeTransparent()
                return
                },
                completion: nil
            )
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Do not show the opaque bar again if:
        // a. this view was presented modally
        // b. this view is being dismissed vs disappearing because another view controller was added to the stack
        // c. the view controller prior to this one was a DetailViewController
        if isMovingFromParentViewController() || (navigationController?.viewControllers.first is DetailViewController) {
            if let totalViewControllers = navigationController?.viewControllers.count {
                let parentController = navigationController?.viewControllers[(totalViewControllers - 1)] as? UIViewController
                if !(parentController is DetailViewController) {
                    transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
                        toViewController.navigationController?.navigationBar.makeOpaque()
                        
                        return
                        }, completion: nil)
                }
            }
        }
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
    */
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTag:",
            name: TagsCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTeam:",
            name: TeamsCollectionViewCellNotifications.onTeamSelectedNotification,
            object: nil
        )
    }
    
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Notification Handlers
    
    func didSelectTag(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["tag"] as? ProfileService.Containers.Tag {
                let viewController = TagDetailViewController()
                (viewController.dataSource as TagDetailDataSource).selectedTag = selectedTag
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func didSelectTeam(notification: NSNotification!) {
        if let userInfo = notification.userInfo {
            if let selectedTeam = userInfo["team"] as? OrganizationService.Containers.Team {
                let viewController = TeamDetailViewController()
                (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}
