//
//  OfficeDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficeDetailViewController: DetailViewController, CardFooterViewDelegate {

    private let offsetToTriggerFullScreenMapView: CGFloat = -100.0
    private var overlayButtonHandlerAdded = false

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = OfficeDetailDataSource()
        delegate = StickyHeaderCollectionViewDelegate()
    }
    
    // MARK: - Configuration

    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        dataSource.registerCardHeader(collectionView)
        dataSource.cardFooterDelegate = self
        
        collectionView.delegate = delegate
        
        layout.headerHeight = ProfileHeaderCollectionReusableView.height
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let officeDetailDataSource = dataSource as OfficeDetailDataSource
        if let card = dataSource.cardAtSection(indexPath.section) {
            switch card.type {
            case .KeyValue:
                switch officeDetailDataSource.typeOfContent(indexPath) {
                case .PeopleCount:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
                    viewController.dataSource.setInitialData(
                        content: officeDetailDataSource.profiles,
                        ofType: nil,
                        nextRequest: officeDetailDataSource.nextProfilesRequest?
                    )
                    viewController.title = "People @ " + officeDetailDataSource.selectedOffice.address.city
                    navigationController?.pushViewController(viewController, animated: true)
                    
                default:
                    break
                }
                
            case .OfficeAddress:
                presentFullScreenMapView(true)
                break
                
                
            default:
                break
            }
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (dataSource as OfficeDetailDataSource).profileHeaderView as? ProfileHeaderCollectionReusableView {
            profileHeaderView.adjustViewForScrollContentOffset(scrollView.contentOffset)
        }
    }
    
    // MARK: - Present Map View
    
    private func presentFullScreenMapView(animated: Bool) {
        var mapViewController = MapViewController()
        if let headerView = (dataSource as OfficeDetailDataSource).profileHeaderView {
            mapViewController.selectedOffice = (dataSource as OfficeDetailDataSource).selectedOffice
            presentViewController(mapViewController, animated: animated, completion: nil)
        }
    }
    
    // MARK: - CardFooterViewDelegate
    
    func cardFooterTapped(card: Card!) {
        card.toggleShowingFullContent()
        collectionView.reloadSections(NSIndexSet(index: card.cardIndex))
    }
}
