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

    private var profiles = Array<ProfileService.Containers.Profile>()
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        let cardType = ofType != nil ? ofType : .Profiles
        let profilesCard = Card(cardType: cardType!, title: "")
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
        profilesCard.addContent(content: content)
        appendCard(profilesCard)
    }
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: ServiceRequest?) {
        registerNextRequest(nextRequest: withNextRequest)
        self.setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Data
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        completionHandler(error: nil)
    }
    
}
