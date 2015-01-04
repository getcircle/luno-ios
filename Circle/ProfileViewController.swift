//
//  ProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, UIViewControllerTransitioningDelegate {

    var person: Person! {
        didSet {
            // Manager object may not be fully inflated
            // Fetch and cache it in case user decides to go one step further in the chain
            person.manager?.fetchInBackgroundWithBlock { (managerObject, error: NSError!) -> Void in
                self.person.setObject(managerObject, forKey: "manager")
                self.collectionView!.reloadData()
            }
            
            dataSource.person = person
            collectionView!.reloadData()
        }
    }

    
    var animationSourceRect: CGRect?
    private var dataSource = ProfileDataSource()
    var showLogOutButton: Bool? {
        didSet {
            addLogOutButton()
        }
    }
    var showCloseOrBackButton: Bool? {
        didSet {
            addCloseOrBackButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isBeingPresentedModally() {
            navigationController?.navigationBar.makeTransparent()
        }
        else {
            transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                return
            }, completion: { (transitionContext) -> Void in
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                    self.navigationController?.navigationBar.makeTransparent()
                    return
            })
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Do not show the opaque bar again if:
        // a. this view was presented modally
        // b. this view is being dismissed vs disappearing because another view controller was added to the stack
        // c. the view controller prior to this one was a ProfileViewController
        if !isBeingPresentedModally() && isMovingFromParentViewController() {
            if let totalViewControllers = navigationController?.viewControllers.count {
                let parentController = navigationController?.viewControllers[(totalViewControllers - 1)] as? UIViewController
                if !(parentController is ProfileViewController) {
                    transitionCoordinator()?.animateAlongsideTransition({ (transitionContext) -> Void in
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
                        toViewController.navigationController?.navigationBar.makeOpaque()
                        
                        return
                    }, completion: nil)
                }
            }
        }
    }
    
    private func addLogOutButton() {
        if showLogOutButton == true && navigationItem.rightBarButtonItem == nil {
            let logOutButton = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOutTapped:")
            navigationItem.rightBarButtonItem = logOutButton
        }
    }
    
    func logOutTapped(sender: AnyObject!) {
        AuthViewController.logOut()
    }
    
    private func addCloseOrBackButton() {
        if showCloseOrBackButton == true && navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(
                image: isBeingPresentedModally() ? UIImage(named: "Down") : UIImage(named: "Previous"),
                style: .Plain,
                target: self,
                action: "closeOrBackButtonTapped:"
            )
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    func closeOrBackButtonTapped(sender: AnyObject!) {
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.registerNib(
            UINib(nibName: "KeyValueCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: KeyValueCollectionViewCell.classReuseIdentifier
        )

        collectionView!.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )

        collectionView!.dataSource = dataSource
    }
    
    // MARK: Collection View delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .Manager:
            let profileVC = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            profileVC.person = person.manager
            navigationController?.pushViewController(profileVC, animated: true)

        case .Email:
            presentMailViewController([person.email], subject: "Hey", messageBody: "")
            
        default:
            break
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Layout delegate
    
    // This has to be implemented as a delegate method because the layout can only
    // set it for all headers
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(collectionView.frame.size.width, ProfileCollectionViewLayout.profileHeaderHeight)
        }
        
        return CGSizeZero
    }
    
    // MARK: - Scroll view delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let profileHeaderView = dataSource.profileHeaderView {
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
                profileHeaderView.nameLabel.alpha = 1.0
                profileHeaderView.nameNavLabel.alpha = 0.0
                profileHeaderView.titleLabel.alpha = 1.0
                profileHeaderView.profileImage.alpha = 1.0
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
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

    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Transitioning Delegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ProfileViewAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ProfileViewAnimator()
    }
}

