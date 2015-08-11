//
//  ProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailViewController:
    DetailViewController,
    CardHeaderViewDelegate
{

    var profile: Services.Profile.Containers.ProfileV1!
    
    // this is recorded only to maintain state and guarantee one time addition of
    // the gesture recognizer
    private var profileImageTapGestureRecognizer: UITapGestureRecognizer?
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
        dataSource = ProfileDetailDataSource(profile: profile)
        delegate = CardCollectionViewDelegate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            if profile.id != loggedInUserProfile.id {
                CircleCache.recordProfileVisit(profile)
            }
        }
    }
        
    // MARK: - Configuration
    
    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        
        collectionView.delegate = delegate
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.height
        super.configureCollectionView()
    }

    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let dataSource = collectionView.dataSource as? CardDataSource {
            if let card = dataSource.cardAtSection(indexPath.section) {
                if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
                    switch card.type {
                    case .ContactMethods:
                        if let contactMethod = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ContactMethodV1 {
                            performQuickAction(contactMethod)
                        }
                        
                    case .KeyValue:
                        handleKeyValueCardSelection(dataSource, indexPath: indexPath)
                        
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
                    
                    case .Group:
                        if let group = dataSource.contentAtIndexPath(indexPath) as? Services.Group.Containers.GroupV1 {
                            let groupDetailVC = GroupDetailViewController()
                            (groupDetailVC.dataSource as! GroupDetailDataSource).selectedGroup = group
                            navigationController?.pushViewController(groupDetailVC, animated: true)
                        }
                        
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func collectionView(
        collectionView: UICollectionView, 
        didEndDisplayingSupplementaryView view: UICollectionReusableView, 
        forElementOfKind elementKind: String, 
        atIndexPath indexPath: NSIndexPath
    ) {
        if let profileHeaderView = (dataSource as! ProfileDetailDataSource).profileHeaderView {
            if profileImageTapGestureRecognizer == nil {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "profileImageTapped:")
                profileHeaderView.profileImage.addGestureRecognizer(tapGestureRecognizer)
                profileHeaderView.profileImage.userInteractionEnabled = true
                profileImageTapGestureRecognizer = tapGestureRecognizer

                let tapGestureRecognizerBackgroundView = UITapGestureRecognizer(target: self, action: "profileBackgroundImageTapped:")
                profileHeaderView.backgroundImageView.addGestureRecognizer(tapGestureRecognizerBackgroundView)
                profileHeaderView.backgroundImageView.userInteractionEnabled = true
            }
        }
    }
    
    internal func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .Groups:
            let groupsViewController = GroupsViewController()
            groupsViewController.title = AppStrings.ProfileSectionGroupsTitle
            groupsViewController.addSearchFilterView = false
            (groupsViewController.dataSource as! GroupsDataSource).profile = profile
            navigationController?.pushViewController(groupsViewController, animated: true)

        default:
            break
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (dataSource as! ProfileDetailDataSource).profileHeaderView {
            profileHeaderView.adjustViewForScrollContentOffset(scrollView.contentOffset)
        }
    }
    
    // MARK: - Notification handlers
    
    func reloadData() {
        if let dataSource = dataSource as? ProfileDetailDataSource {
            dataSource.profile = profile
            dataSource.loadData({ (error) -> Void in
                self.collectionView.reloadData()
            })
        }
    }
    
    private func performQuickAction(contactMethod: Services.Profile.Containers.ContactMethodV1) {
        switch contactMethod.contactMethodType {
        case .Email:
            presentMailViewController(
                [contactMethod.value],
                subject: "Hey",
                messageBody: "",
                completionHandler: nil
            )
            
//        case .Message:
//            var recipient: String?
//            if let phone = profile.getCellPhone() {
//                recipient = phone
//            } else if let email = profile.getEmail() {
//                recipient = email
//            }
//            if recipient != nil {
//                presentMessageViewController(
//                    [recipient!],
//                    subject: "Hey",
//                    messageBody: "",
//                    completionHandler: nil
//                )
//            }
            
        case .CellPhone:
            if let number = profile.getCellPhone() as String? {
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", number.removePhoneNumberFormatting()) as String) {
                    UIApplication.sharedApplication().openURL(phoneURL)
                }
            }
            
        default:
            break
        }
    }
    
    func onManagerTapped(notification: NSNotification?) {
        if let dataSource = dataSource as? ProfileDetailDataSource, manager = dataSource.manager {
            showProfileDetail(manager)
        }
    }
    
    func onOfficeTapped(notification: NSNotification?) {
        if let dataSource = dataSource as? ProfileDetailDataSource, location = dataSource.location {
            showLocationDetail(location)
        }
    }
    
    func onTeamTapped(notification: NSNotification?) {
        if let dataSource = dataSource as? ProfileDetailDataSource, team = dataSource.team {
            showTeamDetail(team)
        }
    }

    // MARK: - EditProfileDelegate
    
    func didFinishEditingProfile() {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            if profile.id == loggedInUserProfile.id {
                profile = loggedInUserProfile
                reloadData()
            }
        }
    }
    
    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        switch card.type {
        default:
            break
        }
    }
    
    // MARK: - Gesture Recognizers
    
    func profileImageTapped(recognizer: UIGestureRecognizer) {
        collectionView.setContentOffset(CGPointMake(0.0, -(collectionView.frameHeight * 0.33)), animated: true)
    }
    
    func profileBackgroundImageTapped(recognizer: UIGestureRecognizer) {
        collectionView.setContentOffset(CGPointZero, animated: true)
    }
}
