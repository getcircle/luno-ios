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
import UIViewPlusPosition

class SearchViewController: UIViewController,
    UICollectionViewDelegate,
    UITextFieldDelegate,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    SearchHeaderViewDelegate,
    CircleTextFieldDelegate,
    CardDataSourceDelegate
{
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var fakeSearchContainer: UIView!
    @IBOutlet weak private(set) var fakeSearchContainerCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var fakeSearchTextField: UITextField!
    @IBOutlet weak private(set) var orgImageView: CircleImageView!
    @IBOutlet weak private(set) var poweredByLabel: UILabel!
    @IBOutlet private(set) var searchHeaderContainerView: UIView!
    
    private var activityIndicatorView: CircleActivityIndicatorView!
    private var cardCollectionViewDelegate: CardCollectionViewDelegate?
    private var data = [Card]()
    private var dataSource: CardDataSource = SearchQueryDataSource()
    private var errorMessageView: CircleErrorMessageView!
    private var firstLoad = false
    private var launchScreenView: UIView?
    private var searchHeaderView: SearchHeaderView!
    private var wasErrorViewVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstLoad = true
        configureView()
        configureLaunchScreenView()
        configureSearchHeaderView()
        configureCollectionView()
        configurePoweredByLabel()
        configureFakeSearchView()
        activityIndicatorView = view.addActivityIndicator()
        activityIndicatorView.stopAnimating()
        loadOrgImageView()
        errorMessageView = view.addErrorMessageView(nil, tryAgainHandler: { () -> Void in
            self.errorMessageView.hide()
            self.activityIndicatorView.startAnimating()
            self.loadData()
        })
        registerNotifications()
        loadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if firstLoad {
            firstLoad = false
            if checkUserAndPresentAuthenticationViewController() {
                hideAndRemoveLaunchView()
            }
        }
        else if AuthenticationViewController.getLoggedInUser() != nil && launchScreenView != nil {
            hideAndRemoveLaunchView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if searchHeaderView.searchTextField.isFirstResponder() {
            searchHeaderView.searchTextField.resignFirstResponder()
        }
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
            searchHeaderView.searchTextField.helperDelegate = self
            searchHeaderView.searchTextField.addTarget(self, action: "search", forControlEvents: .EditingChanged)
            searchHeaderContainerView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdges()
            resetSearchFieldPlaceholderText()
        }
    }
    
    private func configureFakeSearchView() {
        fakeSearchContainer.backgroundColor = UIColor.appViewBackgroundColor()

        let leftView = UIView()
        leftView.frame = CGRectMake(0.0, 0.0, 26.0, fakeSearchTextField.frame.height)
        leftView.backgroundColor = UIColor.clearColor()
        let leftViewImageView = UIImageView(image: UIImage(named: "searchbar_search")?.imageWithRenderingMode(.AlwaysTemplate))
        leftViewImageView.contentMode = .Center
        leftViewImageView.frame = CGRectMake(10.0, (fakeSearchTextField.frame.height - 16.0)/2.0, 16.0, 16.0)
        leftViewImageView.tintColor = UIColor.appSearchIconTintColor()
        leftView.addSubview(leftViewImageView)
        fakeSearchTextField.leftViewMode = .Always
        fakeSearchTextField.leftView = leftView

        fakeSearchTextField.font = UIFont.regularFont(14.0)
        fakeSearchTextField.text = ""
        fakeSearchTextField.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.2).CGColor
        fakeSearchTextField.layer.shadowOpacity = 0.09
        fakeSearchTextField.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        fakeSearchTextField.layer.shouldRasterize = true
        fakeSearchTextField.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    private func loadOrgImageView() {
        if let currentOrganization = AuthenticationViewController.getLoggedInUserOrganization() where orgImageView.image == nil {
            orgImageView.setImageWithURL(NSURL(string: currentOrganization.imageUrl)!, animated: true)
        }
    }
    
    private func configurePoweredByLabel() {
        poweredByLabel.attributedText = NSAttributedString(
                string: "Powered by Luno".localizedUppercaseString(),
                attributes: [
                    NSKernAttributeName: NSNumber(double: 2.0),
                    NSForegroundColorAttributeName: poweredByLabel.textColor,
                    NSFontAttributeName: poweredByLabel.font
                ]
            )
    }
    
    private func resetSearchFieldPlaceholderText() {
        for searchTextField in [searchHeaderView.searchTextField, fakeSearchTextField] {
            searchTextField.attributedPlaceholder = NSAttributedString(string: AppStrings.SearchPlaceholder,
                attributes: [
                    NSForegroundColorAttributeName: UIColor.appSecondaryTextColor()
                ]
            )
        }
    }
    
    private func useSearchQueryDataSource() {
        dataSource.delegate = nil
        dataSource = SearchQueryDataSource()
        search()
        collectionView.dataSource = dataSource
        collectionView.reloadData()
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
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
        }
    }
    
    // MARK: - Load Data
    
    func loadData() {
    }

    private func configureCollectionView() {
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.backgroundColor = UIColor.appSearchBackgroundColor()
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
        let newCenterY = -view.frameHeight/2 - 20.0
        if fakeSearchContainerCenterYConstraint.constant == newCenterY {
            return
        }
        
        fakeSearchContainerCenterYConstraint.constant = newCenterY
        fakeSearchContainer.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: { () -> Void in
            self.fakeSearchContainer.layoutIfNeeded()
            self.collectionView.layoutIfNeeded()
            self.fakeSearchContainer.alpha = 0.0
        }) { (completed) -> Void in
            self.addSearchToNavBar()
            UIView.animateWithDuration(animated ? 0.1 : 0.0, animations: { () -> Void in
                self.collectionView.alpha = 1.0
                self.searchHeaderContainerView.alpha = 1.0
            })
        }
    }
    
    private func moveSearchToCenter(animated: Bool) {
        fakeSearchContainerCenterYConstraint.constant = 0
        fakeSearchContainer.setNeedsUpdateConstraints()

        view.bringSubviewToFront(fakeSearchContainer)
        UIView.animateWithDuration(0.1) { () -> Void in
            self.searchHeaderContainerView.alpha = 0.0
        }
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: { () -> Void in
            self.fakeSearchContainer.layoutIfNeeded()
            self.fakeSearchContainer.alpha = 1.0
            self.collectionView.layoutIfNeeded()
            self.collectionView.alpha = 0.0
        }) { (completed) -> Void in
            self.removeSearchFromNavBar()
        }
    }
    
    // MARK: - Helpers
    
    func addSearchToNavBar() {
        if let titleView = navigationItem.titleView where titleView == searchHeaderContainerView {
            return
        }
        searchHeaderContainerView.translatesAutoresizingMaskIntoConstraints = true
        searchHeaderContainerView.frame = CGRectMake(0.0, 0.0, view.frameWidth, navigationBarHeight())
        navigationItem.titleView = searchHeaderContainerView
        searchHeaderContainerView.alpha = 0.0
    }
    
    func removeSearchFromNavBar() {
        navigationItem.titleView = nil
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == fakeSearchTextField {
            addSearchToNavBar()
            searchHeaderView.searchTextField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Animate container up
        moveSearchToTop(true)
        searchHeaderView.showCancelButton()
        wasErrorViewVisible = errorMessageView.isVisible()
        errorMessageView.hide()
        search()
        setNavigationTitle(true)
    }
    
    func textFieldDidDeleteBackwardWhenEmpty(textField: CircleTextField) {
        if !dataSource.isKindOfClass(SearchQueryDataSource) {
            searchHeaderView.hideTag()
            resetSearchFieldPlaceholderText()
            useSearchQueryDataSource()
        }
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        searchHeaderView.hideTag()
        resetSearchFieldPlaceholderText()
        
        // Animate it down
        moveSearchToCenter(true)
        dataSource.resetCards()
        collectionView.reloadData()
        if wasErrorViewVisible && dataSource.cards.count <= 1 {
            errorMessageView.show()
        }
        setNavigationTitle(false)
        // Clear cache at the end of a search session
        if let searchQueryDataSource = dataSource as? SearchQueryDataSource {
            searchQueryDataSource.clearCache()
        }
        else {
            useSearchQueryDataSource()
        }
    }
    
    func didSelectTag() {
        searchHeaderView.hideTag()
        resetSearchFieldPlaceholderText()
        
        useSearchQueryDataSource()
    }
    
    // MARK: Search Targets
    
    func activateSearch(isQuickAction: Bool) {
        searchHeaderView.searchTextField.becomeFirstResponder()
    }
    
    func search() {
        if let term = searchHeaderView.searchTextField.text?.trimWhitespace() where !term.isEmpty {
            dataSource.filter(term.trimWhitespace()) { (error) -> Void in
                self.collectionView.reloadData()
            }
        }
        else {
            dataSource.clearFilter({ () -> Void in
                self.collectionView.reloadData()
            })
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
        case .SearchResult:
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
                    let profilesDataSource = ProfilesSearchDataSource()
                    profilesDataSource.delegate = self
                    profilesDataSource.configureForOrganization()
                    
                    collectionView.dataSource = profilesDataSource
                    collectionView.reloadData()
                    
                    searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                    
                    profilesDataSource.loadData({ (error) -> Void in
                    })
                    
                    dataSource = profilesDataSource
                case .Locations:
                    // TODO This should be coming from a paginated data source
                    let locationsDataSource = LocationsSearchDataSource()
                    
                    collectionView.dataSource = locationsDataSource
                    collectionView.reloadData()
                    
                    searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                    
                    locationsDataSource.loadData({ (error) -> Void in
                        self.collectionView.reloadData()
                    })
                    
                    dataSource = locationsDataSource
                case .Teams:
                    let teamsDataSource = TeamsSearchDataSource()
                    teamsDataSource.delegate = self
                    teamsDataSource.configureForOrganization()
                    
                    collectionView.dataSource = teamsDataSource
                    collectionView.reloadData()

                    searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                    
                    teamsDataSource.loadData({ (error) -> Void in
                    })
                    
                    dataSource = teamsDataSource
                }
            }
                
        case .SearchAction:
            if let searchAction = dataSource.contentAtIndexPath(indexPath) as? SearchAction {
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
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "userLoggedIn:",
            name: AuthenticationNotifications.onLoginNotification,
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
        orgImageView.image = nil
        loadOrgImageView()
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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
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
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                let viewController = ProfilesViewController()
                (viewController.dataSource as! ProfilesDataSource).configureForDirectReports(profile)
                viewController.title = profile.firstName + "'s Direct Reports"
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .MembersOfTeam:
            if let team = searchAction.underlyingObject as? Services.Organization.Containers.TeamV1 {
                let viewController = ProfilesViewController()
                (viewController.dataSource as! ProfilesDataSource).configureForTeam(team.id, setupOnlySearch: false)
                viewController.title = searchAction.getTitle()
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .SubTeamsOfTeam:
            if let team = searchAction.underlyingObject as? Services.Organization.Containers.TeamV1 {
                let viewController = TeamsOverviewViewController()
                (viewController.dataSource as! TeamsOverviewDataSource).configureForTeam(team.id, setupOnlySearch: false)
                viewController.title = searchAction.getTitle()
                navigationController?.pushViewController(viewController, animated: true)
            }
            
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
    
    // MARK: - CardDataSourceDelegate
    
    func onDataLoaded(indexPaths: [NSIndexPath]) {
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completion: nil)
    }
}
