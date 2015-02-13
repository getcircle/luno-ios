//
//  SettingsDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SettingsDataSource: CardDataSource {
 
    override func loadData(completionHandler: (error: NSError?) -> Void) {
     
        var logoutCard = Card(cardType: .Settings, title: "Account", addDefaultFooter: false)
        logoutCard.sectionInset = UIEdgeInsetsMake(25.0, 0.0, 25.0, 0.0)
        logoutCard.addContent(content: [["text": NSLocalizedString("Sign out", comment: "Title of sign out button")]])
        appendCard(logoutCard)
        completionHandler(error: nil)
    }
}
