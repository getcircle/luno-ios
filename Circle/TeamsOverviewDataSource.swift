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
    private var teams = Array<Services.Organization.Containers.TeamV1>()
    
    // MARK: - Configuration
    
    func configureForLocation(locationId: String) {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.builder()
        requestBuilder.locationId = locationId
        configureForParameters(requestBuilder)
    }
    
    func configureForOrganization() {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.builder()
        let organizationId = AuthViewController.getLoggedInUserOrganization()!.id
        requestBuilder.organizationId = organizationId
        configureForParameters(requestBuilder)
    }
    
    private func configureForParameters(requestBuilder: AbstractMessageBuilder) {
        let client = ServiceClient(serviceName: "organization")
        let serviceRequest = client.buildRequest(
            "get_teams",
            extensionField: Services.Registry.Requests.Organization.getTeams(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        )
        if nextRequest == nil {
            registerNextRequest(nextRequest: serviceRequest)
        }
    }
    
    // MARK: - Set Initial Data

    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        teams.extend(content as! [Services.Organization.Containers.TeamV1])
        if ofType != nil {
            cardType = ofType!
        }
    }
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: Soa.ServiceRequestV1?) {
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
                Services.Registry.Requests.Organization.getTeams()
            ) as? Services.Organization.Actions.GetTeams.ResponseV1
            
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
    
    // MARK: - Filtering
    
    override func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {
        Services.Search.Actions.search(query, category: .Teams, attribute: nil, attributeValue: nil) { (result, error) -> Void in
            self.card.resetContent(result?.teams ?? [])
            completionHandler(error: error)
        }
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(teams)
        completionHandler()
    }
    
}
