//
//  TeamsOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/23/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamsOverviewDataSource: CardDataSource {
    
    private var teams = Array<OrganizationService.Containers.Team>()
    
    // MARK: - Set Initial Data

    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        let cardType = ofType != nil ? ofType : .Team
        let teamsCard = Card(cardType: cardType!, title: "")
        teamsCard.addContent(content: content)
        teamsCard.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        appendCard(teamsCard)
    }
    
    // MARK: - Load Data

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        completionHandler(error: nil)
    }
}
