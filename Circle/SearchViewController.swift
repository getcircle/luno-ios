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
CardHeaderViewDelegate,
NewNoteViewControllerDelegate {

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var companyNameLabel: UILabel!
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    
    private var companyProfileImageView: UIImageView!
    private var data = [Card]()
    private var firstLoad = false
    private var landingDataSource: SearchLandingDataSource!
    private var searchHeaderView: SearchHeaderView!
    private var selectedAction: QuickAction = .None {
        didSet {
            searchHeaderView.searchTextField.placeholder = QuickAction.placeholderByQuickAction(selectedAction)
        }
    }
    private var shadowAdded = false
    private var queryDataSource: SearchQueryDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstLoad = true
        configureView()
        configureSearchHeaderView()
        configureCollectionView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        registerNotifications()
        loadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        checkUserAndPresentAuthViewController()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // We need to remove observer only from some notifications
        // specifically the ones that modify the view hierarchy
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: SkillsCollectionViewCellNotifications.onSkillSelectedNotification,
            object: nil
        )
    }
    
    deinit {
        unregisterNotifications()
    }

    // MARK: - Configuration

    private func configureView() {
    }

    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
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
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        (collectionView.delegate as CardCollectionViewDelegate?)?.delegate = self
        
        landingDataSource = SearchLandingDataSource()
        landingDataSource.registerDefaultCardHeader(collectionView)
        landingDataSource.cardHeaderDelegate = self
        collectionView.dataSource = landingDataSource
        
        queryDataSource = SearchQueryDataSource()
        queryDataSource.registerCardHeader(collectionView)
    }
    
    // MARK: - Load data

    private func loadOrganizationInfo() {
        // Get this from the server
        companyProfileImageView.image = UIImage(named: "EB")
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searchHeaderView.showCancelButton()
        collectionView.dataSource = queryDataSource
        collectionView.reloadData()
        search()
    }

    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        selectedAction = .None
        collectionView.dataSource = landingDataSource
        queryDataSource.resetCards()
        collectionView.reloadData()
    }
    
    // MARK: Search Targets
    
    func search() {
        let query = searchHeaderView.searchTextField.text
        (collectionView.dataSource as SearchQueryDataSource).filter(searchHeaderView.searchTextField.text) { (error) -> Void in
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        var properties = [
            TrackerProperty.withKeyString("card_type").withString(selectedCard.type.rawValue),
            TrackerProperty.withKeyString("card_title").withString(selectedCard.title),
            TrackerProperty.withKey(.Source).withSource(.Home),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        
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
                    profileVC.hidesBottomBarWhenPushed = true
                    properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                    properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile))
                    properties.append(TrackerProperty.withDestinationId("profile_id").withString(profile.id))
                    Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                    navigationController?.pushViewController(profileVC, animated: true)
                }
            case .Group:
                let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
                viewController.dataSource.setInitialData(selectedCard.content[0] as [AnyObject], ofType: nil)
                viewController.title = selectedCard.title
                viewController.hidesBottomBarWhenPushed = true
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Overview))
                properties.append(TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(.Profiles))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(viewController, animated: true)

            case .Locations:
                if let locationAddress = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Address {
                    let viewController = LocationDetailViewController()
                    (viewController.dataSource as LocationDetailDataSource).selectedLocation = locationAddress
                    viewController.hidesBottomBarWhenPushed = true
                    properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                    properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Office))
                    properties.append(TrackerProperty.withDestinationId("location_id").withString(locationAddress.id))
                    Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                    navigationController?.pushViewController(viewController, animated: true)
                }
                
            case .Team:
                if let selectedTeam = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Team {
                    let viewController = TeamDetailViewController()
                    (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                    viewController.hidesBottomBarWhenPushed = true
                    properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                    properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Team))
                    properties.append(TrackerProperty.withDestinationId("team_id").withString(selectedTeam.id))
                    Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                    navigationController?.pushViewController(viewController, animated: true)
                }
            
            case .Notes:
                if let selectedNote = dataSource.contentAtIndexPath(indexPath)? as? NoteService.Containers.Note {
                    if let profiles = selectedCard.metaData as? [ProfileService.Containers.Profile] {
                        if let selectedProfile = profiles[indexPath.row] as ProfileService.Containers.Profile? {
                            let viewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
                            viewController.profile = selectedProfile
                            viewController.delegate = self
                            viewController.note = selectedNote
                            viewController.hidesBottomBarWhenPushed = true
                            properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                            properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Note))
                            Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                            navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
                
            default:
                break
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Home)
        ]
        Tracker.sharedInstance.trackMajorScrollEvents(
            .ViewScrolled,
            scrollView: scrollView,
            direction: .Vertical,
            properties: properties
        )
    }
    
    //MARK: - Skill Selected Notification
    
    func didSelectSkill(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedSkill = userInfo["skill"] as? ProfileService.Containers.Skill {
                trackSkillSelected(selectedSkill)
                let viewController = SkillDetailViewController()
                (viewController.dataSource as SkillDetailDataSource).selectedSkill = selectedSkill
                viewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(card: Card!) {
        trackCardHeaderTapped(card)
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
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)

        case .Locations:
            break
            
        case .Skills:
            let skillsOverviewViewController = SkillsOverviewViewController(nibName: "SkillsOverviewViewController", bundle: nil)
            skillsOverviewViewController.dataSource.setInitialData(content: card.allContent[0] as [AnyObject])
            skillsOverviewViewController.title = card.title
            skillsOverviewViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(skillsOverviewViewController, animated: true)
            
        case .Notes:
            let viewController = NotesOverviewViewController(nibName: "NotesOverviewViewController", bundle: nil)
            viewController.dataSource.setInitialData(content: card.allContent as [AnyObject], ofType: nil, withMetaData: card.metaData)
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = true
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
            selector: "didSelectSkill:",
            name: SkillsCollectionViewCellNotifications.onSkillSelectedNotification,
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
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Notification Handlers
    
    func userLoggedIn(notification: NSNotification!) {
        (collectionView.dataSource as? CardDataSource)?.resetCards()
        collectionView.reloadData()
        loadData()
    }
    
    func quickActionSelected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let quickAction = userInfo[QuickActionNotifications.QuickActionTypeUserInfoKey] as? Int {
                if let quickActionType = QuickAction(rawValue: quickAction) {
                    selectedAction = quickActionType
                    searchHeaderView.searchTextField.becomeFirstResponder()
                }
            }
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

        case .Phone:
            if let recipient = profile.cell_phone as String? {
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", recipient.removePhoneNumberFormatting())) {
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
    
    func didAddNote(note: NoteService.Containers.Note) {
        loadData()
    }
    
    func didDeleteNote(note: NoteService.Containers.Note) {
        loadData()
    }
    
    // MARK: - Tracking
    
    private func trackCardHeaderTapped(card: Card) {
        let properties = [
            TrackerProperty.withKeyString("card_type").withString(card.type.rawValue),
            TrackerProperty.withKey(.Source).withSource(.Home),
            TrackerProperty.withKey(.Destination).withSource(.Overview),
            TrackerProperty.withKey(.DestinationOverviewType).withString(card.title),
            TrackerProperty.withKeyString("card_title").withString(card.title),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        Tracker.sharedInstance.track(.CardHeaderTapped, properties: properties)
    }
    
    private func trackSkillSelected(skill: ProfileService.Containers.Skill) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Home),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Skill),
            TrackerProperty.withDestinationId("skill_id").withString(skill.id)
        ]
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
}
