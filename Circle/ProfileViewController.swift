//
//  ProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate {

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

    private var dataSource = ProfileDataSource()
    var showLogOutButton: Bool? {
        didSet {
            addLogOutButton()
        }
    }
    var showCloseButton: Bool? {
        didSet {
            addCloseButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view, typically from a nib.
        customizeCollectionView()
        
        // Assert there is a person
        // assert(person != nil, "Person object needs to be set before loading this view.")
        collectionView!.dataSource = dataSource
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.makeTransparent()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if navigationController?.topViewController != self {
            navigationController?.navigationBar.makeOpaque()
        }
        super.viewWillDisappear(animated)
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
    
    private func addCloseButton() {
        if showCloseButton == true && navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(
                image: UIImage(named: "Down"),
                style: .Plain,
                target: self,
                action: "closeButtonTapped:"
            )

            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    func closeButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    private func customizeCollectionView() {
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.registerNib(
            UINib(nibName: "ProfileAttributeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: ProfileAttributeCollectionViewCell.classReuseIdentifier
        )

        collectionView!.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )
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
}

