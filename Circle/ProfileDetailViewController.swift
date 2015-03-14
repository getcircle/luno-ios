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
    CardHeaderViewDelegate,
    CardFooterViewDelegate
{

    var profile: ProfileService.Containers.Profile!
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
        dataSource = ProfileDetailDataSource(profile: profile)
        delegate = StickyHeaderCollectionViewDelegate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerFullLifecycleNotifications()
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            if profile.id != loggedInUserProfile.id {
                CircleCache.recordProfileVisit(profile)
            }
        }
    }
        
    // MARK: - Configuration
    
    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        dataSource.cardHeaderDelegate = self
        dataSource.cardFooterDelegate = self
        
        collectionView.delegate = delegate
        layout.headerHeight = ProfileHeaderCollectionReusableView.height
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
    
    private func handleKeyValueCardSelection(dataSource: ProfileDetailDataSource, indexPath: NSIndexPath) {
        switch dataSource.typeOfCell(indexPath) {
        case .CellPhone:
            performQuickAction(.Phone, additionalData: profile.cell_phone)
            
        case .Email:
            performQuickAction(.Email)
            
        case .WorkPhone:
            performQuickAction(.Phone, additionalData: profile.work_phone)
            
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
    
    // MARK: - Notification handlers
    
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
    
    private func reloadInfoCollectionViewData() {
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
            presentMailViewController(
                [profile.email],
                subject: "Hey",
                messageBody: "",
                completionHandler: nil
            )
            
        case .Message:
            var recipient = profile.cell_phone ?? profile.email
            presentMessageViewController(
                [recipient],
                subject: "Hey",
                messageBody: "",
                completionHandler: nil
            )
            
        case .Phone:
            if let number = profile.cell_phone as String? {
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
    
    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(card: Card!) {
        switch card.type {
        case .Skills:
            let skillSelectorViewController = SkillSelectorViewController(nibName: "SkillSelectorViewController", bundle: nil)
            if let skills = (dataSource as ProfileDetailDataSource).skills {
                skillSelectorViewController.preSelectSkills = skills
            }
            let skillsNavController = UINavigationController(rootViewController: skillSelectorViewController)
            navigationController?.presentViewController(skillsNavController, animated: true, completion: nil)

        default:
            break
        }
    }
    
    // MARK: - EditProfileDelegate
    
    func didFinishEditingProfile() {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            if profile.id == loggedInUserProfile.id {
                profile = loggedInUserProfile
                reloadInfoCollectionViewData()
                
                if let dataSource = dataSource as? ProfileDetailDataSource {
                    if let headerView = dataSource.profileHeaderView {
                        headerView.setProfile(profile)
                    }
                }
            }
        }
    }    
}
