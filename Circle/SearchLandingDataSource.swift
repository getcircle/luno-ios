//
//  SearchLandingDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class SearchLandingDataSource: CardDataSource {
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if cards.count > 0 {
            return
        }
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            LandingService.Actions.getCategories(currentProfile.id) { (categories, error) -> Void in
                if error == nil {
                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        if category.profiles.count > 0 {
                            categoryCard.addContent(content: category.profiles)
                        } else if category.addresses.count > 0 {
                            categoryCard.addContent(content: category.addresses)
                        }
                        self.appendCard(categoryCard)
                    }
                    self.addAdditionalData()
                    completionHandler(error: nil)
                }
            }
        }
    }
    
    private func addAdditionalData() {
        // THIS FUNCTION WILL BE REMOVED COMPLETELY AFTER THE BACKEND CHANGES
        // SO IGNORE THE IMPLMENTATION
        
        var tagsCard = Card(cardType: .Tags, title: "Tags")
        tagsCard.contentCount = 30
        var tags = [[String: String]]()
        tags.append(["name": "Python"])
        tags.append(["name": "Startups"])
        tags.append(["name": "Investing"])
        tags.append(["name": "iOS"])
        tags.append(["name": "Software Development"])
        tags.append(["name": "Marketing"])
        tagsCard.content.append(tags)
        appendCard(tagsCard)
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }

}
