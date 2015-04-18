//
//  ProfileDetailsViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailsViewController:
        BaseDetailViewController,
        UnderlyingCollectionViewDelegate,
        UIScrollViewDelegate,
        NewNoteViewControllerDelegate,
        ProfileDetailSegmentedControlDelegate,
        EditProfileDelegate
    {
    
    // Segmented Control Helpers
    private var currentIndex = 0
    
    private var firstLoad = true
    
    // Overlay view
    private var overlaidCollectionView: UICollectionView!
    
    // Underlying views
    private var underlyingScrollView: UIScrollView!
    private var underlyingContainerView: UIView!
    
    // Public variables
    var detailViews = [UnderlyingCollectionView]()
    var profile: Services.Profile.Containers.ProfileV1!
    
    convenience init(
        profile withProfile: Services.Profile.Containers.ProfileV1,
        detailViews withDetailViews: [UnderlyingCollectionView],
        overlaidCollectionView withOverlaidCollectionView: UICollectionView,
        showLogOutButton: Bool = false,
        showCloseButton: Bool = false,
        showSettingsButton: Bool = false
    ) {
        self.init(showCloseButton: showCloseButton)
        profile = withProfile
        detailViews = withDetailViews
        overlaidCollectionView = withOverlaidCollectionView
        (overlaidCollectionView.dataSource as ProfileOverlaidCollectionViewDataSource).profileHeaderViewDelegate = self
        if showLogOutButton {
            addLogOutButton()
        }
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.appViewBackgroundColor()
        configureUnderlyingViews()
        configureOverlayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButtons()
        registerFullLifecycleNotifications()
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            if profile.id != loggedInUserProfile.id {
                CircleCache.recordProfileVisit(profile)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the container size. Should account for the width of all the detailViews as well as the height of the navigation bar. We don't want the overlay view to scroll vertically, so we need to ensure its vertical content size matches the visible screen. This allows the collection views to take over vertically.
        if firstLoad {
            let containerSize = CGSizeMake(CGFloat(detailViews.count ?? 1) * view.frame.width, view.frame.height)
            underlyingContainerView.autoSetDimensionsToSize(containerSize)
            firstLoad = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // The ProfileOverlaidCollectionView needs to have the same height as the max of the detailViews. Otherwise, the contentOffset gets reset to zero when we push child view controllers.
        var maxHeight: CGFloat = 0
        for detailView in detailViews {
            if detailView.contentSize.height > maxHeight {
                maxHeight = detailView.contentSize.height
            }
        }
        (overlaidCollectionView as? ProfileOverlaidCollectionView)?.matchContentHeight(maxHeight)
        
        // When data is cached, it is possible to have it loaded before we even have the chance to
        // register for notifications
        updateNotesTitle(nil)
    }
    
    // MARK: - Configurations
    
    private func configureNavigationButtons() {
        if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
            let editButtonItem = UIBarButtonItem(
                image: UIImage(named: "Pencil"),
                style: .Plain,
                target: self,
                action: "editProfileButtonTapped:"
            )
            
            var rightBarButtonItems = [UIBarButtonItem]()
            if navigationItem.rightBarButtonItem != nil {
                rightBarButtonItems.append(navigationItem.rightBarButtonItem!)
            }

            rightBarButtonItems.append(editButtonItem)
            navigationItem.rightBarButtonItems = rightBarButtonItems
        }
    }

    private func configureOverlayView() {
        view.addSubview(overlaidCollectionView)
        overlaidCollectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureUnderlyingViews() {
        underlyingContainerView = UIView.newAutoLayoutView()
        
        // Attach the detailViews to the overlayContainerView
        var previous: UIView?
        for detailView in detailViews {
            underlyingContainerView.addSubview(detailView)
            // Views should be aligned left to right
            if previous == nil {
                detailView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Right)
            } else {
                detailView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Left)
                detailView.autoPinEdge(.Left, toEdge: .Right, ofView: previous!)
            }
            detailView.autoSetDimension(.Width, toSize: view.frame.width)
            detailView.externalScrollDelegate = self
            detailView.layer.borderWidth = 0.0
            detailView.layer.borderColor = UIColor.appDetailViewBorderColor().CGColor
            previous = detailView
        }
        
        underlyingScrollView = UIScrollView.newAutoLayoutView()
        underlyingScrollView.pagingEnabled = true
        underlyingScrollView.alwaysBounceVertical = false
        underlyingScrollView.showsHorizontalScrollIndicator = false
        underlyingScrollView.delegate = self
        
        // Attach the overlayContainerView to the overlayScrollView
        underlyingScrollView.addSubview(underlyingContainerView)
        underlyingContainerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        // Attach the overlayScrollView to the main view
        view.addSubview(underlyingScrollView)
        underlyingScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - UnderlyingCollectionViewDelegate
    
    func underlyingCollectionViewDidChangeContentOffset(collectionView: UICollectionView, offset: CGFloat) {
        // Only update the overlaidCollectionView if the content offset changed for the current underlying view
        if collectionView == detailViews[currentIndex] {
            overlaidCollectionView.contentOffset = CGPointMake(0, collectionView.contentOffset.y)
        }
    }
    
    func underlyingCollectionViewDidEndScrolling(collectionView: UICollectionView) {
        // Update the content offset of the other detail views to match the current one.
        // We will only alter the content offset if it is greater than the stickySectionHeight.
        var offset = collectionView.contentOffset.y
        if let layout = overlaidCollectionView.collectionViewLayout as? StickyHeaderCollectionViewLayout {
            let maxOffset = (layout.headerHeight - layout.stickySectionHeight)
            if collectionView.contentOffset.y > maxOffset {
                offset = maxOffset
            }
            for (index, detailView) in enumerate(detailViews) {
                if index != currentIndex {
                    detailView.contentOffset = CGPointMake(0, offset)
                }
            }
        }
    }
    
    func underlyingCollectionViewDidSelectItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        if let dataSource = collectionView.dataSource as? CardDataSource {
            if let card = dataSource.cardAtSection(indexPath.section) {
                if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
                    switch card.type {
                    case .Profiles:
                        let data: AnyObject? = dataSource.contentAtIndexPath(indexPath)
                        if data is Services.Organization.Containers.TeamV1 {
                            onTeamTapped(nil)
                        }
                        else if data is Services.Organization.Containers.LocationV1 {
                            onOfficeTapped(nil)
                        }
                        else if data is Services.Profile.Containers.ProfileV1 {
                            onManagerTapped(nil)
                        }
                        
                    default:
                        break
                    }
                }
                else if let dataSource = collectionView.dataSource as? ProfileNotesDataSource {
                    handleNotesCardSelection(card, indexPath: indexPath)
                }
            }
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    private func handleNotesCardSelection(card: Card, indexPath: NSIndexPath) {
        var note: Services.Note.Containers.NoteV1?
        switch card.type {
        case .Notes:
            note = card.content[indexPath.row] as? Services.Note.Containers.NoteV1
        default:
            break
        }
        
        if note == nil {
            trackNewNoteAction()
        } else {
            trackViewNoteAction(note!)
        }
        presentNoteView(note)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let headerView = profileHeaderView() {
            headerView.beginMovingSectionIndicatorView(scrollView.contentOffset)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= view.frame.width {
            navigationController?.interactivePopGestureRecognizer.enabled = false
        } else {
            navigationController?.interactivePopGestureRecognizer.enabled = true
        }
        
        // Calculate new index based on direction and add border width
        var newIndex: Int = currentIndex
        newIndex +=  (scrollView.contentOffset.x > (view.frame.width * CGFloat(currentIndex)) ? 1 : -1)
        if newIndex >= 0 && detailViews.count > newIndex {
            detailViews[newIndex].layer.borderWidth = 0.5
        }

        if let headerView = profileHeaderView() {
            headerView.updateSectionIndicatorView(scrollView.contentOffset)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingEnded(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollingEnded(scrollView)
    }

    private func scrollingEnded(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(view.frame.width)
        hideAllBorders()
        if let headerView = profileHeaderView() {
            headerView.finishMovingSelectionIndicatorView(scrollView.contentOffset)
        }
    }
    
    // MARK: - Notifications
    
    override func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateNotesTitle:",
            name: ProfileNotesNotifications.onNotesChanged,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "socialConnectCTATapped:",
            name: SocialConnectCollectionViewCellNotifications.onCTATappedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "quickActionButtonTapped:",
            name: QuickActionNotifications.onQuickActionStarted,
            object: nil
        )

        super.registerNotifications()
    }
    
    private func registerFullLifecycleNotifications() {
        // Do not un-register this notification in viewDidDisappear
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "socialServiceConnectNotification:",
            name: SocialConnectNotifications.onServiceConnectedNotification,
            object: nil
        )
    }
    
    override func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: ProfileNotesNotifications.onNotesChanged,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: SocialConnectCollectionViewCellNotifications.onCTATappedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: QuickActionNotifications.onQuickActionStarted,
            object: nil
        )

        super.unregisterNotifications()
    }
    
    // MARK: - NewNoteViewControllerDelegate
    
    func didAddNote(note: Services.Note.Containers.NoteV1) {
        let notesCollectionView = detailViews[1]
        if let dataSource = notesCollectionView.dataSource as? ProfileNotesDataSource {
            dataSource.addNote(note)
            notesCollectionView.reloadData()
            updateNotesTitle(nil)
            resetContentOffsetForDetailViews()
        }
    }
    
    func didDeleteNote(note: Services.Note.Containers.NoteV1) {
        let notesCollectionView = detailViews[1]
        if let dataSource = notesCollectionView.dataSource as? ProfileNotesDataSource {
            dataSource.removeNote(note)
            updateNotesTitle(nil)
            notesCollectionView.reloadData()
        }
    }
    
    // MARK: - Notification handlers
    
    func updateNotesTitle(sender: AnyObject?) {
        let notesCollectionView = detailViews[1]
        if let dataSource = notesCollectionView.dataSource as? ProfileNotesDataSource {
            if dataSource.notes.count == 0 {
                profileHeaderView()?.updateTitle(
                    NSLocalizedString("Notes", comment: "Title of the Notes section"),
                    forSegmentAtIndex: 1
                )
            }
            else {
                profileHeaderView()?.updateTitle(
                    NSString(format: NSLocalizedString("Notes (%d)", comment: "Title of the Notes section with # of notes. E.g., Notes (5)"), dataSource.notes.count),
                    forSegmentAtIndex: 1
                )
            }
        }
    }
    
    func socialConnectCTATapped(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let typeOfCTA = userInfo["type"] as? Int {
                if let contentType = ContentType(rawValue: typeOfCTA) {
                    switch contentType {
                    case .LinkedInConnect:
                        let socialConnectVC = SocialConnectViewController(provider: .Linkedin)
                        navigationController?.presentViewController(socialConnectVC, animated: true, completion:nil)

                    default:
                        break
                    }
                }
            }
        }
    }
    
    func quickActionButtonTapped(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let quickAction = userInfo[QuickActionNotifications.QuickActionTypeUserInfoKey] as? Int {
                if let quickActionType = QuickAction(rawValue: quickAction) {
                    performQuickAction(quickActionType)
                }
            }
        }
    }
    
    func socialServiceConnectNotification(notification: NSNotification) {
        reloadInfoCollectionViewData()
    }
    
    private func performQuickAction(quickAction: QuickAction, additionalData: AnyObject? = nil) {
        switch quickAction {
        case .Email:
            if let email = profile.getEmail() {
                presentMailViewController(
                    [email],
                    subject: "Hey",
                    messageBody: "",
                    completionHandler: nil
                )
            }
            
        case .Message:
            var recipient: String?
            if let phone = profile.getCellPhone() {
                recipient = phone
            } else if let email = profile.getEmail() {
                recipient = email
            }
            if recipient != nil {
                presentMessageViewController(
                    [recipient!],
                    subject: "Hey",
                    messageBody: "",
                    completionHandler: nil
                )
            }
            
        case .Phone:
            if let number = profile.getCellPhone() as String? {
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", number.removePhoneNumberFormatting())) {
                    UIApplication.sharedApplication().openURL(phoneURL)
                }
            }
            
        case .MoreInfo:
            let contactInfoViewController = ContactInfoViewController()
            contactInfoViewController.profile = profile
            contactInfoViewController.shouldBlurBackground = false
            contactInfoViewController.addCancelButton = true
            contactInfoViewController.modalPresentationStyle = .Custom
            contactInfoViewController.transitioningDelegate = contactInfoViewController
            presentViewController(contactInfoViewController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func onManagerTapped(notification: NSNotification?) {
        let profileInfoCollectionView = detailViews[0]
        if let dataSource = profileInfoCollectionView.dataSource as? ProfileDetailDataSource {
            let profileVC = ProfileDetailsViewController.forProfile(dataSource.manager!)
            profileVC.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func onOfficeTapped(notification: NSNotification?) {
        let profileInfoCollectionView = detailViews[0]
        if let dataSource = profileInfoCollectionView.dataSource as? ProfileDetailDataSource {
            let officeDetailVC = OfficeDetailViewController()
            (officeDetailVC.dataSource as OfficeDetailDataSource).selectedOffice = dataSource.location
            officeDetailVC.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(officeDetailVC, animated: true)
        }
    }
    
    func onTeamTapped(notification: NSNotification?) {
        let profileInfoCollectionView = detailViews[0]
        if let dataSource = profileInfoCollectionView.dataSource as? ProfileDetailDataSource {
            let teamVC = TeamDetailViewController()
            (teamVC.dataSource as TeamDetailDataSource).selectedTeam = dataSource.team!
            teamVC.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(teamVC, animated: true)
        }
    }
    
    // MARK: - Helpers
    
    private func presentNoteView(note: Services.Note.Containers.NoteV1?) {
        let newNoteViewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
        newNoteViewController.profile = profile
        newNoteViewController.delegate = self
        newNoteViewController.note = note
        let navController = UINavigationController(rootViewController: newNoteViewController)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
    }
    
    private func addLogOutButton() {
        if navigationItem.rightBarButtonItem == nil {
            let logOutButton = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOutTapped:")
            navigationItem.rightBarButtonItem = logOutButton
        }
    }

    private func profileHeaderView() -> ProfileHeaderCollectionReusableView? {
        return (overlaidCollectionView.dataSource as? ProfileOverlaidCollectionViewDataSource)?.profileHeaderView
    }
    
    private func hideAllBorders() {
        detailViews.map { ($0 as UIView).layer.borderWidth = 0.0 }
    }
    
    private func resetContentOffsetForDetailViews() {
        detailViews.map({ $0.setContentOffset(CGPointZero, animated: false) })
    }
    
    private func isPersonalNote() -> Bool {
        if let profile = profile {
            if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
                return true
            }
        }
        return false
    }
    
    private func reloadInfoCollectionViewData() {
        let profileInfoCollectionView = detailViews[0]
        if let dataSource = profileInfoCollectionView.dataSource as? ProfileDetailDataSource {
            dataSource.profile = profile
            dataSource.loadData({ (error) -> Void in
                profileInfoCollectionView.reloadData()
            })
        }
    }
    
    // Class Methods
    
    class func forProfile(
        profile: Services.Profile.Containers.ProfileV1,
        showLogOutButton: Bool = false,
        showCloseButton: Bool = false,
        showSettingsButton: Bool = false
    ) -> ProfileDetailsViewController {
        return ProfileDetailsViewController(
            profile: profile,
            detailViews: [
                ProfileInfoCollectionView(profile: profile),
                ProfileNotesCollectionView(profile: profile)
            ],
            overlaidCollectionView: ProfileOverlaidCollectionView(
                profile: profile,
                sections: [
                    ProfileDetailView(title: NSLocalizedString("Info", comment: "Title of the Info section"), image: "Info"),
                    ProfileDetailView(title: NSLocalizedString("Notes", comment: "Title of the Notes section"), image: "Notepad")
                ]
            ),
            showLogOutButton: showLogOutButton,
            showCloseButton: showCloseButton,
            showSettingsButton: showSettingsButton
        )
    }
    
    // MARK: - ProfileDetailSegmentedControlDelegate
    
    func onButtonTouchUpInsideAtIndex(index: Int) {
        underlyingScrollView.setContentOffset(CGPointMake(view.frame.width * CGFloat(index), underlyingScrollView.contentOffset.y), animated: true)
        // We need to delay calling the method that updates the internal state
        // to ensure the animations have been completed
        // 0.3 is the standard animation speed on iOS at this time
        delay(0.3, { () -> () in
            self.scrollingEnded(self.underlyingScrollView)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func editProfileButtonTapped(sender: AnyObject!) {
        let editProfileVC = EditContactInfoViewController(nibName: "EditContactInfoViewController", bundle: nil)
        editProfileVC.profile = profile
        editProfileVC.editProfileDelegate = self
        editProfileVC.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func logOutTapped(sender: AnyObject!) {
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(false, completion: { () -> Void in
                AuthViewController.logOut()
            })
        }
        else {
            AuthViewController.logOut()
        }
    }

    @IBAction func settingsButtonTapped(sender: AnyObject!) {
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        presentViewController(settingsNavController, animated: true, completion: nil)
    }
    
    @IBAction func profileLongPressHandler(sender: AnyObject!) {
        let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
        let onboardingNavigationController = UINavigationController(rootViewController: verifyPhoneNumberVC)
        navigationController?.presentViewController(onboardingNavigationController, animated: true, completion: nil)
    }
    
    // MARK: - Tracking
    
    private func trackNewNoteAction() {
        let properties = getTrackingProperties(nil)
        Tracker.sharedInstance.track(.NewNote, properties: properties)
    }
    
    private func trackViewNoteAction(note: Services.Note.Containers.NoteV1) {
        let properties = getTrackingProperties(note)
        Tracker.sharedInstance.track(.ViewNote, properties: properties)
    }
    
    private func getTrackingProperties(note: Services.Note.Containers.NoteV1?) -> [TrackerProperty] {
        var properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withDestinationId("profileId").withString(profile.id),
            TrackerProperty.withKey(.Source).withSource(.Detail),
            TrackerProperty.withKey(.SourceDetailType).withDetailType(.Profile),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Note),
            TrackerProperty.withKeyString("personal_note").withValue(isPersonalNote())
        ]
        if let note = note {
            properties.append(TrackerProperty.withDestinationId("note_id").withString(note.id))
        }
        return properties
    }
    
    // MARK: - EditProfileDelegate
    
    func didFinishEditingProfile() {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            if profile.id == loggedInUserProfile.id {
                profile = loggedInUserProfile
                reloadInfoCollectionViewData()
                
                if let headerView = profileHeaderView() {
                    headerView.setProfile(profile)
                }
            }
        }
    }
    
}
