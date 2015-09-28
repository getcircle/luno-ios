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
    private(set) var searchAttributeValue: String?
    
    private var card: Card!
    internal var cardType: Card.CardType = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? .ProfilesGrid : .Profiles
    private var data = [AnyObject]()
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 70.0, 0.0, 20.0)
    }
    
    // MARK: - Configuration
    
    func configureForLocation(locationId: String, setupOnlySearch: Bool) {
        if !setupOnlySearch {
            let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
            requestBuilder.locationId = locationId
            configureForParameters(requestBuilder)
        }

        searchAttribute = .LocationId
        searchAttributeValue = locationId
    }

    func configureForTeam(teamId: String, setupOnlySearch: Bool) {
        if !setupOnlySearch {
            let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
            requestBuilder.teamId = teamId
            configureForParameters(requestBuilder)
        }
        
        searchAttribute = .TeamId
        searchAttributeValue = teamId
    }
    
    func configureForDirectReports(profile: Services.Profile.Containers.ProfileV1) {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
        requestBuilder.managerId = profile.id
        configureForParameters(requestBuilder)
    }

    func configureForOrganization() {
        let requestBuilder = Services.Profile.Actions.GetProfiles.RequestV1.Builder()
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
        let requestBuilder = Services.Group.Actions.GetMembers.RequestV1.Builder()
        requestBuilder.groupId = group.id
        requestBuilder.role = role
        let client = ServiceClient(serviceName: "group")
        let serviceRequest = client.buildRequest(
            "get_members",
            extensionField: Services.Registry.Requests.Group.getMembers(),
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
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType? = nil) {
        data.appendContentsOf(content)
        if let type = ofType {
            cardType = type
        }
    }
    
    override func setInitialData(content content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: Soa.ServiceRequestV1?) {
        registerNextRequest(nextRequest: withNextRequest)
        setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Initial Data
    
    override func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        super.loadInitialData(completionHandler)
        
        card = Card(cardType: cardType, title: "")
        if cardType == .ProfilesGrid {
            card.sectionInset = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
        }
        else {
            card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }
        
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Profile.getProfiles()
            ) as? Services.Profile.Actions.GetProfiles.ResponseV1
            let membersResponse = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Group.getMembers()
            ) as? Services.Group.Actions.GetMembers.ResponseV1
            
            if let profiles = response?.profiles {
                self.data.appendContentsOf(profiles as [AnyObject])
                self.card.addContent(content: profiles)
                self.handleNewContentAddedToCard(self.card, newContent: profiles)
            }
            else if let members = membersResponse?.members {
                var profiles = Array<Services.Profile.Containers.ProfileV1>()
                for member in members {
                    profiles.append(member.profile)
                }
                self.data.appendContentsOf(profiles as [AnyObject])
                self.card.addContent(content: profiles)
                self.handleNewContentAddedToCard(self.card, newContent: profiles)
            }
        }
        
        appendCard(card)
        card.addContent(content: data)
        if data.count > 0 {
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
            category: .Profiles,
            attribute: searchAttribute,
            attributeValue: searchAttributeValue,
            completionHandler: { (query, results, error) -> Void in
                
                var resultProfiles = Array<Services.Profile.Containers.ProfileV1>()
                if let results = results {
                    for result in results {
                        if let profile = result.profile {
                            resultProfiles.append(profile)
                        }
                    }
                }

                self.card.resetContent(resultProfiles)
                completionHandler(error: error)
                return
            }
        )
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(data)
        completionHandler()
    }
}
