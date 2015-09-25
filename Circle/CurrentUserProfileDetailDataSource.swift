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
            
            // Add a different placeholder when current user is looking at it
            if let textData = card.content.first as? TextData {
                textData.placeholder = NSLocalizedString("Add details", comment: "Generic text asking user to add details")
                card.resetContent()
                card.addContent(content: [textData])
            }
            return card
        }
        
        return nil
    }
}
