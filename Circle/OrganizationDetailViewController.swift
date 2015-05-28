//
//  OrganizationDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OrganizationDetailViewController: DetailViewController, CardHeaderViewDelegate, CardFooterViewDelegate {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()

        dataSource = OrganizationDetailDataSource()
        delegate = CardCollectionViewDelegate()
        layout = UICollectionViewFlowLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var statusBarView = UIView(forAutoLayout: ())
        statusBarView.backgroundColor = UIColor.appUIBackgroundColor()
        view.insertSubview(statusBarView, aboveSubview: collectionView)
        statusBarView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        statusBarView.autoSetDimension(.Height, toSize: 20.0)
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        dataSource.animateContent = true
        collectionView.dataSource = dataSource
        dataSource.cardHeaderDelegate = self
        dataSource.cardFooterDelegate = self
        
        // Delegate
        collectionView.delegate = delegate
        super.configureCollectionView()
    }

    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Organization)
        ]
        Tracker.sharedInstance.trackMajorScrollEvents(
            .ViewScrolled,
            scrollView: scrollView,
            direction: .Vertical,
            properties: properties
        )
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = (collectionView.dataSource as! CardDataSource)
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        var properties = [
            TrackerProperty.withKeyString("card_type").withString(selectedCard.type.rawValue),
            TrackerProperty.withKeyString("card_title").withString(selectedCard.title),
            TrackerProperty.withKey(.Source).withSource(.Organization),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        
        switch selectedCard.type {
        case .Profiles, .Birthdays, .Anniversaries, .NewHires:
            if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                let profileVC = ProfileDetailViewController(profile: profile)
                profileVC.hidesBottomBarWhenPushed = false
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(profileVC, animated: true)
            }
        case .GroupMemberImages:
            let viewController = ProfilesViewController()
            viewController.dataSource.setInitialData(selectedCard.content[0] as! [AnyObject], ofType: nil)
            viewController.title = selectedCard.title
            viewController.hidesBottomBarWhenPushed = false
            properties.append(TrackerProperty.withKey(.Destination).withSource(.Overview))
            properties.append(TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(.Profiles))
            Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Offices:
            if let office = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.LocationV1 {
                let viewController = OfficeDetailViewController()
                (viewController.dataSource as! OfficeDetailDataSource).selectedOffice = office
                viewController.hidesBottomBarWhenPushed = false
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Office))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(viewController, animated: true)
            }

        case .TeamsGrid:
            if let selectedTeam = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                let viewController = TeamDetailViewController()
                (viewController.dataSource as! TeamDetailDataSource).selectedTeam = selectedTeam
                viewController.hidesBottomBarWhenPushed = false
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Team))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .KeyValue:
            if selectedCard.title == AppStrings.ProfileSectionGroupsTitle {
                let groupsViewController = GroupsViewController()
                groupsViewController.title = selectedCard.title
                navigationController?.pushViewController(groupsViewController, animated: true)
            }
            
        default:
            break
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        let dataSource = (collectionView.dataSource as! CardDataSource)
        switch card.type {
        case .GroupMemberImages, .Profiles, .Birthdays, .Anniversaries, .NewHires:
            let viewController = ProfilesViewController()
            if card.type == .GroupMemberImages {
                viewController.dataSource.setInitialData(card.content[0] as! [AnyObject], ofType: nil)
            }
            else {
                viewController.dataSource.setInitialData(card.allContent, ofType: card.type)
            }
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = false
            trackCardHeaderTapped(card, overviewType: .Profiles)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Offices:
            let viewController = OfficesOverviewViewController(nibName: "OfficesOverviewViewController", bundle: nil)
            viewController.dataSource.setInitialData(card.allContent, ofType: nil)
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = false
            trackCardHeaderTapped(card, overviewType: .Offices)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Tags:
            let interestsOverviewViewController = TagsOverviewViewController(nibName: "TagsOverviewViewController", bundle: nil)
            interestsOverviewViewController.dataSource.setInitialData(content: card.allContent[0] as! [AnyObject])
            interestsOverviewViewController.title = card.title
            interestsOverviewViewController.hidesBottomBarWhenPushed = false
            navigationController?.pushViewController(interestsOverviewViewController, animated: true)
        
        case .TeamsGrid:
            let viewController = TeamsOverviewViewController()
            viewController.dataSource.setInitialData(card.allContent[0] as! [AnyObject], ofType: nil)
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = false
            trackCardHeaderTapped(card, overviewType: .Teams)
            navigationController?.pushViewController(viewController, animated: true)

        default:
            break
        }
    }
    
    // MARK: - Card Footer View Delegate
    
    func cardFooterTapped(card: Card!) {
        card.toggleShowingFullContent()
        collectionView.reloadSections(NSIndexSet(index: card.cardIndex))
    }
    
    // MARK: - Notification Handlers
    
    override func didSelectTag(notification: NSNotification) {
        super.didSelectTag(notification)
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["interest"] as? Services.Profile.Containers.TagV1 {
                trackTagSelected(selectedTag)
            }
        }
    }
    
    // MARK: - Tracking

    func trackCardHeaderTapped(card: Card, overviewType: TrackerProperty.OverviewType) {
        let properties = [
            TrackerProperty.withKeyString("card_type").withString(card.type.rawValue),
            TrackerProperty.withKey(.Source).withSource(.Organization),
            TrackerProperty.withKey(.Destination).withSource(.Overview),
            TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(overviewType),
            TrackerProperty.withKeyString("card_title").withString(card.title),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        Tracker.sharedInstance.track(.CardHeaderTapped, properties: properties)
    }
    
    private func trackTagSelected(interest: Services.Profile.Containers.TagV1) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Organization),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Tag),
            TrackerProperty.withDestinationId("tagId").withString(interest.id)
        ]
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
    
}
