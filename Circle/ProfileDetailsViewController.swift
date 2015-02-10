//
//  ProfileDetailsViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit
import ProtobufRegistry

class ProfileDetailsViewController:
        BaseDetailViewController,
        UnderlyingCollectionViewDelegate,
        UIScrollViewDelegate,
        NewNoteViewControllerDelegate,
        MFMailComposeViewControllerDelegate,
        ProfileDetailSegmentedControlDelegate
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
    var profile: ProfileService.Containers.Profile!
    
    convenience init(
        profile withProfile: ProfileService.Containers.Profile,
        detailViews withDetailViews: [UnderlyingCollectionView],
        overlaidCollectionView withOverlaidCollectionView: UICollectionView,
        showLogOutButton: Bool = false,
        showCloseButton: Bool = false
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
        view.backgroundColor = UIColor.viewBackgroundColor()
        configureUnderlyingViews()
        configureOverlayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButtons()
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
            detailView.layer.borderColor = UIColor.detailViewBorderColor().CGColor
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
                    case .KeyValue:
                        handleKeyValueCardSelection(dataSource, indexPath: indexPath)
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
    
    private func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .Email:
            presentMailViewController([profile.email], subject: "Hey", messageBody: "", completionHandler: nil)
        
        case .Location:
            let locationDetailVC = LocationDetailViewController()
            (locationDetailVC.dataSource as LocationDetailDataSource).selectedLocation = dataSource.address
            locationDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(locationDetailVC, animated: true)
            
        case .Manager:
            let profileVC = ProfileDetailsViewController.forProfile(dataSource.manager!)
            profileVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(profileVC, animated: true)
            
        case .Team:
            let teamVC = TeamDetailViewController()
            (teamVC.dataSource as TeamDetailDataSource).selectedTeam = dataSource.team!
            teamVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(teamVC, animated: true)
        
        default:
            break
        }
    }
    
    private func handleNotesCardSelection(card: Card, indexPath: NSIndexPath) {
        var note: NoteService.Containers.Note?
        switch card.type {
        case .Notes:
            note = card.content[indexPath.row] as? NoteService.Containers.Note
        default:
            break
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

    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError!
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Notifications
    
    override func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "addNote:",
            name: NotesCardHeaderCollectionReusableViewNotifications.onAddNoteNotification,
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateNotesTitle:",
            name: ProfileNotesNotifications.onNotesChanged,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "socialConnectCTATapped:", 
            name: SocialConnectCollectionViewCellNotifications.onCTATappedNotification, 
            object: nil
        )
        
        super.registerNotifications()
    }
    
    // MARK: - NotesCardHeaderViewDelegate
    
    func addNote(sender: AnyObject!) {
        presentNoteView(nil)
    }
    
    // MARK: - NewNoteViewControllerDelegate
    
    func didAddNote(note: NoteService.Containers.Note) {
        let notesCollectionView = detailViews[1]
        if let dataSource = notesCollectionView.dataSource as? ProfileNotesDataSource {
            dataSource.addNote(note)
            notesCollectionView.reloadData()
            updateNotesTitle(nil)
            resetContentOffsetForDetailViews()
        }
    }
    
    func didDeleteNote(note: NoteService.Containers.Note) {
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
    
    // MARK: - Helpers
    
    private func presentNoteView(note: NoteService.Containers.Note?) {
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

    func logOutTapped(sender: AnyObject!) {
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(false, completion: { () -> Void in
                AuthViewController.logOut()
            })
        }
        else {
            AuthViewController.logOut()
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
    
    // Class Methods
    
    class func forProfile(
        profile: ProfileService.Containers.Profile,
        showLogOutButton: Bool = false,
        showCloseButton: Bool = false
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
            showCloseButton: showCloseButton
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
        let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        editProfileVC.profile = profile
        editProfileVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
