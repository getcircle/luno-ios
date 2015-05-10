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

    private(set) var searchAttribute: Services.Search.Containers.Search.AttributeV1?
    private(set) var searchAttributeValue: AnyObject?
    
    private var card: Card!
    private var cardType: Card.CardType = .Profiles
    private var profiles = Array<Services.Profile.Containers.ProfileV1>()
    
    // MARK: - Configuration
    
    func configureForLocation(locationId: String) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.locationId = locationId
        searchAttribute = .LocationId
        searchAttributeValue = locationId
        configureForParameters(requestBuilder)
    }
    
    func configureForOrganization() {
        let organizationId = AuthViewController.getLoggedInUserOrganization()!.id
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.builder()
        requestBuilder.organizationId = organizationId
        searchAttribute = .OrganizationId
        searchAttributeValue = organizationId
        configureForParameters(requestBuilder)
    }
    
    private func configureForParameters(requestBuilder: AbstractMessageBuilder) {
        let client = ServiceClient(serviceName: "profile")
        let serviceRequest = client.buildRequest(
            "get_profiles",
            extensionField: Services.Registry.Requests.Profile.getProfiles(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        )
        if nextRequest == nil {
            registerNextRequest(nextRequest: serviceRequest)
        }
    }
    
    func configureForGroup(group: Services.Group.Containers.GroupV1, role: Services.Group.Containers.RoleV1) {
        let requestBuilder = Services.Group.Actions.ListMembers.RequestV1.builder()
        requestBuilder.groupId = group.id
        requestBuilder.role = role
        let client = ServiceClient(serviceName: "group")
        let serviceRequest = client.buildRequest(
            "list_members",
            extensionField: Services.Registry.Requests.Group.listMembers(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        )
        if nextRequest == nil {
            registerNextRequest(nextRequest: serviceRequest)
        }
    }
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        profiles.extend(content as! [Services.Profile.Containers.ProfileV1])
        if ofType != nil {
            cardType = ofType!
        }
    }
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: Soa.ServiceRequestV1?) {
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
                Services.Registry.Requests.Profile.getProfiles()
            ) as? Services.Profile.Actions.GetProfiles.ResponseV1
            
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
        Services.Search.Actions.search(
            query,
            category: .People,
            attribute: searchAttribute,
            attributeValue: searchAttributeValue,
            objects: profiles
        ) { (result, error) -> Void in
            self.card.resetContent(result?.profiles ?? [])
            completionHandler(error: error)
        }
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(profiles)
        completionHandler()
    }
}
