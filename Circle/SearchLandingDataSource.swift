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
                            var profiles = category.profiles
                            switch category.type {
                            case .Birthdays, .Anniversaries, .NewHires:
                                // HACK: limit the number of results in a card to 3 until we can get smarter about displaying them on the detail view
                                if profiles.count > 3 {
                                    profiles = Array(profiles[0..<3])
                                }
                            default: break
                            }
                            categoryCard.addContent(content: profiles, allContent: category.profiles)
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
        let tagsNames = ["Python", "Startups", "Investing", "iOS", "Software Development", "Marketing"]
        var tagObjects = Array<ProfileService.Containers.Tag>()

        for tagName in tagsNames {
            var tagObject = ProfileService.Containers.Tag.builder()
            tagObject.name = tagName
            tagObjects.append(tagObject.build())
        }

        tagsCard.content.append(tagObjects)
        appendCard(tagsCard)
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }

}
