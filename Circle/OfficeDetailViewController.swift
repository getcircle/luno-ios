//
//  OfficeDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class OfficeDetailViewController: DetailViewController,
    CardFooterViewDelegate,
    CardHeaderViewDelegate
{

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = OfficeDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        dataSource.cardFooterDelegate = self
        dataSource.cardHeaderDelegate = self
        
        collectionView.delegate = delegate
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.height
        (dataSource as! OfficeDetailDataSource).editImageButtonDelegate = self
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let officeDetailDataSource = dataSource as! OfficeDetailDataSource
        if let card = dataSource.cardAtSection(indexPath.section) {
            switch card.type {
            case .KeyValue:
                switch officeDetailDataSource.typeOfContent(indexPath) {
                case .PeopleCount:
                    let viewController = ProfilesViewController()
                    (viewController.dataSource as! ProfilesDataSource).configureForLocation(officeDetailDataSource.location.id)
                    viewController.dataSource.setInitialData(
                        content: officeDetailDataSource.profiles,
                        ofType: nil,
                        nextRequest: officeDetailDataSource.nextProfilesRequest
                    )
                    viewController.title = "People @ " + officeDetailDataSource.location.address.city
                    navigationController?.pushViewController(viewController, animated: true)
                    
                default:
                    break
                }
            
            case .Profiles:
                if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                    showTeamDetail(team)
                }
                break;
                
            case .OfficeAddress:
                presentFullScreenMapView(true)
                break
                
                
            default:
                break
            }
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (dataSource as! OfficeDetailDataSource).profileHeaderView as? ProfileHeaderCollectionReusableView {
            profileHeaderView.adjustViewForScrollContentOffset(scrollView.contentOffset)
        }
    }
    
    // MARK: - Present Map View
    
    private func presentFullScreenMapView(animated: Bool) {
        var mapViewController = MapViewController()
        if let headerView = (dataSource as! OfficeDetailDataSource).profileHeaderView {
            mapViewController.location = (dataSource as! OfficeDetailDataSource).location
            presentViewController(mapViewController, animated: animated, completion: nil)
        }
    }
    
    // MARK: - CardFooterViewDelegate
    
    func cardFooterTapped(card: Card!) {
        card.toggleShowingFullContent()
        collectionView.reloadSections(NSIndexSet(index: card.cardIndex))
    }
    
    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        let officeDetailDataSource = dataSource as! OfficeDetailDataSource
        switch card.type {
        case .Profiles:
            if card.content.count > 0 {
                if let team = card.content.first as? Services.Organization.Containers.TeamV1 {
                    let viewController = TeamsOverviewViewController()
                    viewController.dataSource.setInitialData(
                        content: card.allContent,
                        ofType: nil,
                        nextRequest: officeDetailDataSource.nextTeamsRequest
                    )
                    viewController.title = card.title
                    trackCardHeaderTapped(card, overviewType: .Teams)
                    navigationController?.pushViewController(viewController, animated: true)
                }
                else if let profile = card.content.first as? Services.Profile.Containers.ProfileV1 {
                    let viewController = ProfilesViewController()
                    viewController.dataSource.setInitialData(
                        content: card.allContent,
                        ofType: nil,
                        nextRequest: officeDetailDataSource.nextProfilesRequest
                    )
                    viewController.title = card.title
                    trackCardHeaderTapped(card, overviewType: .Profiles)
                    navigationController?.pushViewController(viewController, animated: true)                
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: - Tracking
    
    func trackCardHeaderTapped(card: Card, overviewType: TrackerProperty.OverviewType) {
        let properties = [
            TrackerProperty.withKeyString("card_type").withString(card.type.rawValue),
            TrackerProperty.withKey(.Source).withSource(.Detail),
            TrackerProperty.withKey(.SourceDetailType).withDetailType(.Office),
            TrackerProperty.withKey(.Destination).withSource(.Overview),
            TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(overviewType),
            TrackerProperty.withKeyString("card_title").withString(card.title),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        Tracker.sharedInstance.track(.CardHeaderTapped, properties: properties)
    }
    
    // Image Upload

    internal override func handleImageUpload(completion: () -> Void) {
        let dataSource = (self.dataSource as! OfficeDetailDataSource)
        if let newImage = imageToUpload {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Media.Actions.uploadImage(
                newImage,
                forMediaType: .Location,
                withKey: dataSource.location.id
            ) { (mediaURL, error) -> Void in
                if let mediaURL = mediaURL {
                    let locationBuilder = dataSource.location.toBuilder()
                    locationBuilder.imageUrl = mediaURL
                    Services.Organization.Actions.updateLocation(locationBuilder.build()) { (location, error) -> Void in
                        if let location = location {
                            dataSource.location = location
                            hud.hide(true)
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    internal override func reloadHeader() {
        if let dataSource = dataSource as? OfficeDetailDataSource {
            if let headerView = dataSource.profileHeaderView as? ProfileHeaderCollectionReusableView {
                headerView.setOffice(dataSource.location)
            }
        }
    }
}
