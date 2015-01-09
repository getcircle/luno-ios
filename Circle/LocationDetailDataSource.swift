//
//  LocationDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationDetailDataSource: CardDataSource {
    
    private var profiles = Array<ProfileService.Containers.Profile>()
    private(set) var profileHeaderView: MapHeaderCollectionReusableView?
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            ProfileService.Actions.getProfiles(currentProfile.team_id) { (profiles, error) -> Void in
                if error == nil {
                    self.profiles.extend(profiles!)
                    let peopleCard = Card(cardType: .People, title: "Direct Reports")
                    peopleCard.content.extend(profiles! as [AnyObject])
                    self.appendCard(peopleCard)
                    completionHandler(error: nil)
                } else {
                    completionHandler(error: error)
                }
            }
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let profileCell = cell as? ProfileCollectionViewCell {
            profileCell.sizeMode = .Medium
            profileCell.subTextLabel.text = profiles[indexPath.row].title
        }
    }
    
    // MARK: - Supplementary View

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "MapHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: MapHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: MapHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
                ) as MapHeaderCollectionReusableView
            

            profileHeaderView = supplementaryView
            return supplementaryView
    }
}
