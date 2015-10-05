//
//  LocationDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class LocationDetailViewController:
    DetailViewController,
    CardFooterViewDelegate,
    ProfileCollectionViewCellDelegate
{

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = LocationDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        dataSource.cardFooterDelegate = self
        
        collectionView.delegate = delegate
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.height
        (dataSource as! LocationDetailDataSource).profileCellDelegate = self
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let card = dataSource.cardAtSection(indexPath.section) {
            switch card.type {            
            case .Profiles:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    showProfileDetail(profile)
                }
                break;
                
            case .LocationsAddress:
                presentFullScreenMapView(true)
                break
                
                
            default:
                break
            }
        }
    }

    // MARK: - Present Map View
    
    private func presentFullScreenMapView(animated: Bool) {
        let mapViewController = MapViewController()
        if (dataSource as! LocationDetailDataSource).profileHeaderView != nil {
            mapViewController.location = (dataSource as! LocationDetailDataSource).location
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
    
    // MARK: - CardFooterDelegate
    
    func cardFooterTapped(card: Card!) {
        let officeDetailDataSource = dataSource as! LocationDetailDataSource
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
                viewController.title = "People @ " + officeDetailDataSource.location.name
                (viewController.dataSource as! ProfilesDataSource).configureForLocation(
                    officeDetailDataSource.location.id,
                    setupOnlySearch: true
                )

                navigationController?.pushViewController(viewController, animated: true)
                
            default:
                break
            }
            
        default:
            break
        }
    }
    
    // Image Upload

    internal override func handleImageUpload(completion: () -> Void) {
        let dataSource = (self.dataSource as! LocationDetailDataSource)
        if let newImage = imageToUpload {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Media.Actions.uploadImage(
                newImage,
                forMediaType: .Location,
                withKey: dataSource.location.id
            ) { (mediaURL, error) -> Void in
                if let mediaURL = mediaURL {
                    let locationBuilder = try! dataSource.location.toBuilder()
                    locationBuilder.imageUrl = mediaURL
                    Services.Organization.Actions.updateLocation(try! locationBuilder.build()) { (location, error) -> Void in
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
        if let dataSource = dataSource as? LocationDetailDataSource, headerView = dataSource.profileHeaderView {
            headerView.setLocation(dataSource.location)
        }
    }
    
    // MARK - ProfileCollectionViewCellDelegate
    
    func onProfileAddButton(checked: Bool) {
        if let officeDataSource = dataSource as? LocationDetailDataSource, 
            loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile()
        {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            let pointsOfContact = NSMutableOrderedSet(array: officeDataSource.location.pointsOfContact)
            if checked {
                pointsOfContact.addObject(loggedInUserProfile)
                hud.labelText = "Adding you as a point of contact"
            }
            else {
                pointsOfContact.removeObject(loggedInUserProfile)
            }
            
            let locationBuilder = try! (dataSource as! LocationDetailDataSource).location.toBuilder()
            locationBuilder.pointsOfContact = pointsOfContact.array as! Array<Services.Profile.Containers.ProfileV1>
            Services.Organization.Actions.updateLocation(try! locationBuilder.build(), completionHandler: { (location, error) -> Void in
                hud.hide(true)
                if let location = location where error == nil {
                    officeDataSource.location = location
                    self.loadData()
                }
            })
        }
    }
    
    // MARK: - TextInputViewControllerDelegate
    
    override func onTextInputValueUpdated(updatedObject: AnyObject?) {
        if let location = updatedObject as? Services.Organization.Containers.LocationV1 {
            (dataSource as! LocationDetailDataSource).location = location
        }
        
        super.onTextInputValueUpdated(updatedObject)
    }
}
