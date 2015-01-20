//
//  ProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailViewController: DetailViewController, NewNoteViewControllerDelegate {

    var profile: ProfileService.Containers.Profile!
    
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        registerNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = ProfileDetailDataSource()
        delegate = ProfileCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        (dataSource as ProfileDetailDataSource).profile = profile

        // Delegate
        collectionView.delegate = delegate
        
        layout.headerHeight = ProfileHeaderCollectionReusableView.height
        
        // Gestures
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeGestureRecognizer?.direction = .Left
        collectionView.addGestureRecognizer(swipeGestureRecognizer!)
        
        super.configureCollectionView()
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
        case .Manager:
            let profileVC = ProfileDetailViewController()
            profileVC.profile = dataSource.manager
            navigationController?.pushViewController(profileVC, animated: true)
            
        case .Email:
            presentMailViewController([profile.email], subject: "Hey", messageBody: "")
            
        default:
            break
        }
    }
    
    private func handleNotesCardSelection(card: Card, indexPath: NSIndexPath) {
        if let note = card.content[indexPath.row] as? NoteService.Containers.Note {
            presentNoteView(note)
        }
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let profileHeaderView = (collectionView!.dataSource as ProfileDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            let minOffsetToMakeChanges: CGFloat = 20.0
            
            // Do not change anything unless user scrolls up more than 20 points
            if contentOffset.y > minOffsetToMakeChanges {
                
                // Scale down the image and reduce opacity
                let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileHeaderView.profileImage.frameY
                profileHeaderView.profileImage.alpha = profileImageFractionValue
                if profileImageFractionValue >= 0 {
                    var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                    profileHeaderView.profileImage.transform = transform
                }
                
                // Reduce opacity of the name and title label at a faster pace
                let titleLabelAlpha = 1.0 - contentOffset.y/(profileHeaderView.titleLabel.frameY - 40.0)
                profileHeaderView.titleLabel.alpha = titleLabelAlpha
                profileHeaderView.nameLabel.alpha = 1.0 - contentOffset.y/(profileHeaderView.nameLabel.frameY - 40.0)
                profileHeaderView.nameNavLabel.alpha = titleLabelAlpha <= 0.0 ? profileHeaderView.nameNavLabel.alpha + 1/20 : 0.0
            }
            else {
                // Change alpha faster for profile image
                let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
                
                // Change it slower for everything else
                let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
                profileHeaderView.nameLabel.alpha = otherViewsAlpha
                profileHeaderView.nameNavLabel.alpha = 0.0
                profileHeaderView.titleLabel.alpha = otherViewsAlpha
                profileHeaderView.profileImage.alpha = profileImageAlpha
                profileHeaderView.visualEffectView.alpha = otherViewsAlpha
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
        }
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
            selector: "addNote:",
            name: NotesCardHeaderCollectionReusableViewNotifications.onAddNoteNotification,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didSelectTag(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["tag"] as? ProfileService.Containers.Tag {
                let viewController = TagDetailViewController()
                (viewController.dataSource as TagDetailDataSource).selectedTag = selectedTag
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - NotesCardHeaderViewDelegate
    
    func addNote(sender: AnyObject!) {
        presentNoteView(nil)
    }
    
    // MARK: - NewNoteViewControllerDelegate
    
    func didAddNote(note: NoteService.Containers.Note) {
        if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
            dataSource.addNote(note)
            collectionView.reloadData()
        }
    }
    
    func didDeleteNote(note: NoteService.Containers.Note) {
        if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
            dataSource.removeNote(note)
            collectionView.reloadData()
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
    
    // MARK: - Gesture recognizers
    
    func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        println("swiping: \(sender)")
    }
    
}
