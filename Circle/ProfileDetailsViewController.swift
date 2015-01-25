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
        MFMailComposeViewControllerDelegate
    {
    
    // Segmented Control Helpers
    private var currentIndex = 0
    
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
        showLogOutButton: Bool,
        showCloseButton: Bool
    ) {
        self.init(showCloseButton: showCloseButton)
        profile = withProfile
        detailViews = withDetailViews
        overlaidCollectionView = withOverlaidCollectionView
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
    
    private func configureOverlayView() {
        view.addSubview(overlaidCollectionView)
        overlaidCollectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureUnderlyingViews() {
        underlyingContainerView = UIView.newAutoLayoutView()
        // Get the container size. Should account for the width of all the detailViews as well as the height of the navigation bar. We don't want the overlay view to scroll vertically, so we need to ensure its vertical content size matches the visible screen. This allows the collection views to take over vertically.
        let containerSize = CGSizeMake(CGFloat(detailViews.count ?? 1) * view.frame.width, view.frame.height)
        underlyingContainerView.autoSetDimensionsToSize(containerSize)
        
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
            println("offset \(collectionView.contentOffset.y) - sectionHeight: \(layout.stickySectionHeight)")
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
        let dataSource = collectionView.dataSource as ProfileDetailDataSource
        if let card = dataSource.cardAtSection(indexPath.section) {
            switch card.type {
            case .KeyValue:
                handleKeyValueCardSelection(dataSource, indexPath: indexPath)
            case .Notes:
                handleNotesCardSelection(card, indexPath: indexPath)
            default:
                break
            }
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    private func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .Email:
            presentMailViewController([profile.email], subject: "Hey", messageBody: "", completionHandler: nil)
            
        case .Manager:
            let profileVC = ProfileDetailViewController()
            profileVC.profile = dataSource.manager
            navigationController?.pushViewController(profileVC, animated: true)
            
        case .Team:
            let teamVC = TeamDetailViewController()
            (teamVC.dataSource as TeamDetailDataSource).selectedTeam = dataSource.team!
            navigationController?.pushViewController(teamVC, animated: true)
            
        default:
            break
        }
    }
    
    private func handleNotesCardSelection(card: Card, indexPath: NSIndexPath) {
        if let note = card.content[indexPath.row] as? NoteService.Containers.Note {
            //            presentNoteView(note)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > view.frame.width {
            navigationController?.interactivePopGestureRecognizer.enabled = false
        } else {
            navigationController?.interactivePopGestureRecognizer.enabled = true
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
    
//    override func registerNotifications() {
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: "addNote:",
//            name: NotesCardHeaderCollectionReusableViewNotifications.onAddNoteNotification,
//            object: nil
//        )
//        super.registerNotifications()
//    }
//    
//    // MARK: - NotesCardHeaderViewDelegate
//    
//    func addNote(sender: AnyObject!) {
//        presentNoteView(nil)
//    }
    
    // MARK: - NewNoteViewControllerDelegate
    
//    func didAddNote(note: NoteService.Containers.Note) {
//        if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
//            dataSource.addNote(note)
//            collectionView.reloadData()
//        }
//    }
//    
//    func didDeleteNote(note: NoteService.Containers.Note) {
//        if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
//            dataSource.removeNote(note)
//            collectionView.reloadData()
//        }
//    }
    
    // MARK: - Helpers
    
//    private func presentNoteView(note: NoteService.Containers.Note?) {
//        let newNoteViewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
//        newNoteViewController.profile = profile
//        newNoteViewController.delegate = self
//        newNoteViewController.note = note
//        let navController = UINavigationController(rootViewController: newNoteViewController)
//        navigationController?.presentViewController(navController, animated: true, completion: nil)
//    }
    
    private func addLogOutButton() {
        if navigationItem.rightBarButtonItem == nil {
            let logOutButton = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOutTapped:")
            navigationItem.rightBarButtonItem = logOutButton
        }
    }
    
    func logOutTapped(sender: AnyObject!) {
        AuthViewController.logOut()
    }

    private func profileHeaderView() -> ProfileHeaderCollectionReusableView? {
        return (overlaidCollectionView.dataSource as? ProfileOverlaidCollectionViewDataSource)?.profileHeaderView
    }
}
