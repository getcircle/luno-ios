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
            completionHandler(error: nil)
            return
        }
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            LandingService.Actions.getCategories(currentProfile.id) { (categories, error) -> Void in
                if error == nil {
                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        if category.profiles.count > 0 {
                            var profiles = category.profiles
                            var maxVisibleItems = 0
                            switch category.type {
                            case .Birthdays, .Anniversaries, .NewHires:
                                // HACK: limit the number of results in a card to 3 until we can get smarter about displaying them on the detail view
                                maxVisibleItems = 3
                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: maxVisibleItems)
                        } else if category.addresses.count > 0 {
                            // don't display locations on the search landing page
                            continue
                        } else if category.tags.count > 0 {
                            categoryCard.addContent(content: category.tags, maxVisibleItems: 10)
                            categoryCard.addDefaultFooter()
                        }
                        self.appendCard(categoryCard)
                    }
                    completionHandler(error: nil)
                }
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }

}
