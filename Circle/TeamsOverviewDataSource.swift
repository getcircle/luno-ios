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
    
    var searchLocation: TrackerProperty.SearchLocation!

    private var card: Card!
    internal var cardType: Card.CardType = .Profiles
    private(set) var searchAttribute: Services.Search.Containers.Search.AttributeV1?
    private(set) var searchTrackerAttribute: TrackerProperty.SearchAttribute?
    private(set) var searchAttributeValue: String?
    private var searchStartTracked = false
    private var teams = Array<Services.Organization.Containers.TeamV1>()
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 70.0, 0.0, 20.0)
    }
    
    // MARK: - Configuration

    func configureForTeam(teamId: String, setupOnlySearch: Bool) {
        if !setupOnlySearch {
            let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
            requestBuilder.teamId = teamId
            configureForParameters(requestBuilder)
        }
        
        searchAttribute = .TeamId
        searchTrackerAttribute = .TeamId
        searchAttributeValue = teamId
    }

    func configureForOrganization() {
        let requestBuilder = Services.Organization.Actions.GetTeams.RequestV1.Builder()
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
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.showSeparator = !cellAtIndexPathIsBottomOfSection(indexPath)
    }
    
    // MARK: - Set Initial Data

    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        teams.appendContentsOf(content as! [Services.Organization.Containers.TeamV1])
        if ofType != nil {
            cardType = ofType!
        }
    }
    
    override func setInitialData(content content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: Soa.ServiceRequestV1?) {
        registerNextRequest(nextRequest: withNextRequest)
        setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Data

    override func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        super.loadInitialData(completionHandler)
        
        let sectionInset = UIEdgeInsetsZero        
        
        card = Card(cardType: cardType, title: "")
        card.sectionInset = sectionInset
        
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Organization.getTeams()
            ) as? Services.Organization.Actions.GetTeams.ResponseV1
            
            if let teams = response?.teams {
                self.teams.appendContentsOf(teams)
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

        if query.characters.count < 2 {
            searchStartTracked = false
        }
        else if query.characters.count >= 2 && !searchStartTracked {
            searchStartTracked = true
            Tracker.sharedInstance.trackSearchStart(
                query: query,
                searchLocation: searchLocation,
                category: .Teams,
                attribute: searchTrackerAttribute,
                value: searchAttributeValue
            )
        }

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
