//
//  CurrentUserProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 3/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class CurrentUserProfileDetailDataSource: ProfileDetailDataSource {
    
    override func canEdit() -> Bool {
        return true
    }
    
    override internal func addStatusCard() -> Card? {
        if let card = super.addStatusCard() {
            card.allowEditingContent = true
            return card
        }
        
        return nil
    }
    
    override func populateData() {
        super.populateData()
        Tracker.sharedInstance.trackAdditionalAttributesForUser(team: team, location: location)
    }
}
