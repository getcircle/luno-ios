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
        delegate = OrganizationDetailCollectionViewDelegate()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        dataSource.registerDefaultCardHeader(collectionView)
        dataSource.cardHeaderDelegate = self
        dataSource.cardFooterDelegate = self
        
        // Delegate
        collectionView.delegate = delegate

        // Header height
        layout.headerHeight = OrganizationHeaderCollectionReusableView.height

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
        if let profileHeaderView = (collectionView!.dataSource as OrganizationDetailDataSource).profileHeaderView {
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
                let titleLabelAlpha = 1.0 - contentOffset.y/(profileHeaderView.nameNavLabel.frameY - 40.0)
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
                profileHeaderView.profileImage.alpha = profileImageAlpha
                profileHeaderView.visualEffectView.alpha = otherViewsAlpha
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        var properties = [
            TrackerProperty.withKeyString("card_type").withString(selectedCard.type.rawValue),
            TrackerProperty.withKeyString("card_title").withString(selectedCard.title),
            TrackerProperty.withKey(.Source).withSource(.Organization),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        
        switch selectedCard.type {
        case .Profiles, .Birthdays, .Anniversaries, .NewHires:
            if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
                let profileVC = ProfileDetailsViewController.forProfile(profile)
                profileVC.hidesBottomBarWhenPushed = true
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Profile))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(profileVC, animated: true)
            }
        case .Group:
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            viewController.dataSource.setInitialData(selectedCard.content[0] as [AnyObject], ofType: nil)
            viewController.title = selectedCard.title
            viewController.hidesBottomBarWhenPushed = true
            properties.append(TrackerProperty.withKey(.Destination).withSource(.Overview))
            properties.append(TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(.Profiles))
            Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Offices:
            if let office = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Location {
                let viewController = OfficeDetailViewController()
                (viewController.dataSource as OfficeDetailDataSource).selectedOffice = office
                viewController.hidesBottomBarWhenPushed = true
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Office))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(viewController, animated: true)
            }

        case .TeamsGrid:
            if let selectedTeam = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Team {
                let viewController = TeamDetailViewController()
                (viewController.dataSource as TeamDetailDataSource).selectedTeam = selectedTeam
                viewController.hidesBottomBarWhenPushed = true
                properties.append(TrackerProperty.withKey(.Destination).withSource(.Detail))
                properties.append(TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Team))
                Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        default:
            break
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(card: Card!) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        switch card.type {
        case .Group, .Profiles, .Birthdays, .Anniversaries, .NewHires:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            if card.type == .Group {
                viewController.dataSource.setInitialData(card.content[0] as [AnyObject], ofType: nil)
            }
            else {
                viewController.dataSource.setInitialData(card.allContent, ofType: card.type)
            }
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = true
            trackCardHeaderTapped(card, overviewType: .Profiles)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Offices:
            let viewController = OfficesOverviewViewController(nibName: "OfficesOverviewViewController", bundle: nil)
            viewController.dataSource.setInitialData(card.allContent, ofType: nil)
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = true
            trackCardHeaderTapped(card, overviewType: .Offices)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .Skills:
            let skillsOverviewViewController = SkillsOverviewViewController(nibName: "SkillsOverviewViewController", bundle: nil)
            skillsOverviewViewController.dataSource.setInitialData(content: card.allContent[0] as [AnyObject])
            skillsOverviewViewController.title = card.title
            skillsOverviewViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(skillsOverviewViewController, animated: true)
        
        case .TeamsGrid:
            let viewController = TeamsOverviewViewController(nibName: "TeamsOverviewViewController", bundle: nil) 
            viewController.dataSource.setInitialData(card.allContent[0] as [AnyObject], ofType: nil)
            viewController.title = card.title
            viewController.hidesBottomBarWhenPushed = true
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
    
    override func didSelectSkill(notification: NSNotification) {
        super.didSelectSkill(notification)
        if let userInfo = notification.userInfo {
            if let selectedSkill = userInfo["skill"] as? ProfileService.Containers.Skill {
                trackSkillSelected(selectedSkill)
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
    
    private func trackSkillSelected(skill: ProfileService.Containers.Skill) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Organization),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Skill),
            TrackerProperty.withDestinationId("skill_id").withString(skill.id)
        ]
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
    
}
