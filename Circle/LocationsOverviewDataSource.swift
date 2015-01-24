//
//  LocationsOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationsOverviewDataSource: CardDataSource {

    private var locations = Array<OrganizationService.Containers.Address>()
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        let cardType = ofType != nil ? ofType : .Locations
        let locationsCard = Card(cardType: cardType!, title: "")
        locationsCard.content.extend(content)
        locationsCard.sectionInset = UIEdgeInsetsZero
        locationsCard.headerSize = CGSizeMake(
            MapHeaderCollectionReusableView.width,
            UIScreen.mainScreen().bounds.height / 2.0
        )
        
        locations.extend(content as Array<OrganizationService.Containers.Address>)
        appendCard(locationsCard)
    }
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Currently all the content is loaded and passed to this view controller
        // So, directly call the completion handler
        completionHandler(error: nil)
    }
    
    // MARK: - Supplementary View
    
    override func registerCardHeader(collectionView: UICollectionView) {
        
        collectionView.registerNib(
            UINib(nibName: "MapHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: MapHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: MapHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as MapHeaderCollectionReusableView
        
        supplementaryView.setData(locations: locations)
        supplementaryView.allowInteraction = true
        return supplementaryView
    }
}
