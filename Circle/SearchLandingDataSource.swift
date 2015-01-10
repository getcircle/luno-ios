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
    
    private func parseProfileCategories(profileCategories: Array<LandingService.Containers.ProfileCategory>) {
        for category in profileCategories {
            var cardType: Card.CardType
            switch category.display_type {
            case LandingService.Containers.DisplayType.Detail:
                cardType = .People
            default:
                cardType = .Group
            }
            
            // Temp. change for screenshots
            if category.title == "Work Anniversaries" {
                cardType = .Anniversaries
            }
            else if category.title == "Birthdays" {
                cardType = .Birthdays
            }

            var categoryCard = Card(cardType: cardType, title: category.title)
            categoryCard.addContent(content: category.content as [AnyObject])
            categoryCard.contentCount = category.content.count
            appendCard(categoryCard)
        }
    }
    
    private func parseAddressCategories(addressCategories: Array<LandingService.Containers.AddressCategory>) {
        for category in addressCategories {
            var categoryCard = Card(cardType: .Locations, title: category.title)
            categoryCard.addContent(content: category.content as [AnyObject])
            categoryCard.contentCount = category.content.count
            appendCard(categoryCard)
        }
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            LandingService.Actions.getCategories(currentProfile.id) { (profileCategories, addressCategories, error) -> Void in
                if error == nil {
                    self.parseProfileCategories(profileCategories!)
                    self.parseAddressCategories(addressCategories!)
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
//
//    private func setProfiles(profiles: [ProfileService.Containers.Profile], completionHandler: (error: NSError?) -> Void) {
//        // THIS FUNCTION WILL BE REMOVED COMPLETELY AFTER THE BACKEND CHANGES
//        // SO IGNORE THE IMPLMENTATION
//        
//        let filteredList = profiles.filter({ $0.email == AuthViewController.getLoggedInUserProfile()?.email })
//        
//        let directReportsCard = Card(cardType: .Group, title: "Direct Reports")
//        if profiles.count > 0 {
//            directReportsCard.content.append(profiles)
//            directReportsCard.contentCount = profiles.count ?? 0
//        }
//        appendCard(directReportsCard)
//        
//        let peersCard = Card(cardType: .Group, title: "Peers")
//        if profiles.count > 0 {
//            peersCard.content.append(profiles.reverse())
//            peersCard.contentCount = profiles.count ?? 0
//        }
//        appendCard(peersCard)
//        
//        // Calling it here because all this is fake and ideally this will all come from the server
//        addAdditionalData()
//        
//        let profilesList = profiles.reverse()
//        let birthdaysCard = Card(cardType: .Birthdays, title: "Birthdays")
//        birthdaysCard.contentCount = 5
//        if profilesList.count >= 3 {
//            birthdaysCard.content.append(profilesList[0])
//            birthdaysCard.content.append(profilesList[1])
//            birthdaysCard.content.append(profilesList[2])
//        }
//        appendCard(birthdaysCard)
//        completionHandler(error: nil)
//    }
}
