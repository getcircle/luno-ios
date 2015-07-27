//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 7/26/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import MessageUI
import ProtobufRegistry

class SearchViewController: UIViewController,
    UICollectionViewDelegate,
    UITextFieldDelegate,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    SearchHeaderViewDelegate,
    CardHeaderViewDelegate
{
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var orgImageView: CircleImageView!
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    @IBOutlet weak private(set) var searchHeaderContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchHeaderContainerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchHeaderContainerViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var statusBarView: UIView!
    
    private var activityIndicatorView: CircleActivityIndicatorView!
    private var errorMessageView: CircleErrorMessageView!
    private var data = [Card]()
    private var firstLoad = false
    private let dataSource = SearchQueryDataSource()
    private var cardCollectionViewDelegate: CardCollectionViewDelegate?
    private var launchScreenView: UIView?
    private var searchHeaderView: SearchHeaderView!
    private var selectedAction: QuickAction = .None {
        didSet {
            searchHeaderView.searchTextField.placeholder = QuickAction.metaInfoForQuickAction(selectedAction).placeholder
        }
    }
    private var shadowAdded = false
    private var wasErrorViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstLoad = true
        configureView()
        configureLaunchScreenView()
        configureSearchHeaderView()
        configureCollectionView()
        configureOrgImageView()
        activityIndicatorView = view.addActivityIndicator()
        activityIndicatorView.stopAnimating()
        errorMessageView = view.addErrorMessageView(nil, tryAgainHandler: { () -> Void in
            self.errorMessageView.hide()
            self.activityIndicatorView.startAnimating()
            self.loadData()
        })
        
        loadData()
        moveSearchToCenter(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activateSearchFieldIfPreSet()
        registerNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstLoad {
            firstLoad = false
            if checkUserAndPresentAuthViewController() {
                hideAndRemoveLaunchView()
            }
        }
        else if let user = AuthViewController.getLoggedInUser() where launchScreenView != nil {
            hideAndRemoveLaunchView()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications(false)
    }
    
    deinit {
        unregisterNotifications(true)
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        extendedLayoutIncludesOpaqueBars = true
        statusBarView.backgroundColor = UIColor.appUIBackgroundColor()
    }
    
    private func configureLaunchScreenView() {
        let nibViews = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: nil, options: nil)
        launchScreenView = nibViews.first as? UIView
        if let launchView = launchScreenView {
            tabBarController?.view.addSubview(launchView)
            tabBarController?.view.bringSubviewToFront(launchView)
            launchView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as! SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.addTarget(self, action: "search", forControlEvents: .EditingChanged)
            searchHeaderContainerView.addSubview(searchHeaderView)
            searchHeaderContainerView.addBottomBorder(offset: 0.0)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            searchHeaderView.layer.cornerRadius = 10.0
            selectedAction = .None
        }
    }
    
    private func configureOrgImageView() {
        if let currentOrganization = AuthViewController.getLoggedInUserOrganization() {
            orgImageView.setImageWithURL(NSURL(string: currentOrganization.imageUrl)!, animated: true)
        }
    }
    
    // MARK: - Launch View
    
    private func hideAndRemoveLaunchView() {
        if let launchView = launchScreenView {
            UIView.animateWithDuration(
                0.3,
                animations: { () -> Void in
                    launchView.alpha = 0.0
                    return
                },
                completion: { (completed) -> Void in
                    launchView.removeFromSuperview()
                    self.launchScreenView = nil
                }
            )
        }
    }
    
    // MARK: - Load Data
    
    func loadData() {
    }
    
    private func addShadowToSearchField() {
        if !shadowAdded {
            var path = UIBezierPath()
            path.moveToPoint(CGPointMake(-0.1, 5.0))
            path.addLineToPoint(CGPointMake(-0.1, searchHeaderView.frame.height - 0.9))
            path.addLineToPoint(CGPointMake(searchHeaderView.frame.width + 0.1, searchHeaderView.frame.height - 0.9))
            path.addLineToPoint(CGPointMake(searchHeaderView.frame.width + 0.1, 5.0))
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
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        cardCollectionViewDelegate = (collectionView.delegate as! CardCollectionViewDelegate)
        cardCollectionViewDelegate?.delegate = self
        println(collectionView.delegate)
        collectionView.dataSource = dataSource
        dataSource.cardHeaderDelegate = self
    }
    
    private func activateSearchFieldIfPreSet() {
        if searchHeaderView.searchTextField.text != "" && !searchHeaderView.searchTextField.isFirstResponder() {
            searchHeaderView.searchTextField.becomeFirstResponder()
        }
    }
    
    // Search View Animations
    
    private func moveSearchToTop(animated: Bool) {
        if searchHeaderContainerViewTopConstraint.constant == 0 {
            return
        }
        
        searchHeaderContainerViewTopConstraint.constant = 0
        searchHeaderContainerViewLeftConstraint.constant = 0
        searchHeaderContainerViewRightConstraint.constant = 0
        searchHeaderContainerView.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: { () -> Void in
            self.searchHeaderContainerView.layoutIfNeeded()
            self.orgImageView.layoutIfNeeded()
            self.collectionView.alpha = 1.0
            self.orgImageView.alpha = 0.0
        })
    }
    
    private func moveSearchToCenter(animated: Bool) {
        if searchHeaderContainerViewTopConstraint.constant != 0 {
            return
        }
        
        searchHeaderContainerViewTopConstraint.constant = view.center.y - (searchHeaderContainerView.frameHeight / 2.0)
        searchHeaderContainerViewLeftConstraint.constant = 15
        searchHeaderContainerViewRightConstraint.constant = 15
        searchHeaderContainerView.setNeedsUpdateConstraints()

        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: { () -> Void in
            self.searchHeaderContainerView.layoutIfNeeded()
            self.orgImageView.layoutIfNeeded()
            self.collectionView.alpha = 0.0
            self.orgImageView.alpha = 1.0
        })
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Animate container up
        moveSearchToTop(true)
        searchHeaderView.showCancelButton()
        wasErrorViewVisible = errorMessageView.isVisible()
        errorMessageView.hide()
        search()
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        // Animate it down
        moveSearchToCenter(true)
        selectedAction = .None
        dataSource.resetCards()
        collectionView.reloadData()
        if wasErrorViewVisible && dataSource.cards.count <= 1 {
            errorMessageView.show()
        }
    }
    
    // MARK: Search Targets
    
    func activateSearch(isQuickAction: Bool) {
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    func search() {
        let query = searchHeaderView.searchTextField.text
        dataSource.filter(searchHeaderView.searchTextField.text) { (error) -> Void in
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        var properties = [
            TrackerProperty.withKeyString("card_type").withString(selectedCard.type.rawValue),
            TrackerProperty.withKeyString("card_title").withString(selectedCard.title),
            TrackerProperty.withKey(.Source).withSource(.Search),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        
        // Handle quick actions - this assumes quick actions will be on profiles only
        if selectedAction != .None {
            if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                performQuickAction(profile)
            }
        }
        else {
            switch selectedCard.type {
            case .Profiles, .Birthdays, .Anniversaries, .NewHires:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    let profileVC = ProfileDetailViewController(profile: profile)
                    if selectedCard.type == .Anniversaries {
                        (profileVC.dataSource as! ProfileDetailDataSource).addBannerOfType = .Anniversary
                    }
                    else if selectedCard.type == .Birthdays {
                        (profileVC.dataSource as! ProfileDetailDataSource).addBannerOfType = .Birthday
                    }
                    else if selectedCard.type == .NewHires {
                        (profileVC.dataSource as! ProfileDetailDataSource).addBannerOfType = .NewHire
                    }
                    profileVC.hidesBottomBarWhenPushed = false
                    properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                    properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile))
                    properties.append(TrackerProperty.withDestinationId("profileId").withString(profile.id))
                    Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                    navigationController?.pushViewController(profileVC, animated: true)
                }
            case .GroupMemberImages:
                let viewController = ProfilesViewController()
                viewController.dataSource.setInitialData(selectedCard.content[0] as! [AnyObject], ofType: nil)
                viewController.title = selectedCard.title
                viewController.hidesBottomBarWhenPushed = false
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Overview))
                properties.append(TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(.Profiles))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(viewController, animated: true)
                
            case .Offices:
                if let office = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.LocationV1 {
                    let viewController = OfficeDetailViewController()
                    (viewController.dataSource as! OfficeDetailDataSource).selectedOffice = office
                    viewController.hidesBottomBarWhenPushed = false
                    properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                    properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Office))
                    properties.append(TrackerProperty.withDestinationId("office_id").withString(office.id))
                    Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                    navigationController?.pushViewController(viewController, animated: true)
                }
                
            case .Team:
                if let selectedTeam = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                    let viewController = TeamDetailViewController()
                    (viewController.dataSource as! TeamDetailDataSource).selectedTeam = selectedTeam
                    viewController.hidesBottomBarWhenPushed = false
                    properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                    properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Team))
                    properties.append(TrackerProperty.withDestinationId("team_id").withString(selectedTeam.id))
                    Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                    navigationController?.pushViewController(viewController, animated: true)
                }
                
            case .StatTile:
                let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! StatTileCollectionViewCell
                switch cell.tileType! {
                case .People:
                    let viewController = ProfilesViewController()
                    (viewController.dataSource as! ProfilesDataSource).configureForOrganization()
                    viewController.title = "People"
                    navigationController?.pushViewController(viewController, animated: true)
                case .Offices:
                    // TODO This should be coming from a paginated data source
                    let viewController = OfficesOverviewViewController(nibName: "OfficesOverviewViewController", bundle: nil)
                    viewController.title = "Offices"
                    viewController.dataSource.setInitialData(
                        ObjectStore.sharedInstance.locations.values.array,
                        ofType: nil
                    )
                    navigationController?.pushViewController(viewController, animated: true)
                case .Teams:
                    let viewController = TeamsOverviewViewController()
                    viewController.title = "Teams"
                    (viewController.dataSource as! TeamsOverviewDataSource).configureForOrganization()
                    navigationController?.pushViewController(viewController, animated: true)
                case .Interests:
                    // TODO This should be coming from a paginated data source
                    let interestsOverviewViewController = TagsOverviewViewController(nibName: "TagsOverviewViewController", bundle: nil)
                    interestsOverviewViewController.title = "Interests"
                    interestsOverviewViewController.dataSource.setInitialData(content: ObjectStore.sharedInstance.activeInterests.values.array)
                    navigationController?.pushViewController(interestsOverviewViewController, animated: true)
                case .Skills:
                    // TODO This should be coming from a paginated data source
                    let interestsOverviewViewController = TagsOverviewViewController(nibName: "TagsOverviewViewController", bundle: nil)
                    interestsOverviewViewController.title = "Skills"
                    interestsOverviewViewController.dataSource.setInitialData(content: ObjectStore.sharedInstance.activeSkills.values.array)
                    navigationController?.pushViewController(interestsOverviewViewController, animated: true)
                }
                
            default:
                break
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Search)
        ]
        Tracker.sharedInstance.trackMajorScrollEvents(
            .ViewScrolled,
            scrollView: scrollView,
            direction: .Vertical,
            properties: properties
        )
    }
    
    //MARK: - Tag Selected Notification
    
    func didSelectTag(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["interest"] as? Services.Profile.Containers.TagV1 {
                trackTagSelected(selectedTag)
                let viewController = TagDetailViewController()
                (viewController.dataSource as! TagDetailDataSource).selectedTag = selectedTag
                viewController.hidesBottomBarWhenPushed = false
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        trackQueryCardHeaderTapped(card)
        switch card.type {
        case .Profiles:
            let viewController = ProfilesViewController(isFilterView: true)
            viewController.dataSource.setInitialData(card.allContent, ofType: nil)
            viewController.title = card.title
            viewController.searchHeaderView?.searchTextField.text = searchHeaderView.searchTextField.text
            navigationController?.pushViewController(viewController, animated: true)
        case .Tags:
            let interestsOverviewViewController = TagsOverviewViewController(
                nibName: "TagsOverviewViewController",
                bundle: nil,
                isFilterView: true
            )
            interestsOverviewViewController.dataSource.setInitialData(content: card.allContent[0] as! [AnyObject])
            interestsOverviewViewController.title = card.title
            interestsOverviewViewController.searchHeaderView.searchTextField.text = searchHeaderView.searchTextField.text
            navigationController?.pushViewController(interestsOverviewViewController, animated: true)
        case .Team:
            let viewController = TeamsOverviewViewController(isFilterView: true)
            viewController.dataSource.setInitialData(card.allContent, ofType: nil)
            viewController.title = card.title
            viewController.searchHeaderView?.searchTextField.text = searchHeaderView.searchTextField.text
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
    
    @IBAction func messageButtonTapped(sender: AnyObject!) {
        selectedAction = .Message
        activateSearch(true)
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject!) {
        selectedAction = .Email
        activateSearch(true)
    }
    
    @IBAction func phoneButtonTapped(sender: AnyObject!) {
        selectedAction = .Phone
        activateSearch(true)
    }
    

    // MARK: - Notifications
    
    private func registerNotifications() {
        // Always make sure we register only once
        // Usually this is not needed because the calls are ensured to be balanced
        // but in this case, we deregister from some in viewDidDisappear and some in deinit
        // Thereafter every viewWillAppear calls for registeration. So, we need to ensure
        // we don't register more than once.
        unregisterNotifications(true)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTag:",
            name: TagScrollingCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "userLoggedIn:",
            name: AuthNotifications.onLoginNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "quickActionSelected:",
            name: QuickActionNotifications.onQuickActionStarted,
            object: nil
        )
    }
    
    private func unregisterNotifications(removeAll: Bool) {
        if removeAll {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        else {
            // We need to remove observer only from some notifications
            // specifically the ones that modify the view hierarchy
            NSNotificationCenter.defaultCenter().removeObserver(
                self,
                name: TagScrollingCollectionViewCellNotifications.onTagSelectedNotification,
                object: nil
            )
            
            NSNotificationCenter.defaultCenter().removeObserver(
                self,
                name: QuickActionNotifications.onQuickActionStarted,
                object: nil
            )
            
        }
    }
    
    // MARK: - Notification Handlers
    
    func userLoggedIn(notification: NSNotification!) {
        hideAndRemoveLaunchView()
        dataSource.resetCards()
        collectionView.reloadData()
        loadData()
    }

    func quickActionSelected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let quickAction = userInfo[QuickActionNotifications.QuickActionTypeUserInfoKey] as? Int {
                if let quickActionType = QuickAction(rawValue: quickAction) {
                    selectedAction = quickActionType
                    activateSearch(true)
                }
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private func performQuickAction(profile: Services.Profile.Containers.ProfileV1) -> Bool {
        switch selectedAction {
        case .Email:
            if let email = profile.getEmail() {
                presentMailViewController([email], subject: "Hey", messageBody: "", completionHandler: {() -> Void in
                    self.resetQuickAction()
                })
                return true
            }
            
        case .Message:
            var recipient: String?
            if let phone = profile.getCellPhone() {
                recipient = phone
            } else if let email = profile.getEmail() {
                recipient = email
            }
            if recipient != nil {
                presentMessageViewController([recipient!], subject: "Hey", messageBody: "", completionHandler: {() -> Void in
                    self.resetQuickAction()
                })
                return true
            }

        case .Phone:
            if let recipient = profile.getCellPhone() as String? {
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", recipient.removePhoneNumberFormatting()) as String) {
                    UIApplication.sharedApplication().openURL(phoneURL)
                }
            }
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
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - NewNoteViewControllerDelegate
    
    func didAddNote(note: Services.Note.Containers.NoteV1) {
        loadData()
    }
    
    func didDeleteNote(note: Services.Note.Containers.NoteV1) {
        loadData()
    }
    
    // MARK: - Tracking
    
    private func trackQueryCardHeaderTapped(card: Card) {
        let properties = [
            TrackerProperty.withKeyString("card_type").withString(card.type.rawValue),
            TrackerProperty.withKey(.Source).withSource(.Search),
            TrackerProperty.withKey(.Destination).withSource(.Overview),
            TrackerProperty.withKey(.DestinationOverviewType).withString(card.title),
            TrackerProperty.withKeyString("card_title").withString(card.title),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        Tracker.sharedInstance.track(.CardHeaderTapped, properties: properties)
    }
    
    private func trackTagSelected(interest: Services.Profile.Containers.TagV1) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Search),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Tag),
            TrackerProperty.withDestinationId("interest_id").withString(interest.id)
        ]
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
}
