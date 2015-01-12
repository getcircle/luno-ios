//
//  SearchQueryDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class SearchQueryDataSource: CardDataSource {
    
    private let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
    
    private var visibleProfiles = Array<ProfileService.Containers.Profile>()
    private var visibleTeams = Array<OrganizationService.Containers.Team>()
    private var visibleAddresses = Array<OrganizationService.Containers.Address>()
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
    }
    
    func filter(string: String, completionHandler: (error: NSError?) -> Void) {
        SearchService.Actions.search(string, completionHandler: { (profiles, teams, addresses) -> Void in
            if let profiles = profiles {
                self.visibleProfiles = profiles
            }
            if let teams = teams {
                self.visibleTeams = teams
            }
            if let addresses = addresses {
                self.visibleAddresses = addresses
            }
            self.updateVisibleCards()
            completionHandler(error: nil)
        })
    }
    
    private func updateVisibleCards() {
        resetCards()
        
        // TODO these should be sorted by relevancy
        // TODO we should be displaying why this card is visible. if you search "ke" and tamara shows up, its confusing at first, then you realize its becuase of "marKEting"
        let peopleCard = Card(cardType: .People, title: "People")
        if visibleProfiles.count > 0 {
            peopleCard.content.extend(visibleProfiles as [AnyObject])
            peopleCard.contentCount = visibleProfiles.count
            peopleCard.sectionInset = UIEdgeInsetsZero
        }
        appendCard(peopleCard)
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "SearchResultsCardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SearchResultsCardHeaderCollectionReusableView
        
        headerView.setCard(cards[indexPath.section])
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
}
