//
//  OfficeDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficeDetailViewController: DetailViewController {

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
                    viewController.dataSource.setInitialData(officeDetailDataSource.profiles, ofType: nil)
                    viewController.title = "People @ " + officeDetailDataSource.selectedOffice.city
                    navigationController?.pushViewController(viewController, animated: true)
                    
                default:
                    break
                }
                
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
}
