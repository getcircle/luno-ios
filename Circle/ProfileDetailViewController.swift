//
//  ProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailViewController: DetailViewController,
    CardFooterViewDelegate
{

    var profile: ProfileService.Containers.Profile!
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
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
        dataSource.cardFooterDelegate = self
        
        collectionView.delegate = delegate
        (layout as StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.height
        super.configureCollectionView()
    }

    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let dataSource = collectionView.dataSource as? CardDataSource {
            if let card = dataSource.cardAtSection(indexPath.section) {
                if let dataSource = collectionView.dataSource as? ProfileDetailDataSource {
                    switch card.type {
                    case .KeyValue:
                        handleKeyValueCardSelection(dataSource, indexPath: indexPath)
                        
                    case .Profiles:
                        let data: AnyObject? = dataSource.contentAtIndexPath(indexPath)
                        if data is OrganizationService.Containers.Team {
                            onTeamTapped(nil)
                        }
                        else if data is OrganizationService.Containers.Location {
                            onOfficeTapped(nil)
                        }
                        else if data is ProfileService.Containers.Profile {
                            onManagerTapped(nil)
                        }
                        
                    default:
                        break
                    }
                }
            }
        }
    }
    
    internal func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .CellPhone:
            if let phone = profile.getCellPhone() {
                performQuickAction(.Phone, additionalData: phone)
            }
            
        case .Email:
            performQuickAction(.Email)
            
        case .WorkPhone:
            if let phone = profile.getCellPhone() {
                performQuickAction(.Phone, additionalData: phone)
            }
            
        default:
            break
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (dataSource as ProfileDetailDataSource).profileHeaderView {
            profileHeaderView.adjustViewForScrollContentOffset(scrollView.contentOffset)
        }
    }
    
    
    // MARK: - CardFooterViewDelegate
    
    func cardFooterTapped(card: Card!) {
        card.toggleShowingFullContent()
        collectionView.reloadSections(NSIndexSet(index: card.cardIndex))
    }
    
    // MARK: - Notifications
    
    override func registerNotifications() {

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "quickActionButtonTapped:",
            name: QuickActionNotifications.onQuickActionStarted,
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "bannerCTATapped:",
            name: BannerNotifications.onBannerCTATappedNotification,
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "bannerCloseTapped:",
            name: BannerNotifications.onBannerCloseTappedNotification,
            object: nil
        )

        super.registerNotifications()
    }
    
    override func unregisterNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: QuickActionNotifications.onQuickActionStarted,
            object: nil
        )

        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: BannerNotifications.onBannerCTATappedNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: BannerNotifications.onBannerCloseTappedNotification,
            object: nil
        )
        
        super.unregisterNotifications()
    }
    
    // MARK: - Notification handlers
    
    func quickActionButtonTapped(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let quickAction = userInfo[QuickActionNotifications.QuickActionTypeUserInfoKey] as? Int {
                if let quickActionType = QuickAction(rawValue: quickAction) {
                    performQuickAction(quickActionType)
                }
            }
        }
    }

    func bannerCTATapped(notification: NSNotification) {
        (dataSource as ProfileDetailDataSource).addBannerOfType = nil
        reloadData()
    }

    func bannerCloseTapped(notification: NSNotification) {
        (dataSource as ProfileDetailDataSource).addBannerOfType = nil
        reloadData()
    }

    func reloadData() {
        if let dataSource = dataSource as? ProfileDetailDataSource {
            dataSource.profile = profile
            dataSource.loadData({ (error) -> Void in
                self.collectionView.reloadData()
            })
        }
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
        if let dataSource = dataSource as? ProfileDetailDataSource {
            let profileVC = ProfileDetailViewController(profile: dataSource.manager!)
            profileVC.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func onOfficeTapped(notification: NSNotification?) {
        if let dataSource = dataSource as? ProfileDetailDataSource {
            let officeDetailVC = OfficeDetailViewController()
            (officeDetailVC.dataSource as OfficeDetailDataSource).selectedOffice = dataSource.location
            officeDetailVC.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(officeDetailVC, animated: true)
        }
    }
    
    func onTeamTapped(notification: NSNotification?) {
        if let dataSource = dataSource as? ProfileDetailDataSource {
            let teamVC = TeamDetailViewController()
            (teamVC.dataSource as TeamDetailDataSource).selectedTeam = dataSource.team!
            teamVC.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(teamVC, animated: true)
        }
    }

    // MARK: - Tracking
    
    private func trackNewNoteAction() {
        let properties = getTrackingProperties(nil)
        Tracker.sharedInstance.track(.NewNote, properties: properties)
    }
    
    private func trackViewNoteAction(note: NoteService.Containers.Note) {
        let properties = getTrackingProperties(note)
        Tracker.sharedInstance.track(.ViewNote, properties: properties)
    }
    
    private func getTrackingProperties(note: NoteService.Containers.Note?) -> [TrackerProperty] {
        var properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withDestinationId("profile_id").withString(profile.id),
            TrackerProperty.withKey(.Source).withSource(.Detail),
            TrackerProperty.withKey(.SourceDetailType).withDetailType(.Profile),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Note),
        ]

        return properties
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
}
