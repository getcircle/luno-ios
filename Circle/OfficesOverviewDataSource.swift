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

    private(set) var offices = Array<Services.Organization.Containers.LocationV1>()
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        let cardType = ofType != nil ? ofType : .Offices
        let officesCard = Card(cardType: cardType!, title: "")
        officesCard.addContent(content: content)
        officesCard.sectionInset = UIEdgeInsetsZero        
        offices.extend(content as! Array<Services.Organization.Containers.LocationV1>)
        appendCard(officesCard)
    }
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Currently all the content is loaded and passed to this view controller
        // So, directly call the completion handler
        completionHandler(error: nil)
    }
}
