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

class OfficeDetailViewController:
    DetailViewController,
    CardHeaderViewDelegate,
    CardFooterViewDelegate,
    ProfileSelectorDelegate
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
        dataSource.cardHeaderDelegate = self
        dataSource.cardFooterDelegate = self
        
        collectionView.delegate = delegate
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.heightWithoutSecondaryInfo
        (dataSource as! OfficeDetailDataSource).editImageButtonDelegate = self
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let officeDetailDataSource = dataSource as! OfficeDetailDataSource
        if let card = dataSource.cardAtSection(indexPath.section) {
            switch card.type {            
            case .Profiles:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    showProfileDetail(profile)
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
        if let profileHeaderView = (dataSource as! OfficeDetailDataSource).profileHeaderView {
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
    
    // MARK: - Notifications
    
    override func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "loadData",
            name: LocationServiceNotifications.onLocationUpdatedNotification,
            object: nil
        )
    }
    
    override func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: LocationServiceNotifications.onLocationUpdatedNotification,
            object: nil
        )
    }

    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        let officeDetailDataSource = dataSource as! OfficeDetailDataSource
        switch card.type {
        case .TextValue:
            if card.content.count > 0 {
                if let data = card.content.first as? TextData {
                    switch data.type {
                    case .LocationDescription:
                        let editDescriptionViewController = EditLocationDescriptionViewController(addCharacterLimit: false, withDelegate: self)
                        editDescriptionViewController.location = (dataSource as! OfficeDetailDataSource).location
                        let editDescriptionViewNavController = UINavigationController(
                            rootViewController: editDescriptionViewController
                        )
                        navigationController?.presentViewController(
                            editDescriptionViewNavController,
                            animated: true,
                            completion: nil
                        )
                        
                    default:
                        break
                    }
                }
            }
            break
            
        case .Profiles:
            switch card.subType {
            case .PointsOfContact:
                let profilesSelectorViewController = ProfilesSelectorViewController()
                (profilesSelectorViewController.dataSource as! ProfilesDataSource).configureForLocation(
                    officeDetailDataSource.location.id
                )
                if let profiles = card.allContent as? Array<Services.Profile.Containers.ProfileV1> {
                    profilesSelectorViewController.selectedProfiles = profiles
                }
                profilesSelectorViewController.addSearchFilterView = false
                profilesSelectorViewController.profileSelectorDelegate = self
                profilesSelectorViewController.title = "Points of Contact"
                let addMemberNavController = UINavigationController(rootViewController: profilesSelectorViewController)
                navigationController?.presentViewController(addMemberNavController, animated: true, completion: nil)
                
            default:
                break
            }
            
        default:
            break
        }
    }
    
    // MARK: - CardFooterDelegate
    
    func cardFooterTapped(card: Card!) {
        let officeDetailDataSource = dataSource as! OfficeDetailDataSource
        switch card.type {
        case .Profiles:
            switch card.subType {
            case .Members:
                let viewController = ProfilesViewController()
                viewController.dataSource.setInitialData(
                    content: card.allContent,
                    ofType: nil,
                    nextRequest: officeDetailDataSource.nextProfilesRequest
                )
                viewController.title = "People @ " + officeDetailDataSource.location.address.city
                (viewController.dataSource as! ProfilesDataSource).configureForLocation(
                    officeDetailDataSource.location.id
                )
                trackCardHeaderTapped(card, overviewType: .Profiles)
                navigationController?.pushViewController(viewController, animated: true)
                
            default:
                break
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
        if let dataSource = dataSource as? OfficeDetailDataSource, headerView = dataSource.profileHeaderView {
            headerView.setOffice(dataSource.location)
        }
    }
    
    // MARK: - ProfilesSelectorDelegate
    
    func onSelectedProfiles(profiles: Array<Services.Profile.Containers.ProfileV1>) -> Bool {
        if let presentedViewController = presentedViewController, officeDataSource = dataSource as? OfficeDetailDataSource {
            let hud = MBProgressHUD.showHUDAddedTo(presentedViewController.view, animated: true)
            let locationBuilder = (dataSource as! OfficeDetailDataSource).location.toBuilder()
            locationBuilder.pointsOfContact = profiles
            
            Services.Organization.Actions.updateLocation(locationBuilder.build(), completionHandler: { (location, error) -> Void in
                hud.hide(true)
                if let location = location where error == nil {
                    officeDataSource.location = location
                    self.loadData()
                    presentedViewController.dismissViewControllerAnimated(true, completion: nil)
                }
            })
            
            return false
        }
        
        return true
    }
}
