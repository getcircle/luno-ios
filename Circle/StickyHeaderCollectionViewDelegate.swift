//
//  StickyHeaderCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class StickyHeaderCollectionViewDelegate: CardCollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(collectionView.frame.size.width, (collectionView.collectionViewLayout as StickyHeaderCollectionViewLayout).headerHeight)
        }
        
        if let card = cardDataSource(collectionView).cardAtSection(section) {
            return card.headerSize
        }
        
        return CGSizeZero
    }
}
