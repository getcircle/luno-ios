//
//  OfficesOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficesOverviewDataSource: CardDataSource {
    
    private(set) var locations = Array<Services.Organization.Containers.LocationV1>()
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {

        if let organization = AuthViewController.getLoggedInUserOrganization() {
            Services.Organization.Actions.getLocations(organization.id) { (locations, error) -> Void in
                self.resetCards()
                self.locations.removeAll(keepCapacity: true)
                
                if let locations = locations {
                    let officesCard = Card(cardType: .Offices, title: "")
                    officesCard.addContent(content: locations)
                    self.locations.extend(locations)
                    officesCard.sectionInset = UIEdgeInsetsZero
                    self.appendCard(officesCard)
                }
                
                completionHandler(error: nil)
            }
        }
    }
}
