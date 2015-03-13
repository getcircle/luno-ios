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

    private var cardType: Card.CardType = .Profiles
    private var profiles = Array<ProfileService.Containers.Profile>()
    
    // MARK: - Configuration
    
    func configureForLocation(locationId: String) {
        let requestBuilder = ProfileService.GetProfiles.Request.builder()
        requestBuilder.location_id = locationId
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
        self.setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Initial Data
    
    override func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        super.loadInitialData(completionHandler)
        
        let profilesCard = Card(cardType: cardType, title: "")
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                ProfileServiceRequests_get_profiles
                ) as? ProfileService.GetProfiles.Response
            
            if let profiles = response?.profiles {
                profilesCard.addContent(content: profiles as [AnyObject])
                self.handleNewContentAddedToCard(profilesCard, newContent: profiles)
            }
        }
        
        profilesCard.sectionInset = UIEdgeInsetsZero
        appendCard(profilesCard)
        if profiles.count > 0 {
            profilesCard.addContent(content: profiles)
            completionHandler(error: nil)
        } else {
            if canTriggerNextRequest() {
                triggerNextRequest {
                    completionHandler(error: nil)
                }
            }
        }
    }
    
}
