//
//  LocationsSearchDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationsSearchDataSource: CardDataSource {
    
    var searchLocation: TrackerProperty.SearchLocation!
    
    private(set) var locations = Array<Services.Organization.Containers.LocationV1>()
    internal var cardType: Card.CardType = .SearchResult
    internal var card: Card!
    private var searchStartTracked = false
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 70.0, 0.0, 20.0)
    }
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        
        if AuthenticationViewController.getLoggedInUserOrganization() != nil {
            Services.Organization.Actions.getLocations() { (locations, error) -> Void in
                self.resetCards()
                self.locations.removeAll(keepCapacity: true)
                
                if let locations = locations {
                    self.card = Card(cardType: self.cardType, title: "")
                    self.card.addContent(content: locations)
                    self.locations.appendContentsOf(locations)
                    self.card.sectionInset = UIEdgeInsetsZero
                    self.appendCard(self.card)
                }
                
                completionHandler(error: nil)
            }
        }
    }
    
    // MARK: - Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.showSeparator = !cellAtIndexPathIsBottomOfSection(indexPath)
        cell.backgroundColor = UIColor.appSearchBackgroundColor()
    }
    
    // MARK: - Filtering
    
    override func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {
        
        if query.characters.count < 2 {
            searchStartTracked = false
        }
        else if query.characters.count >= 2 && !searchStartTracked {
            searchStartTracked = true
            Tracker.sharedInstance.trackSearchStart(
                query: query, 
                searchLocation: searchLocation,
                category: .Locations,
                attribute: nil, 
                value: nil
            )
        }
        
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
