//
//  OrganizationDetailCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/22/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class OrganizationDetailCollectionViewDelegate: ProfileCollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemSize = super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
        
        let card = cardDataSource(collectionView).cardAtSection(indexPath.section)!
        var leftAndRightInsets = card.sectionInset.left
        leftAndRightInsets += card.sectionInset.right
        if card.type == Card.CardType.People {
            return CGSizeMake(ProfileCollectionViewCell.width - leftAndRightInsets, ProfileCollectionViewCell.height)
        }
        
        return itemSize
    }
}
