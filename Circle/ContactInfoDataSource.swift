//
//  ContactInfoDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 3/31/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ContactInfoDataSource: CardDataSource {
    
    var profile: Services.Profile.Containers.ProfileV1!
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        let card = Card(cardType: .KeyValue, title: "Info")
        card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
        card.showContentCount = false
        
        var content = [[String: AnyObject]]()
        
        // Add explicit row for Work Email
        let emailKeyValueDict: [String: AnyObject] = [
            "key": "work_email",
            "name": "Email",
            "value": profile.email,
            "type": Int(Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1.Email.rawValue)
        ]
        content.append(emailKeyValueDict)
        
        for contactMethod in profile.contactMethods {
            var dataDict: [String: AnyObject] = [
                "key": contactMethod.label,
                "name": contactMethod.label,
                "value": contactMethod.value,
                "type": Int(contactMethod.contactMethodType.rawValue),
            ]
            content.append(dataDict)
        }
        
        if content.count > 0 {
            card.addContent(content: content)
        }
        appendCard(card)
        completionHandler(error: nil)
    }
    
    func heightOfContactInfoSection() -> CGFloat {
        return KeyValueCollectionViewCell.height * CGFloat((profile.contactMethods.count + 1))
    }
    
}
