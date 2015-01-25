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

    private(set) var locations = Array<OrganizationService.Containers.Address>()
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        let cardType = ofType != nil ? ofType : .Locations
        let locationsCard = Card(cardType: cardType!, title: "")
        locationsCard.addContent(content: content)
        locationsCard.sectionInset = UIEdgeInsetsZero        
        locations.extend(content as Array<OrganizationService.Containers.Address>)
        appendCard(locationsCard)
    }
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Currently all the content is loaded and passed to this view controller
        // So, directly call the completion handler
        completionHandler(error: nil)
    }
}
