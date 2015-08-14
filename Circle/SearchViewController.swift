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
    SearchHeaderViewDelegate
{
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var orgImageView: CircleImageView!
    @IBOutlet weak private(set) var poweredByLabel: UILabel!
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    @IBOutlet weak private(set) var searchHeaderContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchHeaderContainerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchHeaderContainerViewRightConstraint: NSLayoutConstraint!
    
    private var activityIndicatorView: CircleActivityIndicatorView!
    private var errorMessageView: CircleErrorMessageView!
    private var data = [Card]()
    private var firstLoad = false
    private let dataSource = SearchQueryDataSource()
    private var cardCollectionViewDelegate: CardCollectionViewDelegate?
    private var launchScreenView: UIView?
    private var searchFieldBottomBorder: UIView?
    private var searchHeaderView: SearchHeaderView!
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
        configurePoweredByLabel()
        activityIndicatorView = view.addActivityIndicator()
        activityIndicatorView.stopAnimating()
        errorMessageView = view.addErrorMessageView(nil, tryAgainHandler: { () -> Void in
            self.errorMessageView.hide()
            self.activityIndicatorView.startAnimating()
            self.loadData()
        })
        
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = false
        registerNotifications()
        if firstLoad {
            moveSearchToCenter(false)        
        }
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
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    deinit {
        unregisterNotifications()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        setNavigationTitle(false)
    }
    
    private func setNavigationTitle(isSearchActive: Bool) {
        navigationItem.title = isSearchActive ? "Search" : "Home"
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
            searchFieldBottomBorder = searchHeaderContainerView.addBottomBorder(offset: 0.0)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            searchHeaderView.layer.cornerRadius = 10.0
            searchHeaderView.searchTextField.placeholder = AppStrings.QuickActionNonePlaceholder
            searchHeaderContainerView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.2).CGColor
        }
    }
    
    private func configureOrgImageView() {
        if let currentOrganization = AuthViewController.getLoggedInUserOrganization() {
            orgImageView.setImageWithURL(NSURL(string: currentOrganization.imageUrl)!, animated: true)
        }
    }
    
    private func configurePoweredByLabel() {
        poweredByLabel.attributedText = NSAttributedString(
                string: "Powered by Circle".localizedUppercaseString(),
                attributes: [
                    NSKernAttributeName: NSNumber(double: 2.0),
                    NSForegroundColorAttributeName: poweredByLabel.textColor,
                    NSFontAttributeName: poweredByLabel.font
                ]
            )
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
        collectionView.dataSource = dataSource
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
            self.searchFieldBottomBorder?.layoutIfNeeded()
            self.collectionView.layoutIfNeeded()
            self.poweredByLabel.layoutIfNeeded()
            self.searchHeaderContainerView.addRoundCorners(radius: 0.0)
            self.searchHeaderContainerView.layer.borderWidth = 0.0
            self.orgImageView.alpha = 0.0
            self.poweredByLabel.alpha = 0.0
        }) { (completed) -> Void in
            UIView.animateWithDuration(animated ? 0.2 : 0.0, animations: { () -> Void in
                self.collectionView.alpha = 1.0
            })
        }
    }
    
    private func moveSearchToCenter(animated: Bool) {
        if searchHeaderContainerViewTopConstraint.constant != 0 {
            return
        }
        
        searchHeaderContainerViewTopConstraint.constant = view.frameHeight / 2
        searchHeaderContainerViewLeftConstraint.constant = 15
        searchHeaderContainerViewRightConstraint.constant = 15
        searchHeaderContainerView.setNeedsUpdateConstraints()

        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: { () -> Void in
            self.searchHeaderContainerView.layoutIfNeeded()
            self.orgImageView.layoutIfNeeded()
            self.searchFieldBottomBorder?.layoutIfNeeded()
            self.collectionView.layoutIfNeeded()
            self.poweredByLabel.layoutIfNeeded()
            self.searchHeaderContainerView.addRoundCorners(radius: 4.0)
            self.searchHeaderContainerView.layer.borderWidth = 1.0
            self.orgImageView.alpha = 1.0
            self.collectionView.alpha = 0.0
            self.poweredByLabel.alpha = 1.0
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
        setNavigationTitle(true)
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        // Animate it down
        moveSearchToCenter(true)
        dataSource.resetCards()
        collectionView.reloadData()
        if wasErrorViewVisible && dataSource.cards.count <= 1 {
            errorMessageView.show()
        }
        setNavigationTitle(false)
        // Clear cache at the end of a search session
        dataSource.clearCache()
    }
    
    // MARK: Search Targets
    
    func activateSearch(isQuickAction: Bool) {
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    func search() {
        let term = searchHeaderView.searchTextField.text
        dataSource.filter(term.trimWhitespace()) { (error) -> Void in
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
        
        switch selectedCard.type {
        case .Profiles:
            if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile))
                properties.append(TrackerProperty.withDestinationId("profileId").withString(profile.id))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                showProfileDetail(profile)
                CircleCache.recordProfileSearchResult(profile)
            }
            else if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Team))
                properties.append(TrackerProperty.withDestinationId("team_id").withString(team.id))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                showTeamDetail(team)
                CircleCache.recordTeamSearchResult(team)
            }
            else if let location = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.LocationV1 {
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Location))
                properties.append(TrackerProperty.withDestinationId("office_id").withString(location.id))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                showLocationDetail(location)
                CircleCache.recordLocationSearchResult(location)
            }
            
        case .SearchSuggestion:
            if let searchCategory = dataSource.contentAtIndexPath(indexPath) as? SearchCategory {
                switch searchCategory.type {
                case .People:
                    let viewController = ProfilesViewController()
                    (viewController.dataSource as! ProfilesDataSource).configureForOrganization()
                    viewController.title = "People"
                    navigationController?.pushViewController(viewController, animated: true)
                case .Locations:
                    // TODO This should be coming from a paginated data source
                    let viewController = LocationsOverviewViewController(nibName: "LocationsOverviewViewController", bundle: nil)
                    viewController.title = "Offices"
                    navigationController?.pushViewController(viewController, animated: true)
                case .Teams:
                    let viewController = TeamsOverviewViewController()
                    viewController.title = "Teams"
                    (viewController.dataSource as! TeamsOverviewDataSource).configureForOrganization()
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else if let searchAction = dataSource.contentAtIndexPath(indexPath) as? SearchAction {
                handleSearchAction(searchAction)
            }
            
        default:
            break
            
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
        
    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        unregisterNotifications()
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
    
    // MARK: - Notification Handlers
    
    func userLoggedIn(notification: NSNotification!) {
        hideAndRemoveLaunchView()
        dataSource.resetCards()
        collectionView.reloadData()
        loadData()
    }
    
    // MARK: - Quick Actions
    
    private func performQuickAction(selectedAction: QuickAction, profile: Services.Profile.Containers.ProfileV1) -> Bool {
        switch selectedAction {
        case .Email:
            if let email = profile.getEmail() {
                presentMailViewController([email], subject: "Hey", messageBody: "", completionHandler: nil)
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
                presentMessageViewController([recipient!], subject: "Hey", messageBody: "", completionHandler: nil)
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
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Tracking
    
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
    
    // MARK: - Search Actions
    
    private func handleSearchAction(searchAction: SearchAction) {
        
        switch searchAction.type {
        case .EmailPerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                performQuickAction(.Email, profile: profile)
            }
            
        case .MessagePerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                performQuickAction(.Message, profile: profile)
            }

        
        case .CallPerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                performQuickAction(.Phone, profile: profile)
            }
            
        case .ReportsToPerson:
            // TODO add support for this
            break
//            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
//                let viewController = ProfilesViewController()
//                (viewController.dataSource as! ProfilesDataSource).configureForDirectReports(profile)
//                viewController.title = profile.firstName + "'s Direct Reports"
//                navigationController?.pushViewController(viewController, animated: true)
//            }
            
        case .AddressOfLocation:
            if let location = searchAction.underlyingObject as? Services.Organization.Containers.LocationV1 {
                let viewController = MapViewController()
                viewController.location = location
                presentViewController(viewController, animated: true, completion: nil)
            }

        case .PeopleInLocation:
            if let location = searchAction.underlyingObject as? Services.Organization.Containers.LocationV1 {
                let viewController = ProfilesViewController()
                (viewController.dataSource as! ProfilesDataSource).configureForLocation(location.id, setupOnlySearch: false)
                viewController.title = searchAction.getTitle()
                navigationController?.pushViewController(viewController, animated: true)
            }
        
        default:
            break;
        }
    }
}
