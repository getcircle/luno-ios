//
//  ProfileCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class ProfileCollectionViewDelegate: CardCollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(collectionView.frame.size.width, (collectionView.collectionViewLayout as ProfileCollectionViewLayout).headerHeight)
        }
        
        if let card = cardDataSource(collectionView).cardAtSection(section) {
            return card.headerSize
        }
        
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if cardDataSource(collectionView).cardAtSection(indexPath.section)!.type == Card.CardType.People {
            return CGSizeMake(ProfileCollectionViewCell.width, 64.0)
        }
        
        return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    }    
}