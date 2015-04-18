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
        for contactMethod in profile.contact_methods {
            var dataDict: [String: AnyObject] = [
                "key": contactMethod.label,
                "name": contactMethod.label,
                "value": contactMethod.value,
                "type": Int(contactMethod.type.rawValue),
            ]
            card.addContent(content: [dataDict])
        }
        appendCard(card)
        completionHandler(error: nil)
    }
    
    func heightOfContactInfoSection() -> CGFloat {
        return KeyValueCollectionViewCell.height * CGFloat(profile.contact_methods.count)
    }
    
}
