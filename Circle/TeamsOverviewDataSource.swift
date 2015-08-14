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
    private var cardType: Card.CardType = .Profiles
    private(set) var searchAttribute: Services.Search.Containers.Search.AttributeV1?
    private(set) var searchAttributeValue: String?
    private var teams = Array<Services.Organization.Containers.TeamV1>()
    
    // MARK: - Configuration

    func configureForTeam(teamId: String, setupOnlySearch: Bool) {
        if !setupOnlySearch {
            let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
            requestBuilder.teamId = teamId
            configureForParameters(requestBuilder)
        }
        
        searchAttribute = .TeamId
        searchAttributeValue = teamId
    }

    func configureForOrganization() {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.builder()
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
        
        var sectionInset = UIEdgeInsetsZero        
        
        card = Card(cardType: cardType, title: "")
        card.sectionInset = sectionInset
        
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
        Services.Search.Actions.search(
            query,
            category: .Teams,
            attribute: searchAttribute,
            attributeValue: searchAttributeValue,
            completionHandler: { (query, results, error) -> Void in
                
                var resultTeams = Array<Services.Organization.Containers.TeamV1>()
                if let results = results {
                    for result in results {
                        if let team = result.team {
                            resultTeams.append(team)
                        }
                    }
                }
                
                self.card.resetContent(resultTeams)
                completionHandler(error: error)
                return
            }
        )
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(teams)
        completionHandler()
    }
    
}
