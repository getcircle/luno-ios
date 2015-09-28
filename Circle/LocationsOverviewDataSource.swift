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
    
    private(set) var locations = Array<Services.Organization.Containers.LocationV1>()
    internal var cardType: Card.CardType = .Locations
    internal var card: Card!
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {

        if AuthenticationViewController.getLoggedInUserOrganization() != nil {
            Services.Organization.Actions.getLocations() { (locations, error) -> Void in
                self.resetCards()
                self.locations.removeAll(keepCapacity: true)
                
                if let locations = locations {
                    self.card = Card(cardType: self.cardType, title: "")
                    self.card.addContent(content: locations)
                    self.locations.appendContentsOf(locations)
                    self.card.sectionInset = UIEdgeInsetsZero
                    self.appendCard(self.card)
                }
                
                completionHandler(error: nil)
            }
        }
    }
    
    // MARK: - Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.showSeparator = !cellAtIndexPathIsBottomOfSection(indexPath)
    }
}
