//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import MessageUI
import ProtobufRegistry

class SearchViewController: UIViewController,
UICollectionViewDelegate,
UITextFieldDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
SearchHeaderViewDelegate,
CardHeaderViewDelegate {
    
    enum QuickAction {
        case None
        case Email
        case Message
        case Phone
        case Slack
        
        static func placeholderByQuickAction(quickAction: QuickAction) -> String {
            switch quickAction {
            case .None:
                return NSLocalizedString("Search people, teams, tags, etc.",
                    comment: "Placeholder text for search field used to search people, teams and tags.")
                
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
    private var firstLoad = false
    private var landingDataSource: SearchLandingDataSource!
    private var loggedInUserProfileImageView: CircleImageView!
    private var searchHeaderView: SearchHeaderView!
    private var selectedAction: QuickAction = .None {
        didSet {
            searchHeaderView.searchTextField.placeholder = QuickAction.placeholderByQuickAction(selectedAction)
        }
    }
    private var shadowAdded = false
    private var queryDataSource: SearchQueryDataSource!

    private let offsetToTriggerMovingCollectionViewDown: CGFloat = -120.0
    private let shadowOpacity: Float = 0.2
    private let collectionViewScaleValue: CGFloat = 0.9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstLoad = true
        collectionViewTopConstraintInitialValue = collectionViewTopConstraint.constant
        configureView()
        configureSearchHeaderView()
        configureCollectionView()
        configureCollectionViewOverlay()
        configureQuickActionsView()
        configureNavigationActionButtons()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        registerNotifications()
        if firstLoad {
            moveSearchFieldToCenter()
            addShadowToSearchField()
            firstLoad = false
        }

        loadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAndPresentAuthViewController()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // We need to remove observer only from some notifications
        // specifically the ones that modify the view hierarchy
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: TagsCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
    }
    
    deinit {
        unregisterNotifications()
    }

    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.viewBackgroundColor()
        title = NSBundle.appName()
    }

    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.addTarget(self, action: "search", forControlEvents: .EditingChanged)
            searchHeaderContainerView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            searchHeaderView.layer.cornerRadius = 10.0
            selectedAction = .None
        }
    }
    
    // MARK: - Load Data
    
    private func loadData() {
        if let currentDataSource = (collectionView.dataSource as? SearchLandingDataSource) {
            currentDataSource.loadData { (error) -> Void in
                if error == nil {
                    self.activityIndicatorView.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }

    private func addShadowToSearchField() {
        if !shadowAdded {
            var path = UIBezierPath()
            path.moveToPoint(CGPointMake(-0.1, 5.0))
            path.addLineToPoint(CGPointMake(-0.1, searchHeaderView.frameHeight - 0.9))
            path.addLineToPoint(CGPointMake(searchHeaderView.frameWidth + 0.1, searchHeaderView.frameHeight - 0.9))
            path.addLineToPoint(CGPointMake(searchHeaderView.frameWidth + 0.1, 5.0))
            searchHeaderView.layer.shadowPath = path.CGPath
            searchHeaderView.layer.shadowOpacity = 0.0
            searchHeaderView.layer.shadowOffset = CGSizeMake(1.0, 0.5)
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
        
        loggedInUserProfileImageView = CircleImageView(frame: CGRectMake(0.0, 0.0, 30.0, 30.0))
        loggedInUserProfileImageView.makeItCircular(false)
        leftView.addSubview(loggedInUserProfileImageView)
        loadUserProfileImage()
        
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
        loadOrganizationInfo()
        rightView.addSubview(companyProfileImageView)
        
        var rightButton = UIButton(frame: rightView.frame)
        rightButton.backgroundColor = UIColor.clearColor()
        rightButton.addTarget(self, action: "showOrganizationProfile:", forControlEvents: .TouchUpInside)
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
    
    private func loadOrganizationInfo() {
        // Get this from the server
        companyNameLabel.text = "Eventbrite"
        companyProfileImageView.image = UIImage(named: "EB")
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
        selectedAction = .None
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
        
        // Handle quick actions - this assumes quick actions will be on profiles only
        if dataSource is SearchQueryDataSource && selectedAction != .None {
            if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
                performQuickAction(profile)
            }
        }
        else {
            switch selectedCard.type {
            case .People, .Birthdays, .Anniversaries, .NewHires:
                if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
                    let profileVC = ProfileDetailsViewController.forProfile(profile)
                    navigationController?.pushViewController(profileVC, animated: true)
                }
            case .Group:
                let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
                viewController.dataSource.setInitialData(selectedCard.content[0] as [AnyObject], ofType: nil)
                viewController.title = selectedCard.title
                navigationController?.pushViewController(viewController, animated: true)

            case .Locations:
                if let locationAddress = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Address {
                    let viewController = LocationDetailViewController()
                    (viewController.dataSource as LocationDetailDataSource).selectedLocation = locationAddress
                    navigationController?.pushViewController(viewController, animated: true)
                }
                
            case .Team:
                if let selectedTeam = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Team {
                    let viewController = TeamDetailViewController()
                    (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                    navigationController?.pushViewController(viewController, animated: true)
                }
            
            case .Notes:
                // TODO: Replace with real profile object
                if let selectedNote = dataSource.contentAtIndexPath(indexPath)? as? NoteService.Containers.Note {
                    let viewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
                    viewController.profile = AuthViewController.getLoggedInUserProfile()
                    viewController.note = selectedNote
                    navigationController?.pushViewController(viewController, animated: true)
                }
                
            default:
                performSegueWithIdentifier("showListOfPeople", sender: collectionView)
            }
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
            break
            
        case .Notes:
            let viewController = NotesOverviewViewController(nibName: "NotesOverviewViewController", bundle: nil)
            viewController.dataSource.setInitialData(card.allContent as [AnyObject], ofType: nil)
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)

        default:
            break
        }
    }

    // MARK: - ScrollViewDelegate

    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= offsetToTriggerMovingCollectionViewDown {
            scrollView.setContentOffset(scrollView.contentOffset, animated: true)
            moveSearchFieldToCenter()
        }
    }
    
    // MARK: - Orientation change

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - IBActions
    
    @IBAction func showLoggedInUserProfile(sender: AnyObject!) {
        let profile = AuthViewController.getLoggedInUserProfile()!
        let profileViewController = ProfileDetailsViewController.forProfile(
            profile,
            showLogOutButton: true,
            showCloseButton: true
        )
        let navController = UINavigationController(rootViewController: profileViewController)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
    }

    @IBAction func showOrganizationProfile(sender: AnyObject!) {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            let orgVC = OrganizationDetailViewController(showCloseButton: true)
            (orgVC.dataSource as OrganizationDetailDataSource).selectedOrgId = loggedInUserProfile.organization_id
            let navController = UINavigationController(rootViewController: orgVC)
            navigationController?.presentViewController(navController, animated: true, completion: nil)
        }
        else {
            // TODO Show error
        }
    }
    
    @IBAction func profileLongPressHandler(sender: AnyObject!) {
        let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
        let onboardingNavigationController = UINavigationController(rootViewController: verifyPhoneNumberVC)
        navigationController?.presentViewController(onboardingNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func messageButtonTapped(sender: AnyObject!) {
        selectedAction = .Message
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject!) {
        selectedAction = .Email
        searchHeaderView.searchTextField.becomeFirstResponder()
    }

    @IBAction func phoneButtonTapped(sender: AnyObject!) {
        selectedAction = .Phone
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        // Always make sure we register only once
        // Usually this is not needed because the calls are ensured to be balanced
        // but in this case, we deregister from some in viewDidDisappear and some in deinit
        // Thereafter every viewWillAppear calls for registeration. So, we need to ensure
        // we don't register more than once.
        unregisterNotifications()
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
        (collectionView.dataSource as? CardDataSource)?.resetCards()
        collectionView.reloadData()
        loadUserProfileImage()
        loadData()
    }
    
    // MARK: - Helpers
    
    private func moveSearchFieldToTop() {
        if navigationController?.topViewController == self {
            bringUpCollectionView(searchHeaderView.searchTextField)
            UIView.animateWithDuration(
                0.3,
                delay: 0.0,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.collectionView.alpha = 0.0
                },
                completion: { (completed) -> Void in
                    self.collectionView.alpha = 1.0
                }
            )
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
            
            UIView.animateWithDuration(
                0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.5,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    self.quickActionsView.alpha = 1.0
                    self.collectionView.alpha = 1.0
                    self.collectionViewOverlay.alpha = 1.0
                    self.collectionView.transform = CGAffineTransformMakeScale(self.collectionViewScaleValue, self.collectionViewScaleValue)
                    self.companyNameLabel.alpha = 1.0
                    self.searchHeaderView.layer.shadowOpacity = self.shadowOpacity
                },
                completion: { (completed) -> Void in
                    self.searchHeaderView.layer.shadowOpacity = self.shadowOpacity
                    self.collectionView.setContentOffset(CGPointMake(0.0, -25.0), animated: false)
                }
            )
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
                self.searchHeaderView.layer.shadowOpacity = 0.0
            })
        }
    }
    
    // MARK: - Quick Actions
    
    private func performQuickAction(profile: ProfileService.Containers.Profile) -> Bool {
        switch selectedAction {
        case .Email:
            presentMailViewController([profile.email], subject: "Hey", messageBody: "", completionHandler: {() -> Void in
                self.resetQuickAction()
            })
            return true

        case .Message:
            var recipient = profile.cell_phone ?? profile.email
            presentMessageViewController([recipient], subject: "Hey", messageBody: "", completionHandler: {() -> Void in
                self.resetQuickAction()
            })
            return true

        default:
            break
        }
        
        return false
    }
    
    private func resetQuickAction() {
        selectedAction = .None
        searchHeaderView.cancelButtonTapped(self)
    }
    
    // MARK: - Gesture Recognizers
    
    func overlayViewPanned(recognizer: UIPanGestureRecognizer) {
        var translationInView = -recognizer.translationInView(view).y
        switch recognizer.state {
        case .Changed:
            if translationInView >= 0.0 {
                let distanceToReachFullScale = view.frameHeight / 2.0
                let scaleDelta = 1 - collectionViewScaleValue
                let scaleFactor = collectionViewScaleValue + ((translationInView / distanceToReachFullScale) * scaleDelta)
                collectionView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
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

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
