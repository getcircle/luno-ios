//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SearchViewController: UIViewController,
UICollectionViewDelegate,
UITextFieldDelegate,
SearchHeaderViewDelegate,
CardHeaderViewDelegate {
    
    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var addNoteQuickAction: UIButton!
    @IBOutlet weak private(set) var addReminderQuickAction: UIButton!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var collectionViewOverlay: UIView!
    @IBOutlet weak private(set) var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var companyNameLabel: UILabel!
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    @IBOutlet weak private(set) var searchHeaderContainerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchHeaderContainerViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchHeaderContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var quickActionsView: UIView!
    
    private var collectionViewTopConstraintInitialValue: CGFloat!
    private var companyProfileImageView: UIImageView!
    private var data = [Card]()
    private var landingDataSource: SearchLandingDataSource!
    private var loggedInUserProfileImageView: UIImageView!
    private var searchHeaderView: SearchHeaderView!
    private var shadowAdded = false
    private var queryDataSource: SearchQueryDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionViewTopConstraintInitialValue = collectionViewTopConstraint.constant
        configureView()
        configureSearchHeaderView()
        configureCollectionView()
        configureCollectionViewOverlay()
        configureQuickActionsView()
        configureNavigationActionButtons()
        moveSearchFieldToCenter()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        checkUserAndPresentAuthViewController()
        (collectionView.dataSource as? SearchLandingDataSource)?.loadData { (error) -> Void in
            if error == nil {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
        
        addShadowToSearchField()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }

    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.viewBackgroundColor()
    }

    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.placeholder = "Search people, teams, tags, etc."
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.addTarget(self, action: "search", forControlEvents: .EditingChanged)
            searchHeaderContainerView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }

    private func addShadowToSearchField() {
        if !shadowAdded {
            searchHeaderView.layer.shadowPath = UIBezierPath(rect: searchHeaderView.bounds).CGPath
            searchHeaderView.layer.shadowOpacity = 0.1
            searchHeaderView.layer.shadowOffset = CGSizeMake(2.0, 1.0)
            searchHeaderView.layer.shouldRasterize = true
            searchHeaderView.layer.rasterizationScale = UIScreen.mainScreen().scale
            shadowAdded = true
        }
    }

    private func configureCollectionView() {
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        (collectionView.delegate as CardCollectionViewDelegate?)?.delegate = self
        
        landingDataSource = SearchLandingDataSource()
        landingDataSource.registerDefaultCardHeader(collectionView)
        landingDataSource.cardHeaderDelegate = self
        collectionView.dataSource = landingDataSource
        
        queryDataSource = SearchQueryDataSource()
        queryDataSource.registerCardHeader(collectionView)
    }
    
    private func configureCollectionViewOverlay() {
        var tapGesture = UITapGestureRecognizer(target: self, action: "bringUpCollectionView:")
        collectionViewOverlay.addGestureRecognizer(tapGesture)
        
        var panGesture = UIPanGestureRecognizer(target: self, action: "overlayViewPanned:")
        collectionViewOverlay.addGestureRecognizer(panGesture)
    }

    private func configureQuickActionsView() {
        addNoteQuickAction.setImage(addNoteQuickAction.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        addReminderQuickAction.setImage(addReminderQuickAction.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        addNoteQuickAction.makeItCircular(true)
        addNoteQuickAction.layer.borderColor = UIColor.appTintColor().CGColor
        addReminderQuickAction.makeItCircular(true)
        addReminderQuickAction.layer.borderColor = UIColor.appTintColor().CGColor
    }

    private func configureNavigationActionButtons() {
        var leftView = UIView(frame: CGRectMake(0.0, 0.0, 30.0, 30.0))
        leftView.makeItCircular(false)
        
        loggedInUserProfileImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 30.0, 30.0))
        loggedInUserProfileImageView.makeItCircular(false)
        loadUserProfileImage()
        leftView.addSubview(loggedInUserProfileImageView)
        
        var leftButton = UIButton(frame: leftView.frame)
        leftButton.backgroundColor = UIColor.clearColor()
        leftButton.addTarget(self, action: "showLoggedInUserProfile:", forControlEvents: .TouchUpInside)

        // TODO add some check here for whether or not we're on production
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "profileLongPressHandler:")
        leftButton.addGestureRecognizer(longPressGesture)
        leftView.addSubview(leftButton)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        // Right Nav Button
        var rightView = UIView(frame: CGRectMake(0.0, 0.0, 30.0, 30.0))
        rightView.makeItCircular(false)
        
        companyProfileImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 30.0, 30.0))
        companyProfileImageView.makeItCircular(false)
        
        // Get this from the server
        companyProfileImageView.image = UIImage(named: "MI")
        rightView.addSubview(companyProfileImageView)
        
        var rightButton = UIButton(frame: rightView.frame)
        rightButton.backgroundColor = UIColor.clearColor()
        rightButton.addTarget(self, action: "showLoggedInUserProfile:", forControlEvents: .TouchUpInside)
        rightView.addSubview(rightButton)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightView)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK: - Load data
    
    private func loadUserProfileImage() {
        if let userProfile = AuthViewController.getLoggedInUserProfile() {
            loggedInUserProfileImageView.setImageWithProfile(userProfile)
        }
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searchHeaderView.showCancelButton()
        collectionView.dataSource = queryDataSource
        collectionView.reloadData()
        moveSearchFieldToTop()
    }

    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        collectionView.dataSource = landingDataSource
        queryDataSource.resetCards()
        collectionView.reloadData()
        moveSearchFieldToCenter()
    }
    
    // MARK: Search Targets
    
    func search() {
        let query = searchHeaderView.searchTextField.text
        if query == "" {
            (collectionView.dataSource as SearchQueryDataSource).resetCards()
            collectionView.reloadData()
        } else {
            (collectionView.dataSource as SearchQueryDataSource).filter(searchHeaderView.searchTextField.text) { (error) -> Void in
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        
        switch selectedCard.type {
        case .People, .Birthdays, .Anniversaries, .NewHires:
            if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
                let viewController = ProfileDetailViewController()
                viewController.profile = profile
                navigationController?.pushViewController(viewController, animated: true)
            }
        case .Group:
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            viewController.dataSource.setInitialData(selectedCard.content[0] as [AnyObject], ofType: nil)
            viewController.title = selectedCard.title
            navigationController?.pushViewController(viewController, animated: true)

        case .Locations:
            let viewController = LocationDetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Team:
            if let selectedTeam = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Team {
                let viewController = TeamDetailViewController()
                (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        default:
            performSegueWithIdentifier("showListOfPeople", sender: collectionView)
        }
    }
    
    //MARK: - Tag Selected Notification
    
    func didSelectTag(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["tag"] as? ProfileService.Containers.Tag {
                let viewController = TagDetailViewController()
                (viewController.dataSource as TagDetailDataSource).selectedTag = selectedTag
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(card: Card!) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        switch card.type {
        case .Group, .People, .Birthdays, .Anniversaries, .NewHires:
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            if card.type == .Group {
                viewController.dataSource.setInitialData(card.content[0] as [AnyObject], ofType: nil)
            }
            else {
                viewController.dataSource.setInitialData(card.allContent, ofType: card.type)
            }
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)

        case .Locations:
            let viewController = LocationDetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        default:
            break
        }
    }

    // MARK: - Orientation change

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - IBActions
    
    @IBAction func showLoggedInUserProfile(sender: AnyObject!) {
        let profileVC = ProfileDetailViewController()
        profileVC.showCloseButton = true
        profileVC.profile = AuthViewController.getLoggedInUserProfile()
        let navController = UINavigationController(rootViewController: profileVC)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject!) {
        (collectionView.dataSource as? CardDataSource)?.resetCards()
        collectionView.reloadData()
        AuthViewController.logOut()
    }
    
    @IBAction func profileLongPressHandler(sender: AnyObject!) {
        let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
        let onboardingNavigationController = UINavigationController(rootViewController: verifyPhoneNumberVC)
        navigationController?.presentViewController(onboardingNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func messageButtonTapped(sender: AnyObject!) {
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject!) {
        searchHeaderView.searchTextField.becomeFirstResponder()
    }

    @IBAction func phoneButtonTapped(sender: AnyObject!) {
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTag:",
            name: TagsCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "userLoggedIn:",
            name: AuthNotifications.onLoginNotification,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - User Logged in Notification
    
    func userLoggedIn(notification: NSNotification!) {
        loadUserProfileImage()
    }
    
    // MARK: - Helpers
    
    private func moveSearchFieldToTop() {
        if navigationController?.topViewController == self {
            bringUpCollectionView(searchHeaderView.searchTextField)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.collectionView.alpha = 0.0
            })
        }
    }
    
    private func moveSearchFieldToCenter() {
        if navigationController?.topViewController == self {
            searchHeaderContainerViewLeftConstraint.constant = 10.0
            searchHeaderContainerViewRightConstraint.constant = 10.0
            searchHeaderContainerViewTopConstraint.constant = 0.0
            searchHeaderContainerView.setNeedsUpdateConstraints()

            collectionViewTopConstraint.constant = collectionViewTopConstraintInitialValue
            collectionView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.quickActionsView.alpha = 1.0
                self.collectionView.alpha = 1.0
                self.collectionViewOverlay.alpha = 1.0
                self.collectionView.transform = CGAffineTransformMakeScale(0.95, 0.95)
                self.companyNameLabel.alpha = 1.0
            })
        }
    }
    
    func bringUpCollectionView(sender: AnyObject) {
        if navigationController?.topViewController == self {
            searchHeaderContainerViewLeftConstraint.constant = 0.0
            searchHeaderContainerViewRightConstraint.constant = 0.0
            searchHeaderContainerViewTopConstraint.constant = view.frameHeight / 2.0 -
                searchHeaderContainerView.frameHeight / 2.0 -
                (navigationController!.navigationBarHidden ? 0.0 : navigationController!.navigationBar.frameHeight)
            searchHeaderView.setNeedsUpdateConstraints()

            collectionViewTopConstraint.constant = 0.0
            collectionView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.quickActionsView.alpha = 0.0
                self.collectionViewOverlay.alpha = 0.0
                self.collectionView.transform = CGAffineTransformIdentity
                self.companyNameLabel.alpha = 0.0
            })
        }
    }
    
    func overlayViewPanned(recognizer: UIPanGestureRecognizer) {
        var translationInView = -recognizer.translationInView(view).y
        switch recognizer.state {
        case .Changed:
            if translationInView >= 0.0 {
                collectionViewTopConstraint.constant = max(0.0, collectionViewTopConstraintInitialValue - translationInView)
                collectionView.setNeedsUpdateConstraints()
                
                searchHeaderContainerViewTopConstraint.constant = min(translationInView, view.frameHeight / 2.0 -
                    searchHeaderContainerView.frameHeight / 2.0 - navigationBarHeight())
                searchHeaderContainerView.setNeedsUpdateConstraints()
                view.layoutIfNeeded()
                
                var alphaFactor = 1 - min(translationInView/100.0, 1.0)
                quickActionsView.alpha = alphaFactor
                companyNameLabel.alpha = alphaFactor
            }

        case .Ended:
            if translationInView >= 0.0 {
                let hasMovedPastCenter = translationInView >= 90.0
                if (recognizer.velocityInView(view).y >= 5.0 && hasMovedPastCenter) || hasMovedPastCenter {
                    bringUpCollectionView(recognizer)
                } else {
                    moveSearchFieldToCenter()
                }
            }
        
        default:
            moveSearchFieldToCenter()
        }
    }
}
