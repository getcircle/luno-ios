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
    CardFooterViewDelegate
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
        
        if let loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile() {
            if profile.id != loggedInUserProfile.id {
                CircleCache.recordProfileVisit(profile)
            }
        }
        
        Tracker.sharedInstance.trackPageView(pageType: .ProfileDetail, pageId: profile.id)
    }
        
    // MARK: - Configuration
    
    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        dataSource.cardFooterDelegate = self
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

                    case .Profiles:
                        let data: AnyObject? = dataSource.contentAtIndexPath(indexPath)
                        if let team = data as? Services.Organization.Containers.TeamV1 {
                            showTeamDetail(team)
                        }
                        else if let location = data as? Services.Organization.Containers.LocationV1 {
                            showLocationDetail(location)
                        }
                        else if let profile = data as? Services.Profile.Containers.ProfileV1 {
                            showProfileDetail(profile)
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
            Tracker.sharedInstance.trackContactTap(
                .Email,
                contactProfile: profile,
                contactLocation: .ProfileDetail
            )
            presentMailViewController(
                [contactMethod.value],
                subject: "",
                messageBody: "",
                completionHandler: nil
            )

        case .CellPhone:
            if let number = profile.getCellPhone() as String? {
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", number.removePhoneNumberFormatting()) as String) {
                    Tracker.sharedInstance.trackContactTap(
                        .Call,
                        contactProfile: profile,
                        contactLocation: .ProfileDetail
                    )
                    UIApplication.sharedApplication().openURL(phoneURL)
                }
            }
            
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
    
    // MARK: - CardFooterDelegate
    
    func cardFooterTapped(card: Card!) {
        var content: Array<Services.Profile.Containers.ProfileV1>?
        var title: String?
        let profileDetailDataSource = dataSource as! ProfileDetailDataSource
        var pageType: TrackerProperty.PageType?
        var attributeId: String?
        
        switch card.subType {
        case .Teams:
            if let peers = profileDetailDataSource.peers {
                content = peers
                title = profileDetailDataSource.profile.firstName + "'s Peers"
                pageType = .Peers
                attributeId = profileDetailDataSource.team?.id
            }
            
        case .ManagedTeams:
            if let directReports = profileDetailDataSource.directReports {
                content = directReports
                title = profileDetailDataSource.profile.firstName + "'s Direct Reports"
                pageType = .DirectReports
                attributeId = profileDetailDataSource.managesTeam?.id
            }

        default:
            break
        }
        
        do {
            if let content = content, title = title, pageType = pageType, attributeId = attributeId {
                let viewController = ProfilesViewController()
                viewController.pageType = pageType
                (viewController.dataSource as! ProfilesDataSource).searchLocation = .Modal
                viewController.dataSource.setInitialData(
                    content: content,
                    ofType: nil,
                    nextRequest: nil
                )
                try (viewController.dataSource as! ProfilesDataSource).configureForTeam(
                    attributeId,
                    setupOnlySearch: true
                )
                viewController.title = title
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
    
}
