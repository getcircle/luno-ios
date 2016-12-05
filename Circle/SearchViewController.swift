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
        Tracker.sharedInstance.trackPageView(pageType: .Home)
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

        let loggedInUser = AuthenticationViewController.getLoggedInUser()
        if firstLoad {
            firstLoad = false
            if checkUserAndPresentAuthenticationViewController() {
                hideAndRemoveLaunchView()
                if let user = loggedInUser {
                    AuthenticationViewController.fetchAndCacheUserOrganization(user.id, completion: nil)
                }
            }
        }
        else if loggedInUser != nil && launchScreenView != nil {
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
        edgesForExtendedLayout = .None
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
                string: "Built by Luno. Powered by you".localizedUppercaseString(),
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
        (dataSource as! SearchQueryDataSource).searchCategory = nil
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
        }

        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
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
        let newCenterY = -view.frameHeight/2 - 24.0
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
        
        switch selectedCard.type {
        case .SearchResult:
            var searchResultType: TrackerProperty.SearchResultType?
            var searchResultId: String?

            if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                showProfileDetail(profile)
                searchResultId = profile.id
                searchResultType = .Profile
                CircleCache.recordProfileSearchResult(profile)
            }
            else if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                showTeamDetail(team)
                searchResultId = team.id
                searchResultType = .Team
                CircleCache.recordTeamSearchResult(team)
            }
            else if let location = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.LocationV1 {
                showLocationDetail(location)
                searchResultId = location.id
                searchResultType = .Location
                CircleCache.recordLocationSearchResult(location)
            }
            else if let post = dataSource.contentAtIndexPath(indexPath) as? Services.Post.Containers.PostV1 {
                showPostDetail(post)
                searchResultId = post.id
                searchResultType = .Post
                CircleCache.recordPostSearchResult(post)
            }
            
            if let searchResultType = searchResultType {
                Tracker.sharedInstance.trackSearchResultTap(
                    query: dataSource.searchTerm,
                    searchSource: dataSource.getSearchTrackingSource(),
                    searchLocation: .Home,
                    searchResultType: searchResultType,
                    searchResultIndex: indexPath.row + 1,
                    searchResultId: searchResultId,
                    category: dataSource.getSearchTrackingCategory(),
                    attribute: nil,
                    value: nil
                )
            }
            
        case .SearchSuggestion:
            if let searchCategory = dataSource.contentAtIndexPath(indexPath) as? SearchCategory, searchDataSource = dataSource as? SearchQueryDataSource {
                do {
                    // Replace current data source with new data source for the selected category and ask it to start loading in data
                    // Paginated data sources should notify the delegate (self) when finished loading, who should append new content to the collection view
                    // Non-paginated data sources should reload the collection view when finished via the completion handler
                    switch searchCategory.type {
                    case .People:
                        searchDataSource.searchCategory = .Profiles
                        let profilesDataSource = ProfilesSearchDataSource()
                        profilesDataSource.searchLocation = .Home
                        profilesDataSource.delegate = self
                        try profilesDataSource.configureForOrganization()
                        
                        collectionView.dataSource = profilesDataSource
                        collectionView.reloadData()
                        
                        searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                        profilesDataSource.loadData({ (error) -> Void in
                        })
                        
                        dataSource = profilesDataSource
                        
                    case .Locations:
                        
                        searchDataSource.searchCategory = .Locations
                        // TODO This should be coming from a paginated data source
                        let locationsDataSource = LocationsSearchDataSource()
                        locationsDataSource.searchLocation = .Home
                        
                        collectionView.dataSource = locationsDataSource
                        collectionView.reloadData()
                        
                        searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                        
                        locationsDataSource.loadData({ (error) -> Void in
                            self.collectionView.reloadData()
                        })
                        
                        dataSource = locationsDataSource
                        
                    case .Teams:
                        
                        searchDataSource.searchCategory = .Teams
                        let teamsDataSource = TeamsSearchDataSource()
                        teamsDataSource.delegate = self
                        teamsDataSource.searchLocation = .Home
                        try teamsDataSource.configureForOrganization()
                        
                        collectionView.dataSource = teamsDataSource
                        collectionView.reloadData()
                        
                        searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                        
                        teamsDataSource.loadData({ (error) -> Void in
                        })
                        
                        dataSource = teamsDataSource
                        
                    case .Posts:
                        searchDataSource.searchCategory = .Posts
                        let postsDataSource = PostsSearchDataSource()
                        postsDataSource.searchLocation = .Home
                        postsDataSource.delegate = self
                        try postsDataSource.configureForOrganization()
                        
                        collectionView.dataSource = postsDataSource
                        collectionView.reloadData()
                        
                        searchHeaderView.showTagWithTitle(searchCategory.title.localizedUppercaseString())
                        postsDataSource.loadData({ (error) -> Void in
                        })
                        
                        dataSource = postsDataSource
                    }
                }
                catch {
                    print("Error: \(error)")
                }
            }
            
        case .SearchAction:
            if let searchAction = dataSource.contentAtIndexPath(indexPath) as? SearchAction {
                do {
                    try handleSearchAction(searchAction, index: indexPath.row + 1)
                }
                catch {
                    print("Error: \(error)")
                }
            }
            
        default:
            break
            
        }
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
        Tracker.sharedInstance.trackPageView(pageType: .Home)
        hideAndRemoveLaunchView()
        dataSource.resetCards()
        collectionView.reloadData()
        orgImageView.image = nil
        loadOrgImageView()
        loadData()
        if let navController = navigationController where navController.viewControllers.count > 1 {
            navController.popToRootViewControllerAnimated(false)
            searchHeaderView.cancelButtonTapped(notification)
        }
    }
    
    // MARK: - Quick Actions
    
    private func performQuickAction(selectedAction: QuickAction, profile: Services.Profile.Containers.ProfileV1) -> Bool {
        switch selectedAction {
        case .Email:
            if let email = profile.getEmail() {
                presentMailViewController([email], subject: "", messageBody: "", completionHandler: nil)
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
                presentMessageViewController([recipient!], subject: "", messageBody: "", completionHandler: nil)
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

    // MARK: - Search Actions
    
    private func handleSearchAction(searchAction: SearchAction, index: Int) throws {

        var trackerResultId: String?
        
        switch searchAction.type {
        case .EmailPerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                trackerResultId = profile.id
                Tracker.sharedInstance.trackContactTap(
                    .Email,
                    contactProfile: profile,
                    contactLocation: .SearchSmartAction
                )
                performQuickAction(.Email, profile: profile)
            }
            
        case .MessagePerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                trackerResultId = profile.id
                Tracker.sharedInstance.trackContactTap(
                    .Message,
                    contactProfile: profile,
                    contactLocation: .SearchSmartAction
                )
                performQuickAction(.Message, profile: profile)
            }

        
        case .CallPerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                trackerResultId = profile.id
                Tracker.sharedInstance.trackContactTap(
                    .Call,
                    contactProfile: profile,
                    contactLocation: .SearchSmartAction
                )
                performQuickAction(.Phone, profile: profile)
            }
            
        case .ReportsToPerson:
            if let profile = searchAction.underlyingObject as? Services.Profile.Containers.ProfileV1 {
                trackerResultId = profile.id
                let viewController = ProfilesViewController()
                try (viewController.dataSource as! ProfilesDataSource).configureForDirectReports(profile)
                (viewController.dataSource as! ProfilesDataSource).searchLocation = .Home
                viewController.title = profile.firstName + "'s Direct Reports"
                viewController.pageType = .DirectReports
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .MembersOfTeam:
            if let team = searchAction.underlyingObject as? Services.Organization.Containers.TeamV1 {
                trackerResultId = team.id
                let viewController = ProfilesViewController()
                try (viewController.dataSource as! ProfilesDataSource).configureForTeam(team.id, setupOnlySearch: false)
                (viewController.dataSource as! ProfilesDataSource).searchLocation = .Home
                viewController.title = searchAction.getTitle()
                viewController.pageType = .TeamMembers
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .SubTeamsOfTeam:
            if let team = searchAction.underlyingObject as? Services.Organization.Containers.TeamV1 {
                trackerResultId = team.id
                let viewController = TeamsOverviewViewController()
                try (viewController.dataSource as! TeamsOverviewDataSource).configureForTeam(team.id, setupOnlySearch: false)
                (viewController.dataSource as! TeamsOverviewDataSource).searchLocation = .Home
                viewController.title = searchAction.getTitle()
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .AddressOfLocation:
            if let location = searchAction.underlyingObject as? Services.Organization.Containers.LocationV1 {
                trackerResultId = location.id
                let viewController = MapViewController()
                viewController.location = location
                presentViewController(viewController, animated: true, completion: nil)
            }

        case .PeopleInLocation:
            if let location = searchAction.underlyingObject as? Services.Organization.Containers.LocationV1 {
                trackerResultId = location.id
                let viewController = ProfilesViewController()
                try (viewController.dataSource as! ProfilesDataSource).configureForLocation(location.id, setupOnlySearch: false)
                (viewController.dataSource as! ProfilesDataSource).searchLocation = .Home
                viewController.title = searchAction.getTitle()
                viewController.pageType = .LocationMembers
                navigationController?.pushViewController(viewController, animated: true)
            }
        
        case .LocalTimeAtLocation:
            if let location = searchAction.underlyingObject as? Services.Organization.Containers.LocationV1 {
                trackerResultId = location.id
            }
            break;
            
        default:
            break;
        }
        
        Tracker.sharedInstance.trackSearchResultTap(
            query: dataSource.searchTerm,
            searchSource: .SmartAction,
            searchLocation: .Home,
            searchResultType: SearchActionType.trackerSearchResultType(searchAction.type),
            searchResultIndex: index,
            searchResultId: trackerResultId,
            category: dataSource.getSearchTrackingCategory(),
            attribute: nil,
            value: nil
        )
    }
    
    // MARK: - CardDataSourceDelegate
    
    func onDataLoaded(indexPaths: [NSIndexPath]) {
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertItemsAtIndexPaths(indexPaths)
            }, completion: nil)
    }
}
