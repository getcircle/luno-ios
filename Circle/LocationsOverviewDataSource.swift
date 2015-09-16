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
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {

        if let organization = AuthViewController.getLoggedInUserOrganization() {
            Services.Organization.Actions.getLocations() { (locations, error) -> Void in
                self.resetCards()
                self.locations.removeAll(keepCapacity: true)
                
                if let locations = locations {
                    let officesCard = Card(cardType: .Locations, title: "")
                    officesCard.addContent(content: locations)
                    self.locations.extend(locations)
                    officesCard.sectionInset = UIEdgeInsetsZero
                    self.appendCard(officesCard)
                }
                
                completionHandler(error: nil)
            }
        }
    }
    
    // MARK: - Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let card = cardAtSection(indexPath.section) {
            let isLastCell = (indexPath.row == card.content.count - 1)
            let isLastViewInSection = (isLastCell && !card.addFooter)
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            cell.separatorColor = UIColor.appCardContentSeparatorViewColor()
            cell.showSeparator = !isLastViewInSection
        }
    }
}
