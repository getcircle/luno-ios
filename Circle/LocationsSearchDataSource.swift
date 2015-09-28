//
//  LocationsSearchDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationsSearchDataSource: LocationsOverviewDataSource {
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 70.0, 0.0, 20.0)
    }
    
    override init() {
        super.init()
        
        cardType = .SearchResult
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.appSearchBackgroundColor()
    }
    
    // MARK: - Filtering
    
    override func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {
        Services.Search.Actions.search(
            query,
            category: .Locations,
            attribute: nil,
            attributeValue: nil,
            completionHandler: { (query, results, error) -> Void in
                
                var resultLocations = Array<Services.Organization.Containers.LocationV1>()
                if let results = results {
                    for result in results {
                        if let team = result.location {
                            resultLocations.append(team)
                        }
                    }
                }
                
                self.card.resetContent(resultLocations)
                completionHandler(error: error)
                return
            }
        )
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(locations)
        completionHandler()
    }
}
