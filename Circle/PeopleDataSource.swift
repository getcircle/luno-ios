//
//  PeopleDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class PeopleDataSource: CardDataSource {

    private var people = [Person]()
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if let pfUser = PFUser.currentUser() {
            
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.orderByAscending("firstName")
            parseQuery.findObjectsInBackgroundWithBlock({ (objects, error: NSError!) -> Void in
                if error == nil {
                    let peopleCard = Card(cardType: .People, title: "Direct Reports")
                    self.people = objects as [Person]
                    peopleCard.content.extend(objects)
                    self.appendCard(peopleCard)
                    completionHandler(error: nil)
                }
            })
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let personCell = cell as? PersonCollectionViewCell {
            personCell.sizeMode = .Medium
            personCell.subTextLabel.text = people[indexPath.row].title
        }
    }
}
