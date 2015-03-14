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
    
    private var card: Card!
    private var cardType: Card.CardType = .Team
    private var teams = Array<OrganizationService.Containers.Team>()
    
    // MARK: - Configuration
    
    func configureForLocation(locationId: String) {
        let requestBuilder = OrganizationService.GetTeams.Request.builder()
        requestBuilder.location_id = locationId
        
    }
    
    private func configureForParameters(requestBuilder: AbstractMessageBuilder) {
        let client = ServiceClient(serviceName: "organization")
        let serviceRequest = client.buildRequest(
            "get_teams",
            extensionField: OrganizationServiceRequests_get_teams,
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        )
        if nextRequest == nil {
            registerNextRequest(nextRequest: serviceRequest)
        }
    }
    
    // MARK: - Set Initial Data

    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        teams.extend(content as [OrganizationService.Containers.Team])
        if ofType != nil {
            cardType = ofType!
        }
    }
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: ServiceRequest?) {
        registerNextRequest(nextRequest: withNextRequest)
        setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Data

    override func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        super.loadInitialData(completionHandler)
        
        card = Card(cardType: cardType, title: "")
        card.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                OrganizationServiceRequests_get_teams
            ) as? OrganizationService.GetTeams.Response
            
            if let teams = response?.teams {
                self.teams.extend(teams)
                self.card.addContent(content: teams)
                self.handleNewContentAddedToCard(self.card, newContent: teams)
            }
        }
        
        appendCard(card)
        card.addContent(content: teams)
        if teams.count > 0 {
            completionHandler(error: nil)
        } else {
            if canTriggerNextRequest() {
                triggerNextRequest { () -> Void in
                    completionHandler(error: nil)
                }
            }
        }
    }
}
