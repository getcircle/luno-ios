//
//  ProfilesDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfilesDataSource: CardDataSource {

    private(set) var searchAttribute: SearchService.Attribute?
    private(set) var searchAttributeValue: AnyObject?
    
    private var card: Card!
    private var cardType: Card.CardType = .Profiles
    private var profiles = Array<ProfileService.Containers.Profile>()
    
    // MARK: - Configuration
    
    func configureForLocation(locationId: String) {
        let requestBuilder = ProfileService.GetProfiles.Request.builder()
        requestBuilder.location_id = locationId
        searchAttribute = .LocationId
        searchAttributeValue = locationId
        configureForParameters(requestBuilder)
    }
    
    private func configureForParameters(requestBuilder: AbstractMessageBuilder) {
        let client = ServiceClient(serviceName: "profile")
        let serviceRequest = client.buildRequest(
            "get_profiles",
            extensionField: ProfileServiceRequests_get_profiles,
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        )
        if nextRequest == nil {
            registerNextRequest(nextRequest: serviceRequest)
        }
    }
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        profiles.extend(content as [ProfileService.Containers.Profile])
        if ofType != nil {
            cardType = ofType!
        }
    }
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: ServiceRequest?) {
        registerNextRequest(nextRequest: withNextRequest)
        setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Initial Data
    
    override func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        super.loadInitialData(completionHandler)
        
        card = Card(cardType: cardType, title: "")
        card.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0)
        
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                ProfileServiceRequests_get_profiles
            ) as? ProfileService.GetProfiles.Response
            
            if let profiles = response?.profiles {
                self.profiles.extend(profiles)
                self.card.addContent(content: profiles)
                self.handleNewContentAddedToCard(self.card, newContent: profiles)
            }
        }
        
        appendCard(card)
        card.addContent(content: profiles)
        if profiles.count > 0 {
            completionHandler(error: nil)
        } else {
            if canTriggerNextRequest() {
                triggerNextRequest {
                    completionHandler(error: nil)
                }
            }
        }
    }
    
    // MARK: - Filtering
    
    override func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {
        // XXX handle all cases where we're using this view controller (birthdays, anniversaries etc.)
        if searchAttribute != nil && searchAttributeValue != nil {
            SearchService.Actions.search(
                query,
                category: .People,
                attribute: searchAttribute!,
                attributeValue: searchAttributeValue!
            ) { (result, error) -> Void in
                self.card.resetContent(result?.profiles ?? [])
                completionHandler(error: error)
            }
        } else {
            // XXX some actual error handling here
            completionHandler(error: nil)
        }
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(profiles)
        completionHandler()
    }
    
}
