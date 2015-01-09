//
//  DetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit
import ProtobufRegistry

class DetailViewController: UIViewController, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {

    private(set) var activityIndicatorView: UIActivityIndicatorView!
    var animationSourceRect: CGRect?
    private(set) var collectionView: UICollectionView!
    var dataSource: CardDataSource!
    var delegate: ProfileCollectionViewDelegate!
    var layout: ProfileCollectionViewLayout!
    
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
    
    private func customInit() {
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func loadView() {
        var rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView
        
        // Collection View
        layout = ProfileCollectionViewLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        // Activity View
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(true)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
    }
    
    var showLogOutButton: Bool? {
        didSet {
            addLogOutButton()
        }
    }
    var showCloseOrBackButton: Bool? {
        didSet {
            addCloseOrBackButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        dataSource.loadData { (error) -> Void in
            self.activityIndicatorView.stopAnimating()
            self.collectionView!.reloadData()
        }
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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Do not show the opaque bar again if:
        // a. this view was presented modally
        // b. this view is being dismissed vs disappearing because another view controller was added to the stack
        // c. the view controller prior to this one was a DetailViewController
        if !isBeingPresentedModally() && isMovingFromParentViewController() {
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
    
    private func addLogOutButton() {
        if showLogOutButton == true && navigationItem.rightBarButtonItem == nil {
            let logOutButton = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOutTapped:")
            navigationItem.rightBarButtonItem = logOutButton
        }
    }
    
    func logOutTapped(sender: AnyObject!) {
        AuthViewController.logOut()
    }
    
    private func addCloseOrBackButton() {
        if showCloseOrBackButton == true && navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(
                image: isBeingPresentedModally() ? UIImage(named: "Down") : UIImage(named: "Previous"),
                style: .Plain,
                target: self,
                action: "closeOrBackButtonTapped:"
            )
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    func closeOrBackButtonTapped(sender: AnyObject!) {
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    // MARK: - Configuration
    
    /**
        Configures the collection view for the details - specifically sets the correct
        background color, registers the header, sets the collection view delegate.
    
        Subclasses must override this to actually set the data source and the delegate. So, 
        any custom implmentation should preceed the superclass function call.
    */
    func configureCollectionView() {
        assert(dataSource != nil, { () -> String in
            return "Data source must be set before calling this function"
        }())
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.keyboardDismissMode = .OnDrag
        (collectionView!.dataSource as CardDataSource).registerCardHeader(collectionView!)
        (collectionView!.delegate as CardCollectionViewDelegate).delegate = self
    }

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError!
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

