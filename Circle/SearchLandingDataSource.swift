//
//  SearchLandingDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class SearchLandingDataSource: CardDataSource {
    
    override func loadData() {
        // THIS FUNCTION WILL BE REMOVED COMPLETELY AFTER THE BACKEND CHANGES
        // SO IGNORE THE IMPLMENTATION
        
        if let pfUser = PFUser.currentUser() {
            
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.orderByAscending("firstName")
            parseQuery.findObjectsInBackgroundWithBlock({ (objects, error: NSError!) -> Void in
                if error == nil {
                    self.setPeople(objects)
                }
            })
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
        
        var locationsCard = Card(cardType: .Locations, title: "Locations")
        locationsCard.contentCount = 6
        // Once we have the backend in place, these would be Location model objects
        locationsCard.content.append(["name": "San Francisco, CA", "address": "155 5th Street, 7th Floor", "count": "375"])
        locationsCard.content.append(["name": "Nashville, TN", "address": "Cummins Station", "count": "48"])
        locationsCard.content.append(["name": "London, UK", "address": "344-354 Gray's Inn Road", "count": "18"])
        appendCard(locationsCard)
    }
    
    private func setPeople(objects: [AnyObject]!) {
        // THIS FUNCTION WILL BE REMOVED COMPLETELY AFTER THE BACKEND CHANGES
        // SO IGNORE THE IMPLMENTATION
        
        let people = objects as? [Person]
        let filteredList = people?.filter({ $0.email == PFUser.currentUser().email })
        if filteredList?.count == 1 {
            // loggedInPerson = filteredList?[0]
        }
        
        let directReportsCard = Card(cardType: .People, title: "Direct Reports")
        if people?.count > 0 {
            directReportsCard.content.append(people!)
            directReportsCard.contentCount = people?.count ?? 0
        }
        appendCard(directReportsCard)
        
        let peersCard = Card(cardType: .People, title: "Peers")
        if people?.count > 0 {
            peersCard.content.append(people!.reverse())
            peersCard.contentCount = people?.count ?? 0
        }
        appendCard(peersCard)
        
        // Calling it here because all this is fake and ideally this will all come from the server
        addAdditionalData()
        
        let peopleList = people!.reverse()
        let birthdaysCard = Card(cardType: .Birthdays, title: "Birthdays")
        birthdaysCard.contentCount = 5
        if peopleList.count >= 3 {
            birthdaysCard.content.append(peopleList[0])
            birthdaysCard.content.append(peopleList[1])
            birthdaysCard.content.append(peopleList[2])
        }
        appendCard(birthdaysCard)
        
        collectionView.reloadData()
    }
}